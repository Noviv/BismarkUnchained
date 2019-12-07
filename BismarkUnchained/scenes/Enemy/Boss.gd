extends KinematicBody2D

onready var sprite = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var shoot_ray = get_node("shoot_ray")

const is_enemy = true
const aim_speed = deg2rad(1) * 3.2

var time_left = 0
var secondary_time_left = 0
var health

var bullet_damage = 20

func _ready():
	health = 600

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
	move_and_collide(dir * time_scale * .55)
	
	if get_angle_to(player_pos) > 0.05:
		rotation += aim_speed * time_scale
	elif get_angle_to(player_pos) < -0.05:
		rotation -= aim_speed * time_scale
		
	if secondary_time_left < 0:
		var count = 8
		var bullet_radius = Vector2(0, count)
		var bullet_angle = 6.28 / count
		for i in range(count + 1):
			bullet_radius = bullet_radius.rotated(bullet_angle)
			var s = sprite.instance()
			s.set_can_damage_enemy(false)
			s.set_bullet_velocity(Vector2(bullet_radius.x, bullet_radius.y).normalized() * 100)
			s.set_bullet_damage(bullet_damage * .75)
			s.set_modulate(Color(0, 255, 0, 1))
			print(bullet_radius)
			get_parent().add_child(s)
			s.global_position = Vector2(bullet_radius.x * 12, bullet_radius.y * 12) + get_global_position()
			secondary_time_left = 1.5
		pass
	else:
		secondary_time_left -= delta * time_scale
	
	if shoot_ray.is_colliding() && shoot_ray.get_collider() == get_node("../../Player/PlayerBody") && time_left < 0 && player_pos.distance_to(pos) > 150:
		var s = sprite.instance()
		s.set_can_damage_enemy(false)
		s.set_bullet_velocity(Vector2(player_pos.x - pos.x, player_pos.y - pos.y).normalized() * 200)
		s.set_bullet_damage(bullet_damage)
		s.set_bullet_object_to_home(get_node("../../Player/PlayerBody"))
		s.set_modulate(Color(255, 0, 0, 1))
		get_parent().add_child(s)
		s.global_position = Vector2(pos.x - .6 * (pos.x - player_pos.x) / 2, pos.y - .6 * (pos.y - player_pos.y) / 2)
		time_left = .33
	else:
		time_left -= delta * time_scale
