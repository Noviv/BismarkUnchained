extends Node2D

onready var bullet_scene = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var start = get_node("/root/Main").time_elapsed

var was_warning = false
var warnings = 4 # tick, tick, tick, tick/BOOM

func generate_spawn_locations():
	# (x, y) = offset/direction from mine's location
	# z = velocity
	return [
				Vector3(10, 10, 100),
				Vector3(-10, 10, 100),
				Vector3(10, -10, 100),
				Vector3(-10, -10, 100)
			]

func spawn_bullets():
	for spawn in generate_spawn_locations():
		var dir = Vector2(spawn.x, spawn.y)
		var bullet = bullet_scene.instance()
		bullet.set_bullet_velocity(dir.normalized() * spawn.z)
		bullet.set_bullet_damage(50)
		get_parent().add_child(bullet)
		bullet.global_position = get_global_position() + dir

func _process(delta):
	var time_elapsed_delta = get_node("/root/Main").time_elapsed - start
	var r = (1 + sin(8 * time_elapsed_delta)) / 2
	if r >= .98 && !was_warning:
		# tick
		warnings -= 1
		was_warning = true
	elif was_warning && r < .98:
		was_warning = false
	$Body.set_modulate(Color(r, 0, 0))
	#$Body.set_scale(Vector2(r, r))
	if warnings == 0:
		# BOOM
		spawn_bullets()
		queue_free()
