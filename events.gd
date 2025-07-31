extends Node

var items = ItemEvents.new()

class ItemEvents:
	signal processed(value: int)
	signal sold(value: int)
