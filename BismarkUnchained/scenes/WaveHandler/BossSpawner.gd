extends Node2D

onready var Boss = load("res://scenes/Enemy/Boss.tscn")
onready var rng = get_node("/root/Main/WaveHandler").rng

func _ready():
	$Timer.start(2)

func _on_Timer_timeout():
	var tempSpawn = Boss.instance()
	tempSpawn.position = get_global_position()
	get_parent().add_child(tempSpawn)
	queue_free()
