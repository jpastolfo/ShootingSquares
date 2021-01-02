extends Sprite

var velocity = Vector2(1,0)
var speed = 250
var damage

func _process(delta):
	global_position += velocity.rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
