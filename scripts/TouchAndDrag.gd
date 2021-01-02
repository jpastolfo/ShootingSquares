extends Node2D

var is_dragging = false
var is_new = true
var touch_position = 0
var start_position = 0

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_dragging = true
			touch_position = event.position
			if is_new: 
				start_position = event.position
				is_new = false
		else:
			is_dragging = false
			is_new = true
			$Sprite.global_position.x = event.position.x

func _physics_process(delta):
	if is_dragging:
		$Sprite.global_position.x += touch_position.x - start_position.x
