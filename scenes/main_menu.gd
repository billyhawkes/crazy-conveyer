extends Node3D

const GAME = preload("uid://c8thehv1woo4s")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)
