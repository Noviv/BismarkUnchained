extends KinematicBody2D

const max_rotation_radians_per_sec = deg2rad(180)

var velocity = Vector2(100, 0)
var homing_object = null

func _ready():
	rotation = velocity.angle()

func _physics_process(delta):
	if homing_object:
		var dir = get_global_position().direction_to(homing_object.get_global_position())
		var angle = dir.angle_to(velocity.normalized())
		var phi = min(max_rotation_radians_per_sec, abs(angle)) * delta
		velocity = velocity.rotated(-phi if angle > 0 else phi)
	
	# Rotation should always be locked to velocity
	rotation = velocity.angle()
	get_node("../Afterburner").global_position = get_global_position() - velocity.normalized() * 7
	
	# Move and check for a collision
	var collision = move_and_collide(velocity * get_node("/root/Main").time_delta * delta)
	if collision:
		if collision.collider.has_method('damage'):
			collision.collider.damage()
		get_parent().explode(collision.position)
		queue_free()
