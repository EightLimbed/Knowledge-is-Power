extends Control

@export var game : PackedScene

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)
