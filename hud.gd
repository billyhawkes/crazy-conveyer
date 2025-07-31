extends Control

@onready var money_label: Label = %MoneyLabel

func _ready() -> void:
	Events.items.sold.connect(_on_item_sold)
	
func _on_item_sold(value: int) -> void:
	money_label.text = str("$", Globals.money)
