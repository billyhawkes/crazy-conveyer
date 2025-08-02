extends Node

var items = ItemEvents.new()
var game = GameEvents.new()
var sound = SoundEvents.new()

class ItemEvents:
	signal processed(value: int)
	signal create

class GameEvents:
	signal money_changed
	signal speed_changed(value: float)

class SoundEvents:
	signal toggle_music
	signal toggle_sounds
