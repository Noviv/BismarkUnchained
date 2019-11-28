extends KinematicBody2D

var velocity = Vector2(100, 0)

func _ready():
	rotation = velocity.angle()

func _physics_process(delta):
	# Rotation should always be locked to velocity
	rotation = velocity.angle()
	
	# Move and check for a collision
	var collision = move_and_collide(velocity * get_node("/root/Main").time_delta * delta)
	if collision:
		if collision.collider.has_method('damage'):
			collision.collider.damage()
		get_parent().explode(collision.position)
		queue_free()
