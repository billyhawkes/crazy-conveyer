extends Node3D
class_name Item

const ITEM = preload("uid://cne1vytdqkooy")

@export var current_track: Track
@export var game_enabled = true

enum State {
	Waiting,
	Processing,
	Done,
	Moving,
}

var state := State.Waiting

func _process(_delta: float) -> void:
	if state == State.Waiting || state == State.Done: 
		var track_length = current_track.get_parent().get_child_count()
		var next_track_index = current_track.get_index() + 1
		if next_track_index == track_length:
			next_track_index = 0
		var next_track = current_track.get_parent().get_child(next_track_index)
		var items = get_parent().get_children()
		var is_next_track_full
		for item in items:
			if item.current_track == next_track:
				is_next_track_full = true
				state = State.Waiting
		if !is_next_track_full:
			update_track(next_track)	

func _ready() -> void:
	global_position = current_track.global_position

func update_track(new_track: Track) -> void:
	state = State.Moving
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_track.global_position, Globals.get_value().speed).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(process_item).set_delay(Globals.get_value().speed)
	current_track = new_track
	
func process_item() -> void:
	var processing = current_track.get_value()
	if game_enabled:
		var indicator_text: String = ""
		Globals.money += processing.value
		Events.items.processed.emit(processing.value)
		Events.game.money_changed.emit()
		indicator_text = str("$", processing.value)
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.15 + (randi() % 10 * 0.05), 1.0, 1.15 + (randi() % 10 * 0.05)), Globals.get_value().speed / 5).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), Globals.get_value().speed / 5).set_trans(Tween.TRANS_BOUNCE)
		
		var indicator = Indicator.create(indicator_text)
		add_child(indicator)
		
		if current_track.get_index() == 0:
			Globals.money += Globals.get_value().loop
			await get_tree().create_timer(0.2).timeout
			var loop_indicator = Indicator.create(str("$", Globals.get_value().loop))
			add_child(loop_indicator)
		await get_tree().create_timer(processing.speed).timeout
	else:
		await get_tree().create_timer(0.2).timeout
	state = State.Done
	
static func create(track: Track) -> Item:
	var new_item = ITEM.instantiate()
	new_item.current_track = track
	return new_item
