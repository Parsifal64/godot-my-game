extends CanvasLayer

@onready var close_button = $Panel/Panel/Close


func _ready():
	visible = false
	close_button.pressed.connect(_on_close_pressed)


func open_menu():
	visible = true
	get_tree().current_scene.get_node("Player").input_locked = true


func close_menu():
	visible = false
	get_tree().current_scene.get_node("Player").input_locked = false


func _on_close_pressed():
	close_menu()
