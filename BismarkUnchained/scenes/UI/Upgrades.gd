extends Control

var line
var to_save = false

# Passive upgrades
var upgrades = 0
var maxhealth = 100
var regen = 0
var lifesteal = 0
var rof = 0.75

# Upgrade values
const rof_upgrade = 0.9
const maxhealth_upgrade = 25
const regen_upgrade = 0.25
const lifesteal_upgrade = 2

func _ready():
	var save_file = File.new()
	if save_file.file_exists("res://bismarkunchained.sav"):
		save_file.open("res://bismarkunchained.sav", File.READ)
		line = parse_json(save_file.get_line())
		upgrades = line.upgrades
		maxhealth = line.maxhealth
		regen = line.regen
		lifesteal = line.lifesteal
		rof = line.rof
		save_file.close()
	
	get_node("Labels/Upgrades").text = "Upgrades Available: " + str(upgrades)
	get_node("Labels/RoFInfo").text = "Current RoF: " + str(rof)
	get_node("Labels/MaxHealthInfo").text = "Current Max Health: " + str(maxhealth)
	get_node("Labels/HealthRegenInfo").text = "Current Health Regen/sec: " + str(regen)
	get_node("Labels/LifestealInfo").text = "Current Lifesteal: " + str(lifesteal) + "%"
		

func _on_RoF_pressed():
	if upgrades > 0:
		to_save = true
		rof *= rof_upgrade
		upgrades -= 1
		get_node("Labels/RoFInfo").text = "Current RoF: " + str(rof)
		get_node("Labels/Upgrades").text = "Upgrades Available: " + str(upgrades)
		

func _on_MaxHealth_pressed():
	if upgrades > 0:
		to_save = true
		maxhealth += maxhealth_upgrade
		upgrades -= 1
		get_node("Labels/MaxHealthInfo").text = "Current Max Health: " + str(maxhealth)
		get_node("Labels/Upgrades").text = "Upgrades Available: " + str(upgrades)


func _on_Regen_pressed():
	if upgrades > 0:
		to_save = true
		regen += regen_upgrade
		upgrades -= 1
		get_node("Labels/HealthRegenInfo").text = "Current Health Regen/sec: " + str(regen)
		get_node("Labels/Upgrades").text = "Upgrades Available: " + str(upgrades)


func _on_Lifesteal_pressed():
	if upgrades > 0:
		to_save = true
		lifesteal += lifesteal_upgrade
		upgrades -= 1
		get_node("Labels/LifestealInfo").text = "Current Lifesteal: " + str(lifesteal) + "%"
		get_node("Labels/Upgrades").text = "Upgrades Available: " + str(upgrades)


func _on_Return_pressed():
	if to_save:
		var save_file = File.new()
		line.upgrades = upgrades
		line.maxhealth = maxhealth
		line.regen = regen
		line.lifesteal = lifesteal
		line.rof = rof
		save_file.open("res://bismarkunchained.sav", File.WRITE)
		save_file.store_line(to_json(line))
		save_file.close()
	
	if get_tree().change_scene("res://scenes/UI/StartScreen.tscn") != OK:
		print('failed to switch to startscreen scene')
		get_tree().quit()
	