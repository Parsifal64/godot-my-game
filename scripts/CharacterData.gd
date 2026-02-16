extends Node

signal character_changed
signal character_level_up


var CHARACTERS = {

	"Soldier":
	{
		"level": 1,
		"xp": 0,
		"xp_to_next": 100,
		"mod_slots": 2,
		
		"base_health": 100,
		"base_damage": 1.0,
		"base_speed": 300,
		
		"sprite": "res://assets/characters/soldier.png"
	},

	"Scout":
	{
		"level": 1,
		"xp": 0,
		"xp_to_next": 100,
		"mod_slots": 2,
		
		"base_health": 75,
		"base_damage": 1.2,
		"base_speed": 350,
		
		"sprite": "res://assets/characters/scout.png"
	}

}


var current_character = "Soldier"


func get_current():

	return CHARACTERS[current_character]


func set_character(name):

	if name in CHARACTERS:

		current_character = name

		character_changed.emit()

		print("Персонаж выбран:", name)


func add_xp(amount):

	var char = CHARACTERS[current_character]

	char.xp += amount

	if char.xp >= char.xp_to_next:

		level_up()


func level_up():

	var char = CHARACTERS[current_character]

	if char.level >= 50:
		return

	char.xp = 0

	char.level += 1

	char.xp_to_next *= 1.2

	if char.level % 5 == 0:
		char.mod_slots += 1

	character_level_up.emit()

	print("Level up:", char.level)
