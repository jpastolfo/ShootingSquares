extends Node2D

export(Array, PackedScene) var enemies
export(Array, PackedScene) var power_ups

enum{
	GAMEPLAY,
	PAUSE,
	DEATH
}

var update_money = true
var state = GAMEPLAY

func _ready() -> void:
	$Music.play(Global.music_time)
	
	$ScoreUI/Death/YouDied.text = (tr("you_died"))
	$ScoreUI/Death/CenterContainer/VBoxContainer/Menu.text = (tr("menu"))
	
	$ScoreUI/Death.hide()
	
	Global.node_creation_parent = self
	Global.score = 0
	Global.delta_money = 0
	$ScoreUI/HUD/PlayerImage.modulate = Global.color
	$ScoreUI/Control/FadeIn/AnimationPlayer.play("FadeOut")
	yield(get_tree().create_timer(0.6), "timeout")
	$ScoreUI/Control/FadeIn.hide()
	state = GAMEPLAY

func _process(_delta):
	
	match state:
		GAMEPLAY:
			$PauseNode/Pause.hide()
			if Input.is_action_just_pressed("ui_cancel"):
				$ScoreUI/Pause/Continue.grab_focus()
				state = PAUSE
		PAUSE:
			$PauseNode/Pause.show()
			get_tree().paused = true
			if Input.is_action_just_pressed("ui_cancel"):
				get_tree().paused = false
				state = GAMEPLAY
		DEATH:
			$PauseNode.hide()
			$BlurEffect.hide()
			if update_money:
				Global.money += Global.delta_money
				Global.save_game()
				update_money = false
			$ScoreUI/Death/CenterContainer/VBoxContainer/Menu.grab_focus()
			$ScoreUI/Death/CenterContainer/VBoxContainer/Score.text = tr("score") + ": " + str(Global.score)
			if Global.high_score > Global.previous_high_score: 
				$ScoreUI/Death/CenterContainer/VBoxContainer/MaxScore.text = tr("new_highscore")
			else:
				$ScoreUI/Death/CenterContainer/VBoxContainer/MaxScore.text = tr("more_luck")
				$ScoreUI/Death/CenterContainer/VBoxContainer/Money.text = tr("money") + " +" + str(Global.delta_money)
			Global.player.clear()

func _exit_tree() -> void:
	Global.node_creation_parent = null

func _on_SpawnTimer_timeout() -> void:
	var enemy_position = Vector2(rand_range(-160,670), rand_range(-90,390))
	
	while enemy_position.x < 640 and enemy_position.x > -80 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160,670), rand_range(-90,390))
	
	var enemy_number
	var random = round(rand_range(0,100))
	if random <= 10:
		enemy_number = 2
	elif random > 10 and random <= 55:
		enemy_number = 1
	else: enemy_number = 0
	
	Global.instance_node(enemies[enemy_number], enemy_position, self)

func _on_DifficultyTimer_timeout() -> void:
	if $SpawnTimer.wait_time > 0.75:
		$SpawnTimer.wait_time -= 0.01

func _on_PowerUpSpawnTimer_timeout() -> void:
	var power_position = Vector2(rand_range(16,624), rand_range(16,344))
	var power_number = round(rand_range(0, power_ups.size() - 1))
	Global.instance_node(power_ups[power_number], power_position, self)

func _on_Player_dead() -> void:
	Global.precision = 100*Global.bulletsHit/Global.bulletsFired
	Global.deaths += 1
	$ScoreUI/Control/FadeIn.show()
	$ScoreUI/Control/FadeIn.fade_in()
	$ScoreUI/Death.show()
	state = DEATH

func death_fade_in():
	$ScoreUI/Death.show()
	$ScoreUI/Death/AnimationPlayer.play("FadeIn")

func _on_Menu_pressed() -> void:
	$ScoreUI/Death/AnimationPlayer.play_backwards("FadeIn")
	yield(get_tree().create_timer(0.6), "timeout")
	get_tree().change_scene("res://scenes/Menu.tscn")
	Global.music_time = $Music.get_playback_position()

func _on_Continue_pressed() -> void:
	$PauseNode/Pause/AnimationPlayer.play_backwards("FadeIn")
	get_tree().paused = false
	state = GAMEPLAY

func _on_MenuP_pressed() -> void:
	$ScoreUI/Pause/AnimationPlayer.play_backwards("FadeIn")
	$ScoreUI/Control/FadeIn.show()
	$ScoreUI/Control/FadeIn/AnimationPlayer.play_backwards("FadeOut")
	yield(get_tree().create_timer(0.6), "timeout")
	Global.player.clear()
	get_tree().change_scene("res://scenes/Menu.tscn")
	Global.music_time = $Music.get_playback_position()

func _on_Music_finished() -> void:
	$Music.play()

func _on_Pause_pressed() -> void:
	if state != DEATH:
		$PauseNode/Pause/AnimationPlayer.play("FadeIn")
		state = PAUSE
