extends Control

@onready var music_button: Button = %MusicButton
@onready var sound_button: Button = %SoundButton

const MUSIC_NOTE = preload("uid://c0ye0erxi3rvk")
const MUSIC_OFF = preload("uid://bjim4eppfop47")
const VOLUME_OFF = preload("uid://can6gjqcm5q8w")
const VOLUME_UP = preload("uid://d4xw70lvl22q")

func _ready() -> void:
	set_music_icon(Audio.music_enabled)
	set_sound_icon(Audio.sounds_enabled)

func set_music_icon(on: bool) -> void:
	if on:
		music_button.icon = MUSIC_NOTE
	else:
		music_button.icon = MUSIC_OFF

func set_sound_icon(on: bool) -> void:
	if on:
		sound_button.icon = VOLUME_UP
	else:
		sound_button.icon = VOLUME_OFF

func _on_music_button_pressed() -> void:
	var new_toggle = !Audio.music_enabled
	Events.sound.toggle_music.emit()
	set_music_icon(new_toggle)

func _on_sound_button_pressed() -> void:
	var new_toggle = !Audio.sounds_enabled
	Events.sound.toggle_sounds.emit()
	if new_toggle:
		sound_button.icon = VOLUME_UP
	else:
		sound_button.icon = VOLUME_OFF
