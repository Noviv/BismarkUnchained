extends Node2D

var wave_num = 0
var wave_reminder_sent = false
var wave_length = 1
var wave_warning = .5
onready var TempEnemy = load("res://scenes/WaveHandler/TempEnemy.tscn")
onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wave ready")
	start_next_wave()
	var time = OS.get_time()
	rng.set_seed((time.hour + time.minute + time.second))
	
func _process(delta):
	if($WaveTimer.get_time_left() < wave_warning && !wave_reminder_sent):
		print("Wave " + String(wave_num + 1) + " starting in " + String(wave_warning) +" seconds")
		wave_reminder_sent = true

func start_next_wave():
	wave_num += 1
	print("Wave " + String(wave_num) + " starting now")
	
	var tempSpawn = TempEnemy.instance()
	tempSpawn.position = Vector2(rng.randi_range(50, 1150), rng.randi_range(50, 650))
	get_parent().call_deferred("add_child", tempSpawn)
	
	$WaveTimer.start(float(wave_length))
	wave_reminder_sent = false

func _on_Timer_timeout():
	start_next_wave()
