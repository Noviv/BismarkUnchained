extends KinematicBody2D

var velocity
var curr_velocity = Vector2(0, 0)

func damage():
	print('hit player')

func _process(delta):
	velocity = Vector2(0, 0)
	#This will change to controller input
	if Input.is_action_pressed("player_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("player_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("player_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("player_right"):
		velocity += Vector2(1, 0)
	velocity = velocity.normalized() * 10
	var diff_velocity = velocity - curr_velocity
	var accel = 30
	if diff_velocity.length() >= 10 || velocity.length() == 0:
		accel = 60
	var new_velocity = curr_velocity + diff_velocity.normalized() * accel * delta
	if new_velocity.length() > 10:
		new_velocity = velocity
	if new_velocity.length() < 0.5 && velocity.length() == 0:
		new_velocity = velocity
	velocity = new_velocity
	move_and_collide(velocity)
	curr_velocity = velocity
