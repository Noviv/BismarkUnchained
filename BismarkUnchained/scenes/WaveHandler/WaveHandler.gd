extends Node2D

onready var WUI = get_node("../UI")
onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")
onready var Spawner = load("res://scenes/WaveHandler/Spawner.tscn")
onready var BossSpawner = load("res://scenes/WaveHandler/BossSpawner.tscn")
onready var rng = RandomNumberGenerator.new()

const wave_length = 12
const wave_warning = 6

var wave_num = 9
var wave_reminder_sent = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaveTimer.start(wave_warning)
	var time = OS.get_time()
	rng.set_seed((time.hour + time.minute + time.second))
	
func _process(delta):
	if $WaveTimer.get_time_left() < wave_warning && !wave_reminder_sent:
		
		wave_reminder_sent = true
		if (wave_num) % 10 == 0:
			WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num) + " starting in " + String(wave_warning) +" seconds")
			spawn_boss()
		else:
			WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num) + " starting in " + String(wave_warning) +" seconds")
			spawn_enemies()

func start_next_wave():
	
	WUI.get_node("WaveWarningLabel").set_text("Wave " + String(wave_num) + " starting now")
	WUI.get_node("WaveCounter/Value").set_text(String(wave_num))
	
	if (wave_num) % 10 == 0:
		$WaveTimer.start(wave_length * 2)
	else:
		$WaveTimer.start(wave_length)
		
	wave_num += 1
	wave_reminder_sent = false

func _on_Timer_timeout():
	start_next_wave()

func spawn_point(center):
	var tempSpawn = Enemy.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)
	
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
		var rand_formation = rng.randi_range(1,3)
		match rand_formation:
			1,2:
				spawn_circle(center, rand_count)
				enemy_count -= rand_count
			3:
				if enemy_count >= 4:
					spawn_square(center)
					enemy_count -= 4
					
func spawn_boss():
	get_node("/root/Main/Player/PlayerBody").save()
	var tempSpawn = BossSpawner.instance()
	tempSpawn.position = Vector2(640, 360)
	get_parent().call_deferred("add_child", tempSpawn)
	

func spawn_circle(center, count):
	var radius = count * 8
	center = center_in_bound(center, radius)
	
	var form_radius = Vector2(0, count * 8)
	var form_angle = 6.28 / count
	place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
	for i in range(count - 1):
		form_radius = form_radius.rotated(form_angle)
		place_spawner(Vector2(center.x + form_radius.x, center.y + form_radius.y))
	
func spawn_square(center):
	var side = rng.randi_range(50, 100)
	center = center_in_bound(center, side)
	for i in range(2):
		for j in range(2):
			place_spawner(Vector2(center.x + (i * side), center.y + (j * side)))
			pass
	
	pass
	
func spawn_line(center, count):
	var x = rng.randi_range(-1, 1)
	var y = rng.randi_range(-1, 1)
	pass

func place_spawner(center):
	var tempSpawn = Spawner.instance()
	tempSpawn.position = center
	get_parent().call_deferred("add_child", tempSpawn)
	
func center_in_bound(center, unit):
	if (center.x + unit) > 1150:
		center.x = center.x - unit
	elif (center.x - unit) < 100:
		center.x = center.x + unit
	
	if (center.y + unit) > 590:
		center.y = center.y - unit
	elif (center.y - unit) < 110:
		center.y = center.y + unit
		
	return center
