extends Node2D

enum{
	MENU,
	SOLO,
	SHOP,
	OPTIONS,
	STATISTICS,
	QUIT
}

var state = MENU
var target_position = Vector2()
var target_horizontal_position = 0
var is_cam_moving = false
var is_scroll_moving = false
var cost = 0
var color_cost = 0
var index = 0

var options = [false, false, false]

onready var color = Global.color

func _ready():
	get_tree().paused = false
	$Music.play(Global.music_time)
	
	if Global.max_hearts == 9:
		$ShopMenu/TitleScreen/MaxHealth.show()
	
	$ShopMenu/TitleScreen/Money.text = tr("money") + ": " + str(Global.money) 
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/ToggleLanguage.add_item('English')
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/ToggleLanguage.add_item('Portuguese')
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/ToggleLanguage.selected = 1
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/TogglePostProcessing.pressed = Global.postprocess
	$WorldEnvironment.environment.glow_enabled = Global.postprocess
	update_statistics()
	update_language()

func _process(delta: float) -> void:
	match state:
		MENU:
			target_position = Vector2(320,180)
		SOLO:
			target_position = Vector2(960,180)
		SHOP:
			target_position = Vector2(960,-180)
		OPTIONS:
			target_position = Vector2(320,540)
		STATISTICS:
			target_position = Vector2(-320, 180)
		QUIT:
			get_tree().quit()
	
	if $OptionsMenu/TitleScreen/Settings/ScrollContainer.scroll_vertical < 200 and options[0] == false:
		set_alpha()
		options[0] = true
		$OptionsMenu/TitleScreen/Settings/Categories/Graphics.modulate = Color(1,1,1,1)
	elif $OptionsMenu/TitleScreen/Settings/ScrollContainer.scroll_vertical > 350 and options[2] == false:
		set_alpha()
		options[2] = true
		$OptionsMenu/TitleScreen/Settings/Categories/Language.modulate = Color(1,1,1,1)
	elif $OptionsMenu/TitleScreen/Settings/ScrollContainer.scroll_vertical >= 200 and $OptionsMenu/TitleScreen/Settings/ScrollContainer.scroll_vertical <=350 and options[1] == false:
		set_alpha()
		options[1] = true
		$OptionsMenu/TitleScreen/Settings/Categories/Sounds.modulate = Color(1,1,1,1)
	
	if is_cam_moving:
		var t = 0
		t += 7 * delta
		t = clamp(t, 0, 1)
		$Camera.global_position = lerp($Camera.global_position, target_position, t)
		if $Camera.global_position == target_position:
			is_cam_moving = false
	
	if is_scroll_moving:
		var t = 0
		t += 15 * delta
		t = clamp(t, 0, 1)
		$SoloMenu/TitleScreen/ScrollContainer.scroll_horizontal = lerp($SoloMenu/TitleScreen/ScrollContainer.scroll_horizontal, target_horizontal_position, t)
		if target_horizontal_position - $SoloMenu/TitleScreen/ScrollContainer.scroll_horizontal <= 4 and target_horizontal_position - $SoloMenu/TitleScreen/ScrollContainer.scroll_horizontal >= -4: 
			$SoloMenu/TitleScreen/ScrollContainer.scroll_horizontal = target_horizontal_position
			is_scroll_moving = false

func set_alpha():
	$OptionsMenu/TitleScreen/Settings/Categories/Graphics.modulate = Color(1, 1, 1, 0.196078)
	$OptionsMenu/TitleScreen/Settings/Categories/Sounds.modulate = Color(1, 1, 1, 0.196078)
	$OptionsMenu/TitleScreen/Settings/Categories/Language.modulate = Color(1, 1, 1, 0.196078)
	for i in range(0, 3):
		options[i] = false

func _on_Options_pressed() -> void:
	state = OPTIONS
	is_cam_moving = true

func _on_Solo_pressed() -> void:
	state = SOLO
	is_cam_moving = true

func _on_Statistics_pressed() -> void:
	state = STATISTICS
	is_cam_moving = true

func _on_Shop_pressed() -> void:
	state = SHOP
	is_cam_moving = true

func _on_Quit_pressed() -> void:
	state = QUIT

func _on_Back_pressed() -> void:
	state = MENU
	is_cam_moving = true

func _on_BackS_pressed() -> void:
	state = SOLO
	is_cam_moving = true

func _on_GO_pressed() -> void:
	$SoloMenu/TitleScreen/FadeIn.show()
	$SoloMenu/TitleScreen/FadeIn.fade_in()

func start_game():
	Global.gamesPlayed += 1
	get_tree().change_scene("res://scenes/Level.tscn")
	Global.save_game()
	Global.music_time = $Music.get_playback_position()

func _on_TogglePostProcessing_toggled(button_pressed: bool) -> void:
	Global.postprocess = button_pressed
	$WorldEnvironment.environment.glow_enabled = button_pressed
	Global.save_game()

func _on_ToggleLanguage_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale('en')
		1:
			TranslationServer.set_locale('pt')
	update_language()
	Global.save_game()

func update_statistics():
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/GamesPlayed.text = str(Global.gamesPlayed)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/BulletsFired.text = str(Global.bulletsFired)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/BulletsHit.text = str(Global.bulletsHit)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/Precision.text = str(Global.precision) + "%"
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/SquaresDestroyed.text = str(Global.squaresDestroyed)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/NormalSquaresDestroyed.text  = str(Global.normalSquaresDestroyed)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/FastSquaresDestroyed.text = str(Global.fastSquaresDestroyed)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/TankSquaresDestroyed.text = str(Global.tankSquaresDestroyed)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/PowerUpsCollected.text = str(Global.powerUpsCollected)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/ShootFaster.text = str(Global.shootFaster)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/HealthUp.text = str(Global.healthUp)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/X2.text = str(Global.x2Collected)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/DamageDealt.text = str(Global.damageDealt)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/DamageTaken.text = str(Global.damageTaken)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/Deaths.text = str(Global.deaths)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/KilledByNormal.text = str(Global.killedByNormal)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/KilledByFast.text = str(Global.killedByFast)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/KilledByTank.text = str(Global.killedByTank)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/HighestMoney.text = str(Global.highestScore)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/TotalScore.text = str(Global.totalScore)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/TotalMoney.text = "SS$ " + str(Global.totalMoney)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/HighestMoney.text = "SS$ " + str(Global.highestMoney)
	$StatisticsMenu/TitleScreen/ScrollContainer/HBoxContainer/Statistics/MoneySpent.text = "SS$ " + str(Global.moneySpent)

func update_language():	
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/TogglePostProcessing.text = (tr("post_processing"))
	$OptionsMenu/TitleScreen/Settings/Categories/Language.text = (tr("language"))
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/ToggleLanguage.set_item_text(0, tr("english"))
	$OptionsMenu/TitleScreen/Settings/ScrollContainer/Options/ToggleLanguage.set_item_text(1, tr("portuguese"))

func _on_Button_pressed(extra_arg_0: String, extra_arg_1: int, extra_arg_2: Color, extra_arg_3: int) -> void:
	target_horizontal_position = extra_arg_1 * 31
	is_scroll_moving = true
	color_cost = extra_arg_3
	index = extra_arg_1
	$SoloMenu/TitleScreen/ChooseColor.text = extra_arg_0
	$SoloMenu/TitleScreen/ChooseColor.modulate = extra_arg_2
	if Global.color_index[extra_arg_1] == true:
		$SoloMenu/TitleScreen/BuyButton/Cost.text = ""
		$SoloMenu/TitleScreen/BuyButton/Buy.text = "select"
	else: 
		$SoloMenu/TitleScreen/BuyButton/Cost.text = "SS$ " + str(extra_arg_3)
		$SoloMenu/TitleScreen/BuyButton/Buy.text = "buy"
	color = extra_arg_2
	Global.save_game()

func _on_AddHealth_button_down() -> void:
	if Global.money >= cost and Global.max_hearts < 9:
		Global.max_hearts += 1
		$Buy.play()
		Global.money -= cost
		Global.moneySpent += cost
		if Global.max_hearts == 9:
			$ShopMenu/TitleScreen/MaxHealth.show()
		$ShopMenu/TitleScreen/Menu/Money.text = tr("money") + ": " + str(Global.money) 
		Global.save_game()

func _on_Music_finished() -> void:
	$Music.play()

func _on_Buy_pressed() -> void:
	if !Global.color_index[index] and Global.money >= color_cost:
		$Buy.play()
		Global.money -= color_cost
		Global.moneySpent += color_cost
		$SoloMenu/TitleScreen/BuyButton/Cost.text = ""
		$SoloMenu/TitleScreen/BuyButton/Buy.text = "select"
		Global.color_index[index] = true
	elif Global.color_index[index]:
		Global.color = color
	Global.save_game()
