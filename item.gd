extends Node3D
class_name Item

const ITEM = preload("uid://cne1vytdqkooy")

var current_track: Track

var value := 0

var processed := true

func _process(delta: float) -> void:
	if processed:
		var track_length = 12
		var next_track_index = current_track.get_index() + 1
		if next_track_index == track_length:
			next_track_index = 0
		update_track(current_track.get_parent().get_child(next_track_index))	
		processed = false

func _ready() -> void:
	global_position = current_track.global_position

func update_track(new_track: Track) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_track.position, Globals.tick_length).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(process_item).set_delay(Globals.tick_length)
	current_track = new_track
	
func process_item() -> void:
	var indicator_text: String = ""
	if current_track.is_origin:
		Globals.money += value
		Events.items.sold.emit(value)
		indicator_text = str("$", value)
		value = 0
	else:
		value += current_track.processing.value
		Events.items.processed.emit(current_track.processing.value)
		indicator_text = str("$", current_track.processing.value)
		
	var indicator = Indicator.create(indicator_text)
	add_child(indicator)
	await get_tree().create_timer(current_track.processing.time).timeout
	processed = true
	
static func create(track: Track) -> Item:
	var new_item = ITEM.instantiate()
	new_item.current_track = track
	return new_item
