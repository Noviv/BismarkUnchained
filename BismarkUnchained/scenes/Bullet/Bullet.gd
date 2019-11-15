extends Node2D

func explode():
	$Explosion.global_position = get_node('Body').global_position
	$Explosion.emitting = true
	$FreeTimer.connect('timeout', self, 'queue_free')
	$FreeTimer.start()

# vel is a Vector2
func init(vel):
	$Body.velocity = vel
