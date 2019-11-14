extends Node2D

func _ready():
	pass

# vel is a Vector2
func init(vel):
	get_node('Body').velocity = vel