extends Button

func _on_Button_pressed():
	if get_tree().change_scene("res://scenes/Main/Main.tscn") != OK:
		print('failed to switch to main scene')
		get_tree().quit()
