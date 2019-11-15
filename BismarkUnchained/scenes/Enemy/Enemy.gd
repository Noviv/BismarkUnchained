extends KinematicBody2D

signal enemy_hit

func damage():
	print('hit enemy')

func _process(delta):
	var pos = get_global_position()
	var player_pos = get_node("../../Player/KinematicBody2D").get_global_position()
	var dir = (player_pos - pos).normalized()
	var collision = move_and_collide(dir * get_node("/root/Main").time_delta)
	if collision:
		print("hit")
		dir = dir.bounce(collision.normal)
