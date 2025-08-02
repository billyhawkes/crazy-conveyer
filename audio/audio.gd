extends Node

@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	_set_music_speed(Globals.levels.speed)
	Events.game.speed_changed.connect(_set_music_speed)
	

func _set_music_speed(speed: int):
	music.pitch_scale = 1 + ((speed - 1) * 0.01)
