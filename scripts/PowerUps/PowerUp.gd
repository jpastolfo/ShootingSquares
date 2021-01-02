extends Sprite

export(String) var player_variable_modify
export(float) var player_variable_set

export(float) var power_up_cooldow = 2

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		area.get_parent().set(player_variable_modify, player_variable_set)
		area.get_parent().get_node("PowerUpCooldown").wait_time = power_up_cooldow
		area.get_parent().get_node("PowerUpCooldown").start()
		area.get_parent().power_up_reset.append(name)
		var a = area.get_parent().get_node("Sounds/PowerUp").play()
		queue_free()

func oscilate():
	$AnimationPlayer.play("Oscilate")
