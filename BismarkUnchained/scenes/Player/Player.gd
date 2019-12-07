extends KinematicBody2D

# Movement variables
const accel = 5000
var curr_accel = 5000
const max_velocity = 750
var curr_max_velocity = 750

var curr_velocity = Vector2(0, 0)

# Bullet variables
onready var bullet_sprite = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var bullet_mine_sprite = preload("res://scenes/Weapons/BulletMine/BulletMine.tscn")
const bullet_velocity = 1000
var bullet_damage = 50

var time_last_shot = -1
var last_dir = Vector2(0, 0)

var secondary_recharge = 0

# Upgrades
var upgrades = 0
var maxhealth = 100
var regen = 0
var lifesteal = 0
var time_to_shoot = 0.75

# Player attribute variables
var health = 100
var experience = 0
var level = 1

func damage(dmg):
	health -= dmg
	get_node('/root/Main/Player/UI/Health').value = health * 100 / maxhealth

func move_translate(delta):
	if health <= 0:
		# TODO: pull score and display it on end screen
		if get_tree().change_scene("res://scenes/UI/StartScreen.tscn") != OK:
			print('failed to switch to main screen on death')
			get_tree().quit()

	var x = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	var y = int(Input.is_action_pressed("player_down")) - int(Input.is_action_pressed("player_up"))
	
	# Finding difference between current and target velocity, and adjusting for acceleration
	var velocity = Vector2(x, y).normalized() * curr_max_velocity
	var diff_velocity = velocity - curr_velocity
	var new_velocity = curr_velocity + diff_velocity.normalized() * curr_accel * delta
	
	if curr_velocity.length() == curr_max_velocity && abs(velocity.angle() - curr_velocity.angle()) < PI / 2:
		new_velocity = velocity
	
	# Checking that new velocity is not greater magnitude than target velocity, and prevents stuttering at extremely low speeds
	if new_velocity.length() > velocity.length():
		new_velocity = velocity
	
	# Executing the movement, setting current velocity for next pass, setting global time_delta
	velocity = new_velocity
	move_and_slide(velocity)
	curr_velocity = velocity

func move_rotate():
	var direction = get_global_mouse_position() - get_global_position()
	last_dir = direction
	set_global_rotation(atan2(direction.y, direction.x))

func shoot():
	if Input.is_action_pressed("player_shoot"):
		if get_node("/root/Main").time_elapsed > time_last_shot + time_to_shoot:
			time_last_shot = get_node("/root/Main").time_elapsed
			
			# Instance bullet scene
			var sprite = bullet_sprite.instance()
			sprite.set_scale(Vector2(1.4, 1.4))
			sprite.set_modulate(Color(0, 0, 255, 1))
			sprite.set_bullet_velocity(last_dir.normalized() * bullet_velocity)
			sprite.set_bullet_damage(bullet_damage)
			
			# Add scene
			get_parent().add_child(sprite)
			sprite.global_position = get_global_position() + last_dir.normalized() * 50
			
			# Reset recharge
			get_node("/root/Main/Player/UI/WeaponRecharge").value = 0
	get_node("/root/Main/Player/UI/WeaponRecharge").value = 100 * (get_node("/root/Main").time_elapsed - time_last_shot) / time_to_shoot

func regen():
	health += regen * get_node("/root/Main").game_time_since_frame
	if health > maxhealth:
		health = maxhealth
	get_node('/root/Main/Player/UI/Health').value = health * 100 / maxhealth

func lifesteal(dmg):
	health += dmg * lifesteal / 100
	if health > maxhealth:
		health = maxhealth
	get_node('/root/Main/Player/UI/Health').value = health * 100 / maxhealth

func update_exp(exp_val):
	experience += exp_val
	while experience >= exp_req(level + 1):
		level += 1
		upgrades += 1
	get_node("/root/Main/Player/UI/ExpReq").value = 100 * (experience - exp_req(level)) / (exp_req(level + 1) - exp_req(level))
	get_node("/root/Main/Player/UI/LevelLabel").text = "Player Level: " + str(level)

func exp_req(next_level):
	return 500 * pow(next_level, 2) - 500 * next_level

func save():
	var save_dict = {
		"experience" : experience,
		"upgrades": upgrades,
		"maxhealth": maxhealth,
		"regen": regen,
		"lifesteal": lifesteal,
		"rof": time_to_shoot
	}
	var save_file = File.new()
	save_file.open("res://bismarkunchained.sav", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

func _ready():
	var save_file = File.new()
	if save_file.file_exists("res://bismarkunchained.sav"):
		save_file.open("res://bismarkunchained.sav", File.READ)
		var line = parse_json(save_file.get_line())
		update_exp(line.experience)
		upgrades = line.upgrades
		maxhealth = line.maxhealth
		health = maxhealth
		regen = line.regen
		lifesteal = line.lifesteal
		time_to_shoot = line.rof
		save_file.close()

func _input(event):
	if event.is_action_pressed("player_mintime"):
		curr_max_velocity = max_velocity * get_node("/root/Main").min_time_delta
		curr_accel = accel * get_node("/root/Main").min_time_delta
		get_node("/root/Main/Player/UI/TimeDelta").value = 100 * curr_max_velocity / max_velocity
	elif event.is_action_pressed("player_maxtime"):
		curr_max_velocity = max_velocity
		curr_accel = accel
		get_node("/root/Main/Player/UI/TimeDelta").value = 100 * curr_max_velocity / max_velocity
	elif event.is_action_pressed("player_dectime"):
		if curr_max_velocity > max_velocity * get_node("/root/Main").min_time_delta:
			curr_max_velocity -= (max_velocity - max_velocity * get_node("/root/Main").min_time_delta) / 20
			curr_accel -= (accel - accel * get_node("/root/Main").min_time_delta) / 20
			get_node("/root/Main/Player/UI/TimeDelta").value = 100 * curr_max_velocity / max_velocity
	elif event.is_action_pressed("player_inctime"):
		if curr_max_velocity < max_velocity:
			curr_max_velocity += (max_velocity - max_velocity * get_node("/root/Main").min_time_delta) / 20
			curr_accel += (accel - accel * get_node("/root/Main").min_time_delta) / 20
			get_node("/root/Main/Player/UI/TimeDelta").value =100 * curr_max_velocity / max_velocity
	elif event.is_action_pressed("player_secondary"):
		if secondary_recharge <= 0:
			var sprite = bullet_mine_sprite.instance()
			get_parent().add_child(sprite)
			sprite.global_position = get_global_position() + 50 * (get_global_mouse_position() - get_global_position()).normalized()
			secondary_recharge = 1

func _physics_process(delta):
	move_translate(delta)
	move_rotate()
	shoot()
	regen()
	secondary_recharge -= get_node("/root/Main").game_time_since_frame
	get_node("/root/Main").set_time_delta(curr_max_velocity / max_velocity)
	get_node("../Camera").position = get_global_position() - Vector2(640, 360)
	
	var ctrans = get_node("../Camera").get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	get_node("../UI").rect_position = min_pos - Vector2(640, 360)
