extends Node2D

const DOT = 10

var shooting = false

func set_shooting(s):
	shooting = s
	$Raycast.enabled = s
	$Particles.emitting = s
	if !s:
		$Line.set_point_position(1, Vector2(0, 0))

func cast_beam(delta):
	if $Raycast.is_colliding():
		var d = $Raycast.get_collision_point() - get_global_position()
		$Line.set_point_position(1, Vector2(d.length(), 0))
		
		var c = $Raycast.get_collider()
		if c.has_method('damage'):
			c.damage(DOT * delta * get_node('/root/Main').get_time_delta())
	else:
		$Line.set_point_position(1, Vector2(0, 0))

func _physics_process(delta):
	$Particles.speed_scale = get_node('/root/Main').get_time_delta()
	if shooting:
		cast_beam(delta)