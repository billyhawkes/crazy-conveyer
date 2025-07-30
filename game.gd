extends Node3D

const TRACK = preload("uid://kmmopcj4rtju")
@onready var track_container: Node3D = $TrackContainer
@onready var item_container: Node3D = $ItemContainer


func _ready() -> void:
	spawn_tracks()
	spawn_item()
	
var item_tick := Globals.tick_length

func _process(delta: float) -> void:
	item_tick += delta
	
	if item_tick > Globals.tick_length:
		item_tick = 0
		var items = item_container.get_children() as Array[Item]
		for item in items:
			var track_length = track_container.get_child_count()
			var next_track_index = item.current_track.get_index() + 1
			if next_track_index == track_length:
				next_track_index = 0
			print(next_track_index)
			item.update_track(track_container.get_child(next_track_index))
			
		
	
	
func spawn_tracks() -> void:
	for x in 12:
		var mesh = TRACK.instantiate()
		track_container.add_child(mesh)
	
func spawn_item() -> void:
	var tracks = track_container.get_children()
	var item = Item.create(tracks[0])
	item_container.add_child(item)
