extends Node2D

var wave_num = 3
var wave_reminder_sent = false
var wave_length = 6
var wave_warning = 3
onready var WUI = get_node("../WaveUI")
onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")
onready var Spawner = load("res://scenes/WaveHandler/Spawner.tscn")
onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_next_wave()
	var time = OS.get_time()
	rng.set_seed((time.hour + time.minute + time.second))
	
func _process(delta):
	if($WaveTimer.get_time_left() < wave_warning && !wave_reminder_sent):
		WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num + 1) + " starting in " + String(wave_warning) +" seconds")
		spawn_enemies()
		wave_reminder_sent = true

func start_next_wave():
	wave_num += 1
	
	WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num) + " starting now")
	WUI.get_node("WaveCounter/Value").set_text(String(wave_num))
	
	
	
	
	$WaveTimer.start(float(wave_length))
	wave_reminder_sent = false

func _on_Timer_timeout():
	start_next_wave()
	
func spawn_point(center):
	
	var tempSpawn = Enemy.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)
	
func spawn_circle(center, count):
	
	
	var form_radius = Vector2(0, wave_num * 10)
	place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
	var form_angle = 6.28/count
	
	for i in range(count - 1):
		form_radius = form_radius.rotated(form_angle)
		place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
		pass
	
	pass
	
func spawn_arc(center, count, curve):
	pass
	
func spawn_enemies():
	
	var enemy_count = wave_num
	
	while(enemy_count > 0):
		var x = rng.randi_range(50, 1150)
		var y = rng.randi_range(50, 650)
		var center  = Vector2(x, y)
		var rand_count = rng.randi_range(1, enemy_count)
		spawn_circle(center, rand_count)
		enemy_count -= rand_count
	
	pass
	
	
func place_spawner(center):
	var tempSpawn = Spawner.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)

