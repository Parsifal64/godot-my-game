extends Node

signal weapon_changed

var primary_weapon = "Винтовка"
var secondary_weapon = "Пистолет"
var melee_weapon = "Меч"

func set_primary_weapon(value):
	primary_weapon = value
	weapon_changed.emit()
