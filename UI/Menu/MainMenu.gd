extends Control

@export var game : PackedScene

var mobile = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Highscore.text = "Highscore: " + str(load_data_from("user://highscore"))

func _on_texture_button_pressed() -> void:
	var instance = game.instantiate()
	instance.mobile = mobile
	get_tree().get_root().add_child(instance)
	queue_free()

func load_data_from(save_path : String):
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		return file.get_var()
	else:
		return 0

func _on_texture_button_2_toggled(toggled_on: bool) -> void:
	mobile = toggled_on
