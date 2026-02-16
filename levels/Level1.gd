extends Node2D

@onready var portal = $ExitPortal

func _ready():

	$LevelTimer.start()

	portal.visible = false
	portal.get_node("CollisionShape2D").disabled = true

	print("Уровень начался")


func _on_level_timer_timeout():

	print("Портал появился")

	portal.visible = true
	portal.get_node("CollisionShape2D").disabled = false
