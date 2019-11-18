extends KinematicBody2D

onready var sprite = preload("res://scenes/Bullet/Bullet.tscn")
var time_left = 0
var health

func _ready():
	health = 100

func damage():
	health -= 20

func _process(delta):
	var time_scale = get_node("/root/Main").get_time_delta()
	if(health <= 0):
		queue_free()
		pass
	var pos = get_global_position()
	var player_pos = get_node("../../Player/PlayerBody").get_global_position()
	var dir = (player_pos - pos).normalized()
	var collision = move_and_collide(dir * time_scale)
	var aim_speed = deg2rad(1)*3.2
	if get_angle_to(player_pos) > 0:
    	rotation += aim_speed * time_scale
	elif get_angle_to(player_pos) < 0:
    	rotation -= aim_speed * time_scale
	if collision:
		print("hit")
		dir = dir.bounce(collision.normal)
	if get_angle_to(player_pos) < 0.5 && get_angle_to(player_pos) > -0.5 && time_left < 0:
		var s = sprite.instance()
		s.position += Vector2(player_pos.x - pos.x, player_pos.y - pos.y)
		s.get_node("Body").velocity = Vector2(player_pos.x - pos.x, player_pos.y - pos.y).normalized() * 100
		get_parent().add_child(s)
		time_left = .5
	else:
		time_left -= delta * time_scale
