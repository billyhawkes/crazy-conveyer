extends Node3D
class_name Indicator

@onready var label_3d: Label3D = $Label3D
const INDICATOR = preload("uid://b5lifti2svflr")

var text := ""

func _ready() -> void:
	label_3d.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector3(self.position.x, self.position.y + 1, self.position.z), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)
	
static func create(_text: String) -> Indicator:
	var new_indicator = INDICATOR.instantiate()
	new_indicator.text = _text
	return new_indicator
