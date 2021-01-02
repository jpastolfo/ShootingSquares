extends Sprite

export var id = 0
var speed = 150
var velocity = Vector2()
var reload_speed = 0.2
var default_reload_speed = reload_speed
var damage = 1
var default_damage = damage
var health = 3
var max_health = 3

onready var color = Global.color
onready var joystick = get_parent().get_node("MovementJoystick/Joystick_Button")
onready var shooting_joystick = get_parent().get_node("ShootingJoystick/Joystick_Button")

var power_up_reset = []
export(Array, PackedScene) var sounds

var can_shoot = true
var is_dead = false
var joypads = []

var bullet = preload("res://scenes/Bullet.tscn")
var particles = preload("res://scenes/particles/BloodParticles.tscn")

signal health_updated(health, a, color, id)
signal dead

func _ready() -> void:
	max_health = int(Global.max_hearts)
	health = max_health
	if Global.color != null:
		modulate = color
	else: modulate = Color.blue
	emit_signal("health_updated", health, false, color, id)
	Global.player.append(self)
	joypads = Input.get_connected_joypads()

func _process(delta):
	#Movement
	if id == 9: #Keyboard
		velocity.x = int(Input.is_action_pressed("right_%s" % id)) - int(Input.is_action_pressed("left_%s" % id))
		velocity.y = int(Input.is_action_pressed("down_%s" % id)) - int(Input.is_action_pressed("up_%s" % id))
	elif id != 9 and id != 10: #Controller
		velocity.x = Input.get_action_strength("right_%s" % id) - Input.get_action_strength("left_%s" % id)
		velocity.y = Input.get_action_strength("down_%s" % id) - Input.get_action_strength("up_%s" % id)
	elif id == 10: #Mobile
		velocity = joystick.get_value()
	velocity.normalized()
	
	global_position.x = clamp(global_position.x, 8, 632)
	global_position.y = clamp(global_position.y, 8, 352)
	
	if is_dead == false:
		global_position += speed * velocity * delta
	
	#Shooting
	#Mouse
	if id == 9 and Input.is_action_pressed("click") and is_dead == false and can_shoot and Global.node_creation_parent != null:
		var shoot_dir = get_global_mouse_position() - global_position
		shoot(shoot_dir.angle())
		$Reload_speed.start()
		can_shoot = false
	elif id != 9 and id!= 10 and is_dead == false and can_shoot and Global.node_creation_parent != null:
		#Controller
		var shoot_dir = Vector2()
		shoot_dir.x = Input.get_action_strength("R_right_%s" % id) - Input.get_action_strength("R_left_%s" % id)
		shoot_dir.y = Input.get_action_strength("R_down_%s" % id) - Input.get_action_strength("R_up_%s" % id)
		if shoot_dir != Vector2(0,0): shoot(shoot_dir.angle())
		$Reload_speed.start()
		can_shoot = false
	elif id == 10 and is_dead == false and can_shoot and Global.node_creation_parent != null:
		#Mobile
		var shoot_dir = shooting_joystick.get_value()
		if shoot_dir != Vector2(0,0): shoot(shoot_dir.angle())
		$Reload_speed.start()
		can_shoot = false
	
	#Test Death
	if health <= 0:
		if Global.node_creation_parent != null:
			is_dead = true
			visible = false
			Global.save_game()
			$Hitbox/CollisionShape2D.disabled = true

func shoot(function):
	Global.bulletsFired += 1
	var bullet_instance = Global.instance_node(bullet, global_position, Global.node_creation_parent)
	bullet_instance.damage = damage
	bullet_instance.modulate = modulate
	bullet_instance.rotation = function
	$Sounds/Shoot.play()

func _on_Reload_speed_timeout() -> void:
	can_shoot = true
	$Reload_speed.wait_time = reload_speed

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if Global.camera != null:
			Global.camera.screen_shake(60, 0.1)
		if id != 9 && health > 0:
				Input.start_joy_vibration(id, 1, 0, 0.5)
		elif id != 9 && health <= 0:
			Input.start_joy_vibration(id, 0, 1, 0.75)
		health -= 1
		self.modulate = Color.white
		$StunTimer.start()
		emit_signal("health_updated", health, true, color, id)
		var blood = Global.instance_node(particles, global_position, Global.node_creation_parent)
		blood.rotation = area.get_parent().velocity.angle()
		blood.modulate = Color.from_hsv(color.h, 0.75, color.v)
		area.get_parent().kill()
		if health <= 0:
			$Sounds/Death.play()
			yield(get_tree().create_timer(1), "timeout")
			emit_signal("dead")
			Global.deaths += 1
		else: $Sounds/Damage.play()
	elif area.is_in_group("Heal"):
		health += 1
		health = clamp(health, 0, max_health)
		emit_signal("health_updated", health, false, color, id)
		$Sounds/PowerUp.play()

func _on_PowerUpCooldown_timeout() -> void:
	if power_up_reset.find("PowerUp_Reload") != null:
		reload_speed = default_reload_speed
		power_up_reset.erase("PowerUp_Reload")
	elif power_up_reset.find("PowerUp_Damage") != null:
		damage = default_damage
		power_up_reset.erase("PowerUp_Damage")

func _on_StunTimer_timeout() -> void:
	modulate = color
