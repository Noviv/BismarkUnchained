extends Node2D

onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")

func _ready():
	$Timer.start(3)

func _on_Timer_timeout():
	var tempSpawn = Enemy.instance()
	tempSpawn.position = get_global_position()
	get_parent().add_child(tempSpawn)
	queue_free()
