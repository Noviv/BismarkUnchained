extends Node2D

onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")
onready var Enemy2 = load("res://scenes/Enemy/Enemy2.tscn")
onready var Enemy3 = load("res://scenes/Enemy/Enemy3.tscn")

func _ready():
	$Timer.start(6)

func _on_Timer_timeout():
	var tempSpawn = Enemy2.instance()
	tempSpawn.position = get_global_position()
	get_parent().add_child(tempSpawn)
	queue_free()
