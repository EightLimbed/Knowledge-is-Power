extends CanvasLayer

var input : Vector2 = Vector2.ZERO
var dash : bool = false
var shoot : bool = false

#up
func _on_up_pressed() -> void:
	input.y -= 1

func _on_up_released() -> void:
	input.y += 1

#down
func _on_down_pressed() -> void:
	input.y += 1

func _on_down_released() -> void:
	input.y -= 1

#right
func _on_right_pressed() -> void:
	input.x += 1

func _on_right_released() -> void:
	input.x -= 1

#left
func _on_left_pressed() -> void:
	input.x -= 1

func _on_left_released() -> void:
	input.x += 1

#dash
func _on_dash_pressed() -> void:
	dash = true

func _on_dash_released() -> void:
	dash = false

#shoot
func _on_shoot_pressed() -> void:
	shoot = true

func _on_shoot_released() -> void:
	shoot = false
