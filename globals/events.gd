extends Node

var items = ItemEvents.new()
var game = GameEvents.new()

class ItemEvents:
	signal processed(value: int)
	signal create

class GameEvents:
	signal money_changed
	signal speed_changed(value: float)
