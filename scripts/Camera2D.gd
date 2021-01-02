extends Camera2D

var screen_shake_start = false
var shake_intensity = 0

onready var start_position = self.global_position

func _ready() -> void:
	Global.camera = self

func _exit_tree() -> void:
	Global.camera = null

func _process(delta):
	zoom = lerp(zoom, Vector2(1,1), 0.3)
	
	if screen_shake_start == true:
		global_position += Vector2(rand_range(-shake_intensity,shake_intensity),rand_range(-shake_intensity,shake_intensity)) * delta
	else:
		global_position = lerp(global_position, start_position, 0.3)
func screen_shake(intensity, time):
	zoom = Vector2(1,1) - Vector2(intensity * 0.002, intensity * 0.002)
	shake_intensity = intensity
	$ScreenShakeTime.wait_time = time
	$ScreenShakeTime.start()
	screen_shake_start = true

func _on_ScreenShakeTime_timeout() -> void:
	screen_shake_start = false
