extends StaticBody3D
class_name Track

@onready var upgrade_menu: Control = $UpgradeMenu

@onready var speed_button: Button = %SpeedButton
@onready var speed_label: Label = %SpeedLabel
@onready var value_button: Button = %ValueButton
@onready var value_label: Label = %ValueLabel
@onready var title: Label = %Title
@onready var bonus_label: Label3D = %BonusLabel
const TRACK_POSITIONS: Array[Vector3] = [
	Vector3(0.0, 0.0, 0.0),
	Vector3(0.0, 0.0, 1.0),
	Vector3(0.0, 0.0, 2.0),
	Vector3(0.0, 0.0, 3.0),
	
	Vector3(1.0, 0.0, 3.0),
	Vector3(2.0, 0.0, 3.0),
	
	Vector3(3.0, 0.0, 3.0),
	Vector3(3.0, 0.0, 2.0),
	Vector3(3.0, 0.0, 1.0),
	Vector3(3.0, 0.0, 0.0),
	
	Vector3(2.0, 0.0, 0.0),
	Vector3(1.0, 0.0, 0.0),
]

@export var game_enabled = true

var levels := {
	"speed": 1,
	"value": 1
}

var max_levels := {
	"speed": 10,
	"value": 100
}

func get_value():
	return {
		"speed": 2 - ((levels.speed - 1) * 0.2),
		"value": levels.value
	}
	
func get_upgrade_cost():
	return {
		"speed": 8 * (levels.speed ** 2),
		"value": 4 * int(levels.value ** 1.5)
	}

func reset() -> void:
	levels = {
		"speed": 1,
		"value": 1
	}

var active := false

func _ready() -> void:
	if Globals.saved_data && game_enabled:
		levels = Globals.saved_data.tracks[get_index()]
	var index = get_index()
	if game_enabled:
		global_position = TRACK_POSITIONS[index] * 2
		if index == 0:
			bonus_label.visible = true
	upgrade_menu.visible = false
	render_ui()

func render_ui() -> void:
	title.text = str("Track ", get_index() + 1)
	var processing = get_value()
	speed_label.text = str(processing.speed, "s")
	value_label.text = str("$", int(processing.value))
	speed_button.text = str("$", int(get_upgrade_cost().speed))
	value_button.text = str("$", int(get_upgrade_cost().value))
	if max_levels.speed == levels.speed:
		speed_button.visible = false
	if max_levels.value == levels.value:
		value_button.visible = false

	
func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("press"):
		Audio.play_click()
		close_all()
		active = true
		upgrade_menu.visible = true
		
func _process(_delta: float) -> void:
	if !game_enabled:
		upgrade_menu.visible = false
	if upgrade_menu.visible:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.1, 1.1, 1.1), 0.08).set_trans(Tween.TRANS_BOUNCE)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.08).set_trans(Tween.TRANS_BOUNCE)


func _on_close_button_pressed() -> void:
	Audio.play_click()
	active = false
	upgrade_menu.visible = false

func _on_speed_button_pressed() -> void:
	Audio.play_click()
	var cost = get_upgrade_cost().speed
	if Globals.money >= cost:
		Globals.money -= cost
		levels.speed += 1
		Events.game.money_changed.emit()
		render_ui()

func _on_value_button_pressed() -> void:
	Audio.play_click()
	var cost = get_upgrade_cost().value
	if Globals.money >= cost:
		Globals.money -= cost
		levels.value += 1
		Events.game.money_changed.emit()
		render_ui()
	

func _on_mouse_entered() -> void:
	if get_active_track() == null:
		upgrade_menu.visible = true
	
func _on_mouse_exited() -> void:
	if get_active_track() != self:
		upgrade_menu.visible = false

func get_active_track() -> Track:
	var other_tracks = get_parent().get_children()
	for track in other_tracks:
		if track.active:
			return track
	return null
	
func close_all() -> void:
	var other_tracks = get_parent().get_children()
	for track in other_tracks:
		track.upgrade_menu.visible = false
		track.active = false
