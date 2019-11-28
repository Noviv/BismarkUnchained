extends Node2D

onready var WUI = get_node("/root/Main//UI")

const min_time_delta = 0.1

var time_delta = 1
var score = 0
var time_elapsed = 0

func get_time_delta():
	return time_delta

func set_time_delta(new_delta):
	# Need a buffer on new_delta to account for floating point precision errors
	if new_delta < -0.001 || new_delta > 1.001:
		print("time_delta out of bounds")
		print(new_delta)
		get_tree().quit()
	
	time_delta = new_delta * (1 - min_time_delta) + min_time_delta
	if time_delta < min_time_delta:
		time_delta = min_time_delta
	elif time_delta > 1:
		time_delta = 1
	get_node("/root/Main/UI/TimeDelta").value = time_delta * 100

func up_score(points):
	score += points
	WUI.get_node("Score").set_text(String(score))

func _process(delta):
	time_elapsed += delta * time_delta
