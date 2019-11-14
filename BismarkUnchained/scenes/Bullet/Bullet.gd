extends Node2D

func explode():
	get_node('Explosion').global_position = get_node('Body').global_position
	get_node('Explosion').emitting = true
	get_node('FreeTimer').connect('timeout', self, 'queue_free')
	get_node('FreeTimer').start()

# vel is a Vector2
func init(vel):
	get_node('Body').velocity = vel