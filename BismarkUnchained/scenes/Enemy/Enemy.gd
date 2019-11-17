extends KinematicBody2D

onready var sprite = preload("res://scenes/Bullet/Bullet.tscn")
var timer = null
var timer_delay = .5
var can_shoot = true
var health

func _ready():
	timer= Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(timer_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	health = 100

func on_timeout_complete():
       can_shoot = true

func damage():
       health -= 20


func _process(delta):
	if(health <= 0):
		queue_free()
		pass
	var pos = get_global_position()
	var player_pos = get_node("../../Player/PlayerBody").get_global_position()
	var dir = (player_pos - pos).normalized()
	var collision = move_and_collide(dir * get_node("/root/Main").get_time_delta())
	if collision:
		print("hit")
		dir = dir.bounce(collision.normal)
	if pos.y > player_pos.y - 50 && pos.y < player_pos.y + 50 && can_shoot:
		var s = sprite.instance()
		s.position += Vector2(30, 0)
		add_child(s)
		can_shoot = false
		timer.start()  
