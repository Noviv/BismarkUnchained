extends Node2D

var wave_num = 0
var wave_reminder_sent = false
onready var TempEnemy = load("res://scenes/WaveHandler/TempEnemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wave ready")
	start_next_wave()
	
func _process(delta):
	if($WaveTimer.get_time_left() < 5 && !wave_reminder_sent):
		print("Wave " + String(wave_num + 1) + " starting in 5 seconds")
		wave_reminder_sent = true

func start_next_wave():
	wave_num += 1
	print("Wave " + String(wave_num) + " starting now")
	
	var tempSpawn = TempEnemy.instance()
	tempSpawn.position = Vector2(wave_num * 40, wave_num * 40)
	get_parent().call_deferred("add_child", tempSpawn)
	
	$WaveTimer.start(10.0)
	wave_reminder_sent = false

func _on_Timer_timeout():
	start_next_wave()
