extends KinematicBody2D

signal enemy_hit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
 	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = get_global_position()
	var player_pos = get_node("../../Player/KinematicBody2D").get_global_position()
	var dir = (player_pos - pos).normalized()
	var collision = move_and_collide(dir * delta * 120)
	if collision:
		print("hit")
		dir = dir.bounce(collision.normal)
