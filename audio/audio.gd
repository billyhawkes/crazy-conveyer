extends Node

@onready var music: AudioStreamPlayer = $Music
const PROCESS = preload("uid://bb7aqxv6m0sku")
const CLICK = preload("uid://b1qlosepkvlx7")
const TRACK = preload("uid://w4i7lgxmj0bb")

var sounds_enabled = true
var music_enabled = true

func _ready() -> void:
	var settings = load_settings()
	if settings:
		sounds_enabled = settings.sounds_enabled
		music_enabled = settings.music_enabled
	if !music_enabled:
		music.stop()
	_set_music_speed(Globals.levels.speed)
	Events.sound.toggle_music.connect(_toggle_music)
	Events.sound.toggle_sounds.connect(_toggle_sounds)
	Events.game.speed_changed.connect(_set_music_speed)
	
func _toggle_music() -> void:
	music_enabled = !music_enabled
	if music_enabled:
		music.play()
	else:
		music.stop()
	save_settings()

func _toggle_sounds() -> void:
	sounds_enabled = !sounds_enabled
	save_settings()

func _set_music_speed(speed: int):
	music.pitch_scale = 1 + ((speed - 1) * 0.01)

func play_process() -> void:
	play_audio(PROCESS)
	
func play_click() -> void:
	play_audio(CLICK)

func play_track() -> void:
	play_audio(TRACK)

func play_audio(audio: AudioStream) -> void:
	if !sounds_enabled: return
	var new_track = AudioStreamPlayer.new()
	new_track.stream = audio
	add_child(new_track)
	new_track.play()

	
func save_settings() -> void:
	var file = FileAccess.open(Globals.PATH + "settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({
		"sounds_enabled": sounds_enabled,
		"music_enabled": music_enabled
	}))
	file.close()
		
func load_settings():
	if FileAccess.file_exists(Globals.PATH + "settings.json"):
		var file = FileAccess.open(Globals.PATH + "settings.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	else:
		return null
