extends KinematicBody2D

onready var sprite = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var shoot_ray = get_node("shoot_ray")

const is_enemy = true
const aim_speed = deg2rad(1) * 3.2

var time_left = 0
var health

var bullet_damage = 20

func _ready():
	health = 100

func damage(dmg):
	health -= dmg

func _process(delta):
	var time_scale = get_node("/root/Main").get_time_delta()
	if health <= 0:
		get_node("/root/Main").up_score(50)
		queue_free()
	
	var pos = get_global_position()
	var player_pos = get_node("../../Player/PlayerBody").get_global_position()
	var dir = (player_pos - pos).normalized()
	move_and_collide(dir * time_scale)
	
	if get_angle_to(player_pos) > 0:
		rotation += aim_speed * time_scale
	elif get_angle_to(player_pos) < 0:
		rotation -= aim_speed * time_scale
	

	if shoot_ray.is_colliding() && shoot_ray.get_collider() == get_node("../../Player/PlayerBody") && time_left < 0 && player_pos.distance_to(pos) > 150:
		var s = sprite.instance()
		s.set_can_damage_enemy(false)
		s.set_bullet_velocity(Vector2(player_pos.x - pos.x, player_pos.y - pos.y).normalized() * 100)
		s.set_bullet_damage(bullet_damage)
		get_parent().add_child(s)
		s.global_position = Vector2(pos.x - .4 * (pos.x - player_pos.x) / 2, pos.y - .4 * (pos.y - player_pos.y) / 2)
		time_left = .5
	else:
		time_left -= delta * time_scale
