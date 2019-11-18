extends KinematicBody2D

var velocity = Vector2(100, 0)

func _physics_process(delta):
	# rotation should always be locked to velocity
	rotation = velocity.angle()
	
	# move and check for a collision
	var kc = move_and_collide(velocity * get_node("/root/Main").time_delta * delta)
	if kc:
		if kc.collider.has_method('damage'):
			kc.collider.damage()
		get_parent().explode(kc.position)
		queue_free()
