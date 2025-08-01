extends Node

var money := 0

var levels = {
	"speed": 1,
	"items": 1,
	"loop": 1
}

var max_levels = {
	"speed": 9,
	"items": 10,
	"loop": 100
}

func get_upgrade_cost():
	return {
		"speed": (levels.speed * 5) ** 2,
		"items": (levels.items * 10) ** 2,
		"loop": (levels.speed * 2) ** 2,
	}
	
func get_value():
	return {
		"speed": 0.5 - ((levels.speed - 1) * 0.05),
		"items": levels.items,
		"loop": levels.loop * 10
	}
