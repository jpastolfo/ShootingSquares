extends Label

var highscore

func _ready():
	Global.load_game()
	text = str(Global.high_score)
	Global.previous_high_score = Global.high_score

func _process(_delta: float) -> void:
	if Global.score > Global.high_score:
		Global.high_score = Global.score
