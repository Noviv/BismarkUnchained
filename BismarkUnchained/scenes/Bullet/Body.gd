extends KinematicBody2D

signal collided

var velocity = Vector2(100, 0)

func _physics_process(delta):
	# rotation should always be locked to velocity
	rotation = velocity.angle()
	
	# move and check for a collision
	var kc = move_and_collide(velocity * delta)
	if kc:
		emit_signal('collided', kc.collider)
		get_parent().explode()
		queue_free()
