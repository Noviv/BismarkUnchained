extends KinematicBody2D

func damage():
	print('hit player')

func _physics_process(delta):
	move_and_collide(Vector2(5, 0))

