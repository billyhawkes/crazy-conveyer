extends Node3D
class_name Item

const ITEM = preload("uid://cne1vytdqkooy")

var current_track: Track


func _ready() -> void:
	global_position = current_track.global_position

func update_track(new_track: Track) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_track.position, Globals.tick_length * 0.8).set_trans(Tween.TRANS_SINE)
	current_track = new_track

static func create(track: Track) -> Item:
	var new_item = ITEM.instantiate()
	new_item.current_track = track
	return new_item
