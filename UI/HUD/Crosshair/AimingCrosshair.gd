extends Node2D

var pressed : bool = false

func _process(_delta):
	if !DisplayServer.is_touchscreen_available() or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		global_position = round(get_global_mouse_position())

func _on_sprite_2d_button_down() -> void:
	pressed = true

func _on_sprite_2d_button_up() -> void:
	pressed = false
