extends Node2D

onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")
onready var Enemy2 = load("res://scenes/Enemy/Enemy2.tscn")
onready var Enemy3 = load("res://scenes/Enemy/Enemy3.tscn")
onready var rng = get_node("/root/Main/WaveHandler").rng

func _ready():
	$Timer.start(6)

func _on_Timer_timeout():
	var tempSpawn = Enemy.instance()
	var rand_type = rng.randi_range(1,3)
	match rand_type:
		1:
			tempSpawn = Enemy.instance()
		2:
			tempSpawn = Enemy2.instance()
		3:
			tempSpawn = Enemy3.instance()
	tempSpawn.position = get_global_position()
	get_parent().add_child(tempSpawn)
	queue_free()
