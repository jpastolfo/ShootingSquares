extends Node

#general
var high_score = 0
var money = 0
var max_hearts = 3
var color = Color.blue
var color_index = [true, false, false, false, false, false, false, false, false, false, false]

#settings
var postprocess = true
var colorBlindMonde = false
var particles = true
var particleFadeTime = 30
var lang = "pt"
var music = true
var soundEffects = true
var UISounds = true

#statistics
var gamesPlayed = 0
var bulletsFired = 0
var bulletsHit: int = 0
var precision = 0
var squaresDestroyed = 0
var normalSquaresDestroyed = 0
var fastSquaresDestroyed = 0
var tankSquaresDestroyed = 0
var powerUpsCollected = 0
var shootFaster = 0
var healthUp = 0
var x2Collected = 0
var damageDealt = 0
var damageTaken = 0
var deaths = 0
var killedByNormal = 0
var killedByFast = 0
var killedByTank = 0
var highestScore = 0
var totalScore = 0
var highestMoney = 0
var totalMoney = 0
var moneySpent = 0

#other stuff
var node_creation_parent = null
var player = []
var camera = null
var previous_high_score = 0
var delta_money = 0
var score = 0
var music_time = 0

const save_path = "user://savefileee.cfg"

var save_file = ConfigFile.new()
var save_dict = {}

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func _ready():
	save()
	load_game()
	TranslationServer.set_locale('pt')

func save():
	save_dict = {
	"general": {
		"highscore": high_score,
		"money": money,
		"max_hearts": max_hearts,
		"color": color,
		"colors_available": color_index
	},
	"settings": {
		"post_processing": postprocess,
		"color_blind_mode": colorBlindMonde,
		"particles": particles,
		"particle_fade_time": particleFadeTime,
		"music": music,
		"sound_effects": soundEffects,
		"ui_sounds": UISounds,
		"language": lang
	},
	"statistics": {
		"games_played": gamesPlayed,
		"bullets_fired": bulletsFired,
		"bullets_hit": bulletsHit,
		"precision": precision,
		"squares_destroyed": squaresDestroyed,
		"normal_squares_destroyed": normalSquaresDestroyed,
		"fast_squares_destroyed": fastSquaresDestroyed,
		"tank_squares_destroyed": tankSquaresDestroyed,
		"power_ups_collected": powerUpsCollected,
		"shoot_faster_collected": shootFaster,
		"health_up_collected": healthUp,
		"x2_collected": x2Collected,
		"damage_dealt": damageDealt,
		"damage_taken": damageTaken,
		"deaths": deaths,
		"killed_by_normal": killedByNormal,
		"killed_by_fast": killedByFast,
		"killed_by_tank": killedByTank,
		"highest_score": highestScore,
		"total_score": totalScore,
		"highest_money": highestMoney,
		"total_money": totalMoney,
		"money_spent": moneySpent
	}
}

func save_game():
	save()
	
	for section in save_dict.keys():
		for key in save_dict[section]:
			save_file.set_value(section, key, save_dict[section][key])
	
	save_file.save(save_path)

func load_game():
	var error = save_file.load(save_path)
	if error != OK:
		print("Failed loading save file. Error code %s" % error)
		return null
	
	for section in save_dict.keys():
		for key in save_dict[section]:
			save_dict[section][key] = save_file.get_value(section, key, null)
	
	high_score = save_dict["general"]["highscore"]
	money = save_dict["general"]["money"]
	max_hearts = save_dict["general"]["max_hearts"]
	color = save_dict["general"]["color"]
	color_index = save_dict["general"]["colors_available"]
	
	postprocess = save_dict["settings"]["post_processing"]
	colorBlindMonde = save_dict["settings"]["color_blind_mode"]
	particles = save_dict["settings"]["particles"]
	particleFadeTime = save_dict["settings"]["particle_fade_time"]
	music = save_dict["settings"]["music"]
	soundEffects = save_dict["settings"]["sound_effects"]
	UISounds = save_dict["settings"]["ui_sounds"]
	lang = save_dict["settings"]["language"]
	
	gamesPlayed = save_dict["statistics"]["games_played"]
	bulletsFired = save_dict["statistics"]["bullets_fired"]
	bulletsHit = save_dict["statistics"]["bullets_hit"]
	precision = save_dict["statistics"]["precision"]
	squaresDestroyed = save_dict["statistics"]["squares_destroyed"]
	normalSquaresDestroyed = save_dict["statistics"]["normal_squares_destroyed"]
	fastSquaresDestroyed = save_dict["statistics"]["fast_squares_destroyed"]
	tankSquaresDestroyed = save_dict["statistics"]["tank_squares_destroyed"]
	shootFaster = save_dict["statistics"]["shoot_faster_collected"]
	healthUp = save_dict["statistics"]["health_up_collected"]
	x2Collected = save_dict["statistics"]["x2_collected"]
	damageDealt = save_dict["statistics"]["damage_dealt"]
	damageTaken = save_dict["statistics"]["damage_taken"]
	deaths = save_dict["statistics"]["deaths"]
	killedByNormal = save_dict["statistics"]["killed_by_normal"]
	killedByFast = save_dict["statistics"]["killed_by_fast"]
	killedByTank = save_dict["statistics"]["killed_by_tank"]
	highestScore = save_dict["statistics"]["highest_score"]
	totalScore = save_dict["statistics"]["total_score"]
	highestMoney = save_dict["statistics"]["highest_money"]
	totalMoney = save_dict["statistics"]["total_money"]
	moneySpent = save_dict["statistics"]["money_spent"]
	
