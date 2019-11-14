extends Node2D

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$PausePanel.hide()
	
func is_pause():
	return paused

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		print("paused")
		if(!paused):
			print("now paused")
			$PausePanel.show()
			get_tree().paused = true
			paused = true
		else:
			print("now unpaused")
			$PausePanel.hide()
			get_tree().paused = false
			paused = false
	elif Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

