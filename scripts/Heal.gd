extends Sprite

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free()

func oscilate():
	$AnimationPlayer.play("Oscilate")
