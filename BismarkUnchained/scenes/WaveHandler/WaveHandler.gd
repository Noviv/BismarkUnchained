extends Node2D

onready var WUI = get_node("../UI")
onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")
onready var Spawner = load("res://scenes/WaveHandler/Spawner.tscn")
onready var rng = RandomNumberGenerator.new()

const wave_length = 12.0
const wave_warning = 6

var wave_num = 0
var wave_reminder_sent = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_next_wave()
	var time = OS.get_time()
	rng.set_seed((time.hour + time.minute + time.second))
	
func _process(delta):
	if $WaveTimer.get_time_left() < wave_warning && !wave_reminder_sent:
		WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num + 1) + " starting in " + String(wave_warning) +" seconds")
		spawn_enemies()
		wave_reminder_sent = true

func start_next_wave():
	wave_num += 1
	WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num) + " starting now")
	WUI.get_node("WaveCounter/Value").set_text(String(wave_num))
	
	$WaveTimer.start(wave_length)
	wave_reminder_sent = false

func _on_Timer_timeout():
	start_next_wave()

func spawn_point(center):
	var tempSpawn = Enemy.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)

func spawn_circle(center, count):
	var radius = count * 8
	if (center.x + radius) > 1150:
		center.x = center.x - radius
	elif (center.x - radius) < 100:
		center.x = center.x + radius
	
	if (center.y + radius) > 590:
		center.y = center.y - radius
	elif (center.y - radius) < 110:
		center.y = center.y + radius
	
	var form_radius = Vector2(0, count * 8)
	var form_angle = 6.28 / count
	place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
	for i in range(count - 1):
		form_radius = form_radius.rotated(form_angle)
		place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
	
func spawn_arc(center, count, curve):
	# TODO
	pass
	
func spawn_enemies():
	get_node("/root/Main/Player/PlayerBody").save()
	var enemy_count = wave_num
	while enemy_count > 0:
		var x = rng.randi_range(50, 1150)
		var y = rng.randi_range(50, 550)
		var center  = Vector2(x, y)
		var rand_count = 32
		while(rand_count > 25):
			rand_count = rng.randi_range(1, enemy_count)
		spawn_circle(center, rand_count)
		enemy_count -= rand_count

func place_spawner(center):
	var tempSpawn = Spawner.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)
