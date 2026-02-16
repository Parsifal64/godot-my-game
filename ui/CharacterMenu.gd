extends CanvasLayer

@onready var name_label = $Panel/VBoxContainer/Label
@onready var level_label = $Panel/VBoxContainer/Label2

func _ready():
	update_ui()
	CharacterData.character_changed.connect(update_ui)
	CharacterData.character_level_up.connect(update_ui)

func update_ui():
	var char = CharacterData.get_current()
	name_label.text = "Персонаж: " + CharacterData.current_character
	level_label.text = "Уровень: " + str(char.level)

func _on_soldier_pressed():
	CharacterData.set_character("Soldier")

func _on_scout_pressed():
	CharacterData.set_character("Scout")

func _on_close_pressed():
	close_menu()
	
func open_menu():
	visible = true
	get_tree().current_scene.get_node("Player").input_locked = true

func close_menu():
	visible = false
	get_tree().current_scene.get_node("Player").input_locked = false
