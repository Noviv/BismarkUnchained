extends Node2D

onready var bullet_scene = preload("res://scenes/Weapons/Bullet/Bullet.tscn")
onready var start = get_node("/root/Main").time_elapsed

const impulse_minimum_radius = 10
const impulse_maximum_radius = 50

var was_warning = false
var warnings = 4 # tick, tick, tick, tick/BOOM

func scale_impulse_strength(dist):
	return (impulse_maximum_radius - dist) / (impulse_maximum_radius - impulse_minimum_radius)

func impulse_objects():
	var shape = CircleShape2D.new()
	shape.set_radius(impulse_maximum_radius)
	
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.set_transform($Body.get_global_transform())
	query.set_exclude([$Body])
	var impulsed_objects = get_world_2d().get_direct_space_state().intersect_shape(query, 32)
	for obj in impulsed_objects:
		if obj.collider.has_method('impulse'):
			var dir = get_global_position().direction_to(obj.collider.get_global_position())
			var dist = get_global_position().distance_to(obj.collider.get_global_position())
			obj.collider.impulse(dir.normalized(), scale_impulse_strength(dist))

func _process(delta):
	var time_elapsed_delta = get_node("/root/Main").time_elapsed - start
	var b = (1 + sin(8 * time_elapsed_delta)) / 2
	if b >= .98 && !was_warning:
		# tick
		warnings -= 1
		was_warning = true
	elif was_warning && b < .98:
		was_warning = false
	$Body.set_modulate(Color(0, 0, b))
	#$Body.set_scale(Vector2(b, b))
	if warnings == 0:
		# BOOM
		impulse_objects()
		queue_free()