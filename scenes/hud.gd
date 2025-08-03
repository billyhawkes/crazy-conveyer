extends Control

@onready var money_label: Label = %MoneyLabel

@onready var speed_label: Label = %SpeedLabel
@onready var speed_button: Button = %SpeedButton
@onready var items_label: Label = %ItemsLabel
@onready var items_button: Button = %ItemsButton
@onready var loop_label: Label = %LoopLabel
@onready var loop_button: Button = %LoopButton
@onready var prestige_label: Label = %PrestigeLabel
@onready var prestige_button: Button = %PrestigeButton

func _ready() -> void:
	Events.game.money_changed.connect(_on_money_changed)
	render_ui()
	
func render_ui() -> void:
	var value = Globals.get_value()
	speed_label.text = str(value.speed, "s")
	items_label.text = str(int(value.items))
	loop_label.text = str(int(value.loop))
	money_label.text = str("$", int(Globals.money))
	var upgrade_cost = Globals.get_upgrade_cost()
	speed_button.text = str("$", int(upgrade_cost.speed))
	items_button.text = str("$", int(upgrade_cost.items))
	loop_button.text = str("$", int(upgrade_cost.loop))
	prestige_label.text = str(int(Globals.prestige_items), " Items")
	prestige_button.text = str("Store ", int(Globals.levels.items), " Items")
	if Globals.levels.items >= 6:
		prestige_button.disabled = false
	else:
		prestige_button.disabled = true
	if Globals.prestige_items == 0:
		prestige_label.visible = false
	if Globals.max_levels.speed == Globals.levels.speed:
		speed_button.visible = false
	if Globals.max_levels.items == Globals.levels.items:
		items_button.visible = false
	if Globals.max_levels.loop == Globals.levels.loop:
		loop_button.visible = false

	
func _on_money_changed() -> void:
	money_label.text = str("$", Globals.money)

func _on_speed_button_pressed() -> void:
	Audio.play_click()
	var cost = Globals.get_upgrade_cost().speed
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.speed += 1
		Events.game.speed_changed.emit(Globals.levels.speed)
		Events.game.money_changed.emit()
		render_ui()

func _on_items_button_pressed() -> void:
	Audio.play_click()
	var cost = Globals.get_upgrade_cost().items
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.items += 1
		Events.items.create.emit()
		Events.game.money_changed.emit()
		render_ui()

func _on_loop_button_pressed() -> void:
	Audio.play_click()
	var cost = Globals.get_upgrade_cost().loop
	if Globals.money >= cost:
		Globals.money -= cost
		Globals.levels.loop += 1
		Events.game.money_changed.emit()
		render_ui()


func _on_exit_button_pressed() -> void:
	Audio.play_click()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_prestige_button_pressed() -> void:
	Audio.play_click()
	if Globals.levels.items >= 6:
		Globals.prestige_items += Globals.levels.items
		Globals.reset()
		for track in get_tree().get_nodes_in_group("Track"):
			track.reset()
		Globals.save_game()
		get_tree().change_scene_to_file("res://scenes/game.tscn")
