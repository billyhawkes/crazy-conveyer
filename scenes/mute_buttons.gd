extends Control

@onready var music_button: Button = %MusicButton
@onready var sound_button: Button = %SoundButton
@onready var music_on: TextureRect = %MusicOn
@onready var music_off: TextureRect = %MusicOff
@onready var volume_on: TextureRect = %VolumeOn
@onready var volume_off: TextureRect = %VolumeOff

func _ready() -> void:
	set_music_icon(Audio.music_enabled)
	set_sound_icon(Audio.sounds_enabled)

func set_music_icon(on: bool) -> void:
	music_on.visible = on
	music_off.visible = !on

func set_sound_icon(on: bool) -> void:
	volume_on.visible = on
	volume_off.visible = !on

func _on_music_button_pressed() -> void:
	var new_toggle = !Audio.music_enabled
	Events.sound.toggle_music.emit()
	set_music_icon(new_toggle)

func _on_sound_button_pressed() -> void:
	var new_toggle = !Audio.sounds_enabled
	Events.sound.toggle_sounds.emit()
	set_sound_icon(new_toggle)
