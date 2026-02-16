extends Area2D

@export var interact_type = "weapon_terminal"

var player_in_range = false

@onready var label = $Label


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()


func interact():

	match interact_type:

		"weapon_terminal":
			var menu = get_tree().current_scene.get_node("WeaponMenu")
			
			if menu.visible:
				return
			
			menu.open_menu()

		"character_terminal":
			var menu = get_tree().current_scene.get_node("CharacterMenu")
			
			if menu.visible:
				return
			
			menu.open_menu()

		"level_portal":
			LevelManager.start_level("res://levels/Level1.tscn")

		_:
			print("Неизвестный тип")


func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		label.visible = true


func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		label.visible = false
