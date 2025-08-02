extends Node3D

const TRACK = preload("uid://kmmopcj4rtju")
@onready var track_container: Node3D = $TrackContainer
@onready var item_container: Node3D = $ItemContainer


func _ready() -> void:
	spawn_tracks()
	for _index in Globals.levels.items:
		spawn_item()	
	Events.items.create.connect(_on_create_item)
	
func _on_create_item() -> void:
	spawn_item()
	
func spawn_tracks() -> void:
	for x in 12:
		var mesh = TRACK.instantiate()
		track_container.add_child(mesh)
	
func spawn_item() -> void:
	var tracks = track_container.get_children()
	var item = Item.create(tracks[0])
	item_container.add_child(item)
