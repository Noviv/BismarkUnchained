extends KinematicBody2D

var accel = 3750
var max_velocity = 750
var deadzone = 0.1

var curr_velocity = Vector2(0, 0)
var controller = false
var device = -1

func damage():
	print('hit player')

func move_translate(delta):
	var velocity
	
	#Controller input
	if controller:
		velocity = Vector2(Input.get_joy_axis(device, 0), Input.get_joy_axis(device, 1))
		if (velocity.length() < deadzone):
			velocity = Vector2(0, 0)
		if (velocity.length() > 1):
			velocity = velocity.normalized()
		#Cube curving to make small adjustments easier
		velocity = velocity * velocity * velocity
	
	#If no controller input, use keyboard
	else:
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
	if new_velocity.length() > max_velocity:
		new_velocity = new_velocity.normalized() * max_velocity
	
	#Executing the movement, setting current velocity for next pass, setting global time_delta
	velocity = new_velocity
	move_and_collide(velocity * delta)
	curr_velocity = velocity
	get_node("/root/Main").set_time_delta(curr_velocity.length() / max_velocity)

func move_rotate():
	if controller:
		var direction = Vector2(Input.get_joy_axis(device, 3), Input.get_joy_axis(device, 4))
		if direction.length() > 0.5:
			rotate_dir(direction)
	else:
		var direction = get_node("../..").get_global_mouse_position() - get_global_position()
		rotate_dir(direction)
		

func rotate_dir(direction):
	if direction.x == 0:
		if direction.y > 0:
			set_global_rotation(PI / 2)
		else:
			set_global_rotation(3 * PI / 2)
	elif direction.y == 0:
		if direction.x > 0:
			set_global_rotation(0)
		else:
			set_global_rotation(PI)
	else:
		set_global_rotation(atan(direction.y / direction.x))

func _input_method_changed(device_id, connected):
	if connected:
		controller = true
		device = device_id
	else:
		controller = false

func _ready():
	#better way to check if controller exists? maybe should be global
	if Input.get_joy_name(0):
		controller = true
		device = 0
	else:
		print("kb")
		controller = false
	Input.connect("joy_connection_changed", self, "_input_method_changed")

func _process(delta):
	move_translate(delta)
	move_rotate()
