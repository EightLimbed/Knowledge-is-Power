extends Control

@export var game : PackedScene

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Highscore.text = "Highscore: " + str(load_data_from("user://highscore"))

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)

func load_data_from(save_path : String):
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		return file.get_var()
	else:
		return 0
