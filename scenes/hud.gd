extends Control

@onready var money_label: Label = %MoneyLabel

@onready var speed_label: Label = %SpeedLabel
@onready var speed_button: Button = %SpeedButton
@onready var items_label: Label = %ItemsLabel
@onready var items_button: Button = %ItemsButton
@onready var loop_label: Label = %LoopLabel
@onready var loop_button: Button = %LoopButton

func _ready() -> void:
	Events.game.money_changed.connect(_on_money_changed)
	render_ui()
	
func render_ui() -> void: 
	var value = Globals.get_value()
	speed_label.text = str(value.speed, "s")
	items_label.text = str(value.items)
	loop_label.text = str(value.loop)
	var upgrade_cost = Globals.get_upgrade_cost()
	speed_button.text = str("$", upgrade_cost.speed)
	items_button.text = str("$", upgrade_cost.items)
	loop_button.text = str("$", upgrade_cost.loop)
	if Globals.max_levels.speed == Globals.levels.speed:
		speed_button.visible = false
	if Globals.max_levels.items == Globals.levels.items:
		items_button.visible = false
	if Globals.max_levels.loop == Globals.levels.loop:
		loop_button.visible = false

	
func _on_money_changed() -> void:
	money_label.text = str("$", Globals.money)

func _on_speed_button_pressed() -> void:
	var cost = Globals.get_upgrade_cost().speed
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.speed += 1
		Events.game.money_changed.emit()
		render_ui()

func _on_items_button_pressed() -> void:
	var cost = Globals.get_upgrade_cost().items
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.items += 1
		Events.items.create.emit()
		Events.game.money_changed.emit()
		render_ui()

func _on_loop_button_pressed() -> void:
	var cost = Globals.get_upgrade_cost().loop
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.loop += 1
		Events.game.money_changed.emit()
		render_ui()
