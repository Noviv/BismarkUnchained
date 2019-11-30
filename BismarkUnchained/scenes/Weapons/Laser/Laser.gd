extends Node2D

const lase_warmup_time = 3
const lase_time = .1

var warming_up = true
var time_left = lase_warmup_time

func set_laser_direction(dir):
	# $MeshInstance2D.scale.x = velocity.length()
	rotate(dir.angle())

func calc_laser_collisions():
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(5, 100))
	
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.set_transform($MeshInstance2D.get_global_transform())
	query.set_exclude([$Mesh, $ParticlesLeft, $ParticlesCenter, $ParticlesRight])
	return get_world_2d().get_direct_space_state().intersect_shape(query, 32)

func _physics_process(delta):
	if time_left > 0:
		var scaled_delta = delta * get_node("/root/Main").get_time_delta()
		if warming_up:
			var ratio_remain = time_left / lase_warmup_time
			if ratio_remain > .66:
				$ParticlesLeft.emitting = true
			elif ratio_remain > .33:
				$ParticlesRight.emitting = true
			else:
				$ParticlesCenter.emitting = true
			$ParticlesLeft.speed_scale = get_node("/root/Main").get_time_delta()
			$ParticlesRight.speed_scale = get_node("/root/Main").get_time_delta()
			$ParticlesCenter.speed_scale = get_node("/root/Main").get_time_delta()
		else:
			$MeshInstance2D.scale.y = 1 - time_left / lase_time
		time_left -= scaled_delta
	else:
		if warming_up:
			warming_up = false
			time_left = lase_time
		else:
			var list = calc_laser_collisions()
			for i in list:
				if i.collider.has_method('damage'):
					i.collider.damage()
			queue_free()