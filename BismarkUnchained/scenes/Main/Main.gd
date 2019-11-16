extends Node2D

var time_delta = 1

func get_time_delta():
	return time_delta

func set_time_delta(new_delta):
	#Need a buffer on new_delta to account for floating point precision errors
	if new_delta < -0.001 || new_delta > 1.001:
		print("time_delta out of bounds")
		print(new_delta)
		get_tree().quit()
	if new_delta < 0:
		new_delta = 0
	if new_delta > 1:
		new_delta = 1
	time_delta = new_delta
	