extends KinematicBody2D

func _physics_process(delta):
	move_and_collide(Vector2(5, 0))

