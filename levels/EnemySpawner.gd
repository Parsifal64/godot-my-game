extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval = 1.0
@export var spawn_distance = 800.0

var timer = 0.0
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	
	if player == null:
		return
	
	timer -= delta
	
	if timer <= 0:
		
		timer = spawn_interval
		
		spawn_enemy()

func spawn_enemy():
	
	var direction = Vector2.RIGHT.rotated(randf() * TAU)
	
	var spawn_position = player.global_position + direction * spawn_distance
	
	var enemy = enemy_scene.instantiate()
	
	get_tree().current_scene.add_child(enemy)
	
	enemy.global_position = spawn_position
