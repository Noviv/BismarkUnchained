extends KinematicBody2D

var accel = 3750
var max_velocity = 750

var curr_velocity = Vector2(0, 0)

func damage():
	print('hit player')

func _process(delta):
	var velocity = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if (velocity.length() < 0.2):
		velocity = Vector2(0, 0)
	if (velocity.length() > 1):
		velocity = velocity.normalized()
	velocity = velocity * velocity * velocity
	
	if (velocity.length() == 0):
		velocity = Vector2(0, 0)
		if Input.is_action_pressed("player_up"):
			velocity += Vector2(0, -1)
		if Input.is_action_pressed("player_down"):
			velocity += Vector2(0, 1)
		if Input.is_action_pressed("player_left"):
			velocity += Vector2(-1, 0)
		if Input.is_action_pressed("player_right"):
			velocity += Vector2(1, 0)
	
	velocity = velocity * max_velocity
	var diff_velocity = velocity - curr_velocity
	
	var new_velocity = curr_velocity + diff_velocity.normalized() * accel * delta
	if new_velocity.length() > velocity.length():
		new_velocity = velocity
	if new_velocity.length() < 0.5 && velocity.length() == 0:
		new_velocity = velocity
	velocity = new_velocity
	move_and_collide(velocity * delta)
	curr_velocity = velocity
	get_node("/root/Main").time_delta = curr_velocity.length() / max_velocity