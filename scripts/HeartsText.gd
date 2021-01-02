extends Label

func _ready():
	text = str(Global.max_hearts)

func _process(_delta):
	text = str(Global.max_hearts)
