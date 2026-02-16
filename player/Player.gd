extends CharacterBody2D

@export var speed = 300.0
@export var auto_aim_radius = 500.0

@onready var bullet_scene = preload("res://weapons/Bullet.tscn")
@onready var bullet_spawn = $BulletSpawn
@onready var melee_swing = $MeleeSwing

var current_primary_weapon = ""
var last_move_direction = Vector2.RIGHT
var fire_timer = 0.0
var fire_cooldown = 0.0
var input_locked = false

func _ready():
	current_primary_weapon = PlayerData.primary_weapon
	PlayerData.weapon_changed.connect(update_weapon)
	print("Оружие игрока:", current_primary_weapon)
	print("Текущий персонаж:", CharacterData.current_character)
	print("Level:", CharacterData.get_current().level)


func _physics_process(delta):
	if input_locked:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	handle_movement(delta)
	
	if fire_cooldown > 0:
		fire_cooldown -= delta



# -------------------------
# ДВИЖЕНИЕ
# -------------------------

func handle_movement(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if direction != Vector2.ZERO:
		last_move_direction = direction.normalized()


# -------------------------
# АВТОСТРЕЛЬБА
# -------------------------

func handle_auto_fire(delta):
	fire_timer -= delta
	
	var weapon = WeaponData.WEAPONS[current_primary_weapon]
	
	if fire_timer <= 0:
		fire_timer = weapon.fire_rate
		
		if weapon.type == "gun":
			shoot()
		
		elif weapon.type == "melee":
			melee_attack()


# -------------------------
# СТРЕЛЬБА
# -------------------------

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = bullet_spawn.global_position
	
	var target = find_nearest_enemy()
	
	if target != null:
		bullet.direction = (target.global_position - global_position).normalized()
	else:
		bullet.direction = last_move_direction


# -------------------------
# MELEE АТАКА
# -------------------------

func melee_attack():
	var weapon = WeaponData.WEAPONS[current_primary_weapon]
	
	melee_swing.visible = true
	melee_swing.rotation = last_move_direction.angle()
	
	await get_tree().create_timer(0.15).timeout
	
	melee_swing.visible = false
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		
		var to_enemy = enemy.global_position - global_position
		
		if to_enemy.length() <= weapon.range:
			
			var angle_to_enemy = rad_to_deg(last_move_direction.angle_to(to_enemy.normalized()))
			
			if abs(angle_to_enemy) <= weapon.angle / 2:
				
				if enemy.has_method("take_damage"):
					enemy.take_damage(weapon.damage)



# -------------------------
# AUTO AIM
# -------------------------

func find_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	var nearest = null
	var nearest_distance = auto_aim_radius
	
	for enemy in enemies:
		
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < nearest_distance:
			
			nearest_distance = distance
			nearest = enemy
	
	return nearest


# -------------------------
# ОБНОВЛЕНИЕ ОРУЖИЯ
# -------------------------

func update_weapon():
	print("сигнал получен")
	current_primary_weapon = PlayerData.primary_weapon
	print("Оружие обновлено:", current_primary_weapon)
	
#огонь по кнопке
func _input(event):
	if input_locked:
		return
	
	if event.is_action_pressed("shoot"):
		fire()
		
func fire():
	if fire_cooldown > 0:
		return
	
	var weapon = WeaponData.WEAPONS[current_primary_weapon]
	
	fire_cooldown = weapon.fire_rate
	
	if weapon.type == "gun":
		shoot()
	
	elif weapon.type == "melee":
		melee_attack()

	
	
	
