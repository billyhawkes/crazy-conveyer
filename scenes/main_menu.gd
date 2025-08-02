extends Node3D

@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	if Globals.load_game() != null:
		continue_button.visible = true
	else:
		continue_button.visible = false

func _on_quit_button_pressed() -> void:
	Audio.play_click()
	get_tree().quit()


func _on_continue_button_pressed() -> void:
	Audio.play_click()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_new_button_pressed() -> void:
	Audio.play_click()
	Globals.clear_save()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
