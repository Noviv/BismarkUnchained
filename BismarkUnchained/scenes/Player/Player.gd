extends KinematicBody2D

var accel = 3750
var max_velocity = 750
var deadzone = 0.1

var curr_velocity = Vector2(0, 0)
var controller = false
var device = -1

var time_last_shot = -1
var time_to_shoot = 1
onready var bullet_sprite = preload("res://scenes/Bullet/Bullet.tscn")
var last_dir = Vector2(0, 0)

var health = 100

func damage():
	health -= 5
	get_node('/root/Main/UI/Health').value = health

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
			last_dir = Vector2(direction.x, -direction.y)
			print(last_dir)
			rotate_dir(direction)
	else:
		var direction = get_global_mouse_position() - get_global_position()
		last_dir = Vector2(direction.x, -direction.y)
		rotate_dir(direction)
		

func shoot():
	if Input.is_action_pressed("player_shoot"):
		if get_node("/root/Main").time_elapsed > time_last_shot + time_to_shoot:
			time_last_shot = get_node("/root/Main").time_elapsed
			var sprite = bullet_sprite.instance()
			var x_vel = 0
			var y_vel = 0
			#No div by 0
			if last_dir.x == 0:
				if last_dir.y == 0:
					x_vel = 1
					y_vel = 0
				else:
					x_vel = 0
					y_vel = last_dir.y
			#Trig
			else:
				print(atan(last_dir.y / last_dir.x))
				if last_dir.x < 0 && last_dir.y < 0:
					x_vel = -cos(atan(last_dir.y / last_dir.x))
					y_vel = sin(atan(last_dir.y / last_dir.x))
				elif last_dir.x < 0 && last_dir.y > 0:
					x_vel = -cos(atan(last_dir.y / last_dir.x))
					y_vel = sin(atan(last_dir.y / last_dir.x))
				elif last_dir.x > 0 && last_dir.y > 0:
					x_vel = cos(atan(last_dir.y / last_dir.x))
					y_vel = -sin(atan(last_dir.y / last_dir.x))
				else:
					x_vel = cos(atan(last_dir.y / last_dir.x))
					y_vel = -sin(atan(last_dir.y / last_dir.x))
				print (x_vel)
				print (y_vel)
			sprite.get_node("Body").velocity = Vector2(x_vel, y_vel).normalized() * 100
			get_parent().add_child(sprite)
			sprite.global_position = get_global_position() + sprite.get_node("Body").velocity.normalized() * 30
			

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
	shoot()
