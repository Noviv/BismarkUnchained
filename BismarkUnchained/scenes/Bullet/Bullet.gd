extends Node2D

var time_left = 0

func explode(pos):
	$Explosion.global_position = pos
	$Explosion.emitting = true
	
	# allow time for all particles to expire before destroying
	time_left = $Explosion.lifetime * 1.5

func _process(delta):
	if $Explosion.emitting and time_left < 0:
		queue_free()
	$Explosion.speed_scale = get_node("/root/Main").time_delta
	time_left -= delta * get_node("/root/Main").time_delta

# vel is a Vector2
func init(vel):
	$Body.velocity = vel
