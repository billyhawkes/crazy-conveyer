extends StaticBody3D
class_name Track

@onready var upgrade_menu: Control = $UpgradeMenu

@onready var speed_button: Button = %SpeedButton
@onready var speed_label: Label = %SpeedLabel
@onready var value_button: Button = %ValueButton
@onready var value_label: Label = %ValueLabel
@onready var title: Label = %Title

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

@export var custom_position = false

var level = {
	"speed": 1,
	"value": 1
}

var max_levels = {
	"speed": 9,
	"value": 100
}


var active = false

func _ready() -> void:
	var index = get_index()
	if !custom_position:
		global_position = TRACK_POSITIONS[index] * 2
	upgrade_menu.visible = false
	render_ui()

func render_ui() -> void:
	title.text = str("Track ", get_index() + 1)
	var processing = get_value()
	speed_label.text = str(processing.speed, "s")
	value_label.text = str("$", processing.value)
	speed_button.text = str("$", get_upgrade_cost().speed)
	value_button.text = str("$", get_upgrade_cost().value)
	if max_levels.speed == level.speed:
		speed_button.visible = false
	if max_levels.value == level.value:
		value_button.visible = false
	
func get_value():
	return {
		"speed": 2 - ((level.speed - 1) * 0.2),
		"value": level.value
	}
	
func get_upgrade_cost():
	return {
		"speed": level.speed ** 2,
		"value": level.value ** 2
	}
	
func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("press"):
		close_all()
		active = true
		upgrade_menu.visible = true
		
func _process(_delta: float) -> void:
	if upgrade_menu.visible:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.1, 1.1, 1.1), 0.08).set_trans(Tween.TRANS_BOUNCE)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.08).set_trans(Tween.TRANS_BOUNCE)


func _on_close_button_pressed() -> void:
	active = false
	upgrade_menu.visible = false

func _on_speed_button_pressed() -> void:
	var cost = get_upgrade_cost().speed
	if Globals.money >= cost:
		Globals.money -= cost
		level.speed += 1
		Events.game.money_changed.emit()
		render_ui()

func _on_value_button_pressed() -> void:
	var cost = get_upgrade_cost().value
	if Globals.money >= cost:
		Globals.money -= cost
		level.value += 1
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
		track._on_close_button_pressed()
		track.active = false
