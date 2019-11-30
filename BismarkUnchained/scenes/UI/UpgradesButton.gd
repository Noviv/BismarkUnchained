extends Button

func _on_Button_pressed():
	if get_tree().change_scene("res://scenes/UI/Upgrades.tscn") != OK:
		print('failed to switch to upgrades scene')
		get_tree().quit()
