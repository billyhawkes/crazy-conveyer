extends Node

var money: int = 0

var levels = {
	"speed": 1,
	"items": 1,
	"loop": 1
}

var max_levels = {
	"speed": 9,
	"items": 11,
	"loop": 100
}

var prestige_items = 0

func get_upgrade_cost():
	return {
		"speed": ((levels.speed + 1) * 2) ** 3,
		"items": ((levels.items + 1) * 3) ** 3,
		"loop": ((levels.loop + 2) * 2) ** 2,
	}
	
func get_value():
	return {
		"speed": 0.5 - ((levels.speed - 1) * 0.05),
		"items": levels.items,
		"loop": levels.loop * 10
	}
	
var saved_data
	
func _ready() -> void:
	var data = load_game()
	if data:
		saved_data = data
		levels = data.levels
		money = data.money
		prestige_items = data.prestige_items
	Events.game.money_changed.connect(save_game)
	Events.game.speed_changed.emit(levels.speed)

const PATH = "user://"

func reset() -> void:
	money = 0
	levels = {
		"speed": 1,
		"items": 1,
		"loop": 1
	}
	Events.game.money_changed.emit()
	Events.game.speed_changed.emit(levels.speed)

func clear_save() -> void:
	saved_data = null
	prestige_items = 0
	reset()
	DirAccess.remove_absolute(PATH)
	
func save_game() -> void:
	var file = FileAccess.open(PATH + "save.json", FileAccess.WRITE)
	var tracks = get_tree().get_nodes_in_group("Track") as Array[Track]
	var track_values = []
	for track in tracks:
		track_values.append(track.levels)
	file.store_string(JSON.stringify({
		"prestige_items": prestige_items,
		"money": money,
		"levels": levels,
		"tracks": track_values
	}))
	file.close()
		
func load_game():
	if FileAccess.file_exists(PATH + "save.json"):
		var file = FileAccess.open(PATH + "save.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	else:
		return null
