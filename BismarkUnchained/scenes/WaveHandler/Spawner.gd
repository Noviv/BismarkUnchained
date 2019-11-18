extends Node2D

onready var Enemy = load("res://scenes/Enemy/Enemy.tscn")

func _ready():
	$Timer.start(3)


func _process(delta):
	pass


func _on_Timer_timeout():
	var tempSpawn = Enemy.instance()
	tempSpawn.position = get_global_position()
	get_parent().add_child(tempSpawn)
	self.queue_free()
