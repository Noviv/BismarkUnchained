extends KinematicBody2D

var accel = 3750
var max_velocity = 750
var slow_velocity = 75

var curr_velocity = Vector2(0, 0)

var time_last_shot = -1
var time_to_shoot = 0.75
var bullet_velocity = 1000
onready var bullet_sprite = preload("res://scenes/Bullet/Bullet.tscn")
var last_dir = Vector2(0, 0)

var health = 100

func damage():
	health -= 5
	get_node('/root/Main/UI/Health').value = health

func move_translate(delta):
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed("player_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("player_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("player_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("player_right"):
		velocity += Vector2(1, 0)
	
	#Finding difference between current and target velocity, and adjusting for acceleration
	velocity = velocity.normalized() * max_velocity
	if Input.is_action_pressed("player_slowdown"):
		velocity = velocity.normalized() * slow_velocity
	var diff_velocity = velocity - curr_velocity
	var new_velocity = curr_velocity + diff_velocity.normalized() * accel * delta
	
	#Checking that new velocity is not greater magnitude than target velocity, and prevents stuttering at extremely low speeds
	if new_velocity.length() > velocity.length():
		new_velocity = velocity
	
	#Executing the movement, setting current velocity for next pass, setting global time_delta
	velocity = new_velocity
	move_and_collide(velocity * delta)
	curr_velocity = velocity
	get_node("/root/Main").set_time_delta(curr_velocity.length() / max_velocity)

func move_rotate():
	var direction = get_global_mouse_position() - get_global_position()
	last_dir = direction
	set_global_rotation(atan2(direction.y, direction.x))

func shoot():
	if Input.is_action_pressed("player_shoot"):
		if get_node("/root/Main").time_elapsed > time_last_shot + time_to_shoot:
			time_last_shot = get_node("/root/Main").time_elapsed
			var sprite = bullet_sprite.instance()
			sprite.set_scale(Vector2(1.4, 1.4))
			sprite.set_modulate(Color(0, 0, 0, 1))
			var x_vel = 0
			var y_vel = 0
			x_vel = cos(atan2(last_dir.y, last_dir.x))
			y_vel = sin(atan2(last_dir.y, last_dir.x))
			sprite.get_node("Body").velocity = Vector2(x_vel, y_vel).normalized() * bullet_velocity
			get_parent().add_child(sprite)
			sprite.global_position = get_global_position() + sprite.get_node("Body").velocity.normalized() * 50
			get_node("/root/Main/UI/WeaponRecharge").value = 0
	get_node("/root/Main/UI/WeaponRecharge").value = 100 * (get_node("/root/Main").time_elapsed - time_last_shot) / time_to_shoot

func _process(delta):
	move_translate(delta)
	move_rotate()
	shoot()
