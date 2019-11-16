extends KinematicBody2D

var accel = 3750
var max_velocity = 750
var deadzone = 0.1

var curr_velocity = Vector2(0, 0)

func damage():
	print('hit player')

func move(delta):
	#Controller input
	var velocity = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if (velocity.length() < deadzone):
		velocity = Vector2(0, 0)
	if (velocity.length() > 1):
		velocity = velocity.normalized()
	#Cube curving to make small adjustments easier
	velocity = velocity * velocity * velocity
	
	#If no controller input, use keyboard
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
	
	#Finding difference between current and target velocity, and adjusting for acceleration
	velocity = velocity * max_velocity
	var diff_velocity = velocity - curr_velocity
	var new_velocity = curr_velocity + diff_velocity.normalized() * accel * delta
	
	#Checking that new velocity is not greater magnitude than target velocity, and prevents stuttering at extremely low speeds
	if new_velocity.length() > velocity.length():
		new_velocity = velocity
	if new_velocity.length() < 0.5 && velocity.length() == 0:
		new_velocity = velocity
	
	#Executing the movement, setting current velocity for next pass, setting global time_delta
	velocity = new_velocity
	move_and_collide(velocity * delta)
	curr_velocity = velocity
	get_node("/root/Main").set_time_delta(curr_velocity.length() / max_velocity)

func _process(delta):
	move(delta)
