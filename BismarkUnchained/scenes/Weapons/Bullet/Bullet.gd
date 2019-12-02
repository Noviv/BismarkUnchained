extends Node2D

var time_left = 0
var velocity = Vector2(0, 0)

func explode(pos):
	$Explosion.global_position = pos
	$Explosion.emitting = true
	$Afterburner.emitting = false
	
	# Allow time for all particles to expire before destroying
	time_left = $Explosion.lifetime * 1.5

func _process(delta):
	if has_node('Body'):
		$Afterburner.speed_scale = get_node("/root/Main").get_time_delta()
	else:
		if time_left < 0:
			queue_free()
		else:
			$Explosion.speed_scale = get_node("/root/Main").get_time_delta()
			time_left -= delta * get_node("/root/Main").get_time_delta()

func set_can_damage_enemy(can_damage):
	$Body.can_damage_enemy = can_damage

func set_bullet_object_to_home(object):
	$Body.homing_object = object

func set_bullet_velocity(vel):
	velocity = vel
	$Body.velocity = vel
