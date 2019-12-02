extends KinematicBody2D

onready var sprite = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var child = load("res://scenes/Enemy/Enemy3.tscn")
onready var shoot_ray = get_node("shoot_ray")

const aim_speed = deg2rad(1) * 3.2

var time_left = 0
var pos

func _ready():
	pass
	
func init(size):
	scale = size
	pos = get_global_position()


func damage(dmg):
	if(scale.x > .33):
		var child1 = child.instance()
		var child2 = child.instance()
		get_parent().get_parent().add_child(child1)
		get_parent().get_parent().add_child(child2)
		child1.get_node("Enemy3Body").init(scale/1.75)
		child2.get_node("Enemy3Body").init(scale/1.75)
		child1.global_position = pos
		child2.global_position = child1.global_position + Vector2(0, 40)
	else:
		get_node("/root/Main").up_score(100)
	queue_free()

func _process(delta):
	var time_scale = get_node("/root/Main").get_time_delta() * (3 - scale.x)
	pos = get_global_position()
	var player_pos = get_node("../../Player/PlayerBody").get_global_position()
	var dir = (player_pos - pos).normalized()
	move_and_collide(dir * time_scale)
	
	if get_angle_to(player_pos) > 0.05:
		rotation += aim_speed * time_scale
	elif get_angle_to(player_pos) < -0.05:
		rotation -= aim_speed * time_scale
	if shoot_ray.is_colliding() && shoot_ray.get_collider() == get_node("../../Player/PlayerBody") && time_left < 0 && player_pos.distance_to(pos) > 150:
		var s = sprite.instance()
		s.get_node("Body").velocity = Vector2(player_pos.x - pos.x, player_pos.y - pos.y).normalized() * 100
		get_parent().add_child(s)
		s.global_position = Vector2(pos.x - .4 * (pos.x - player_pos.x) / 2, pos.y - .4 * (pos.y - player_pos.y) / 2)
		time_left = .5
	else:
		time_left -= delta * time_scale
