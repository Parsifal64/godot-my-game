extends Node

var current_level: Node = null
var hub: Node = null
var player: Node = null


func start_level(level_path: String):

	print("Загрузка уровня:", level_path)

	# сохранить hub
	hub = get_tree().current_scene

	# найти игрока
	player = get_tree().get_first_node_in_group("player")

	# загрузить уровень
	var level_scene = load(level_path)
	current_level = level_scene.instantiate()

	# добавить уровень
	get_tree().root.add_child(current_level)
	get_tree().current_scene = current_level

	# переместить игрока
	var spawn = current_level.get_node("PlayerSpawn")

	player.get_parent().remove_child(player)
	current_level.add_child(player)

	player.global_position = spawn.global_position

	print("Уровень загружен")


func return_to_hub():

	print("Возврат на базу")

	if player == null:
		player = get_tree().get_first_node_in_group("player")

	if current_level != null:

		player.get_parent().remove_child(player)

		current_level.queue_free()

	current_level = null

	get_tree().root.add_child(hub)
	get_tree().current_scene = hub

	hub.add_child(player)

	player.global_position = hub.get_node("Player").global_position

	print("Возврат завершён")
