extends Node

@onready var music: AudioStreamPlayer = $Music
const PROCESS = preload("uid://bb7aqxv6m0sku")
const CLICK = preload("uid://b1qlosepkvlx7")
const TRACK = preload("uid://w4i7lgxmj0bb")

func _ready() -> void:
	_set_music_speed(Globals.levels.speed)
	Events.game.speed_changed.connect(_set_music_speed)
	

func _set_music_speed(speed: int):
	music.pitch_scale = 1 + ((speed - 1) * 0.01)

func play_process() -> void:
	play_audio(PROCESS)
	
func play_click() -> void:
	play_audio(CLICK)

func play_track() -> void:
	play_audio(TRACK)

func play_audio(audio: AudioStream) -> void:
	var new_track = AudioStreamPlayer.new()
	new_track.stream = audio
	add_child(new_track)
	new_track.play()
	
