extends Control

var color = Color()
export var h_id = 0

func _on_Player_health_updated(health, a, col, id) -> void:
	update_HUD(health, a, col, id)

func update_HUD(health, a, col, id):
	var i = health
	color = col
	$PlayerImage.modulate = color
	if i > 0: 
		if a == true: $PlayerImage.modulate = Color.white
		$StunTimer.start()
	else: 
		$PlayerImage.modulate = Color.gray
	if i % 3 == 0:
		$FullHeart.rect_size.x = 9 * i/3
		$SecondHeart.rect_size.x = 9 * i/3
		$ThirdHeart.rect_size.x = 9 * i/3
	elif i % 3 == 2:
		$FullHeart.rect_size.x = 9 * ((i + 1)/3) - 9
		$SecondHeart.rect_size.x = 9 * (i + 1)/3
		$ThirdHeart.rect_size.x = 9 * (i + 1)/3
	elif i % 3 == 1:
		$FullHeart.rect_size.x = 9 * ((i + 2)/3) - 9
		$SecondHeart.rect_size.x = 9 * ((i + 2)/3) - 9
		$ThirdHeart.rect_size.x = 9 * (i + 2)/3

func _on_StunTimer_timeout() -> void:
	$PlayerImage.modulate = color
