extends "res://scripts/EnemyCore.gd"

func _process(delta):
	basic_movement_towars_player(delta)
	check_death()
