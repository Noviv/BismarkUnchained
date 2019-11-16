extends Node2D

var time_delta = 1

func get_time_delta():
	return time_delta

func set_time_delta(new_delta):
	if new_delta < 0 || new_delta > 1:
		get_tree().quit()
	time_delta = new_delta