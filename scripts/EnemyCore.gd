extends Sprite

var velocity = Vector2()
var r = 0

export(int) var speed = 0
export(int) var hp = 0
export(int) var shake = 0
export(int) var knockback = 0
export(int) var score = 0
export(int) var money = 0

var stun = false
var get_target = true

var particles = preload("res://scenes/particles/BloodParticles.tscn")
var death = preload("res://scenes/soundEffects/DeathSound.tscn")

onready var color = modulate

func basic_movement_towars_player(delta):
	if Global.player.size() > 0:
		if Global.player[r] != null and stun == false:
			if get_target == true: 
				r = round(rand_range(0, Global.player.size() - 1))
				if Global.player[r].is_dead: get_target = true
				else: get_target = false
			var dist = global_position.distance_to(Global.player[r].global_position)
			if dist > 8:
				velocity = global_position.direction_to(Global.player[r].global_position)
			else:
				velocity = lerp(velocity, Vector2(0,0), 0.3)
		elif stun:
			velocity = lerp(velocity, Vector2(0,0), 0.3)
		global_position += velocity * speed * delta

func check_death():
	if hp <= 0:
		if Global.camera != null:
			Global.camera.screen_shake(shake, 0.1)
		kill()

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyDamager"):
		Global.bulletsHit += 1
		modulate = Color.white
		velocity = - velocity * knockback
		stun = true
		hp -= area.get_parent().damage
		if hp > 0:
			$Damage.play()
		$StunTimer.start()
		area.get_parent().queue_free()

func _on_StunTimer_timeout() -> void:
	modulate = color
	stun = false

func kill():
	Global.score += score
	Global.delta_money += money
	if Global.node_creation_parent != null:
		var blood = Global.instance_node(particles, global_position, Global.node_creation_parent)
		blood.rotation = velocity.angle()
		blood.modulate = Color.from_hsv(color.h, 0.75, color.v)
		queue_free()
