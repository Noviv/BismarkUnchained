extends Node2D

var paused = false

func _ready():
	$PausePanel.hide()
	
func is_pause():
	return paused

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if paused:
			$PausePanel.hide()
		else:
			$PausePanel.show()
		paused = !paused
		get_tree().paused = paused
	elif Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

