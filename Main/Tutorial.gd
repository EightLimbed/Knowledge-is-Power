extends CanvasLayer

var step : int = 0

@export var icon_list : Array[Texture]

@onready var label = $HBoxContainer/Label
@onready var icon = $HBoxContainer/TextureRect
@onready var game = get_parent()

func _process(_delta) -> void:
	if step == 0:
		label.text = "WASD or arrows to move."
		icon.visible = false
		if Input.is_action_just_pressed("ui_down"):
			if $Timer.time_left == 0.0: $Timer.start()
	if step == 1:
		label.text = "Pick up the grimoire."
		icon.visible = true
		icon.texture = icon_list[0]
		if game.get_node("PickupsContainer").get_child_count() < 1:
			if $Timer.time_left == 0.0: $Timer.start()
	if step == 2:
		icon.visible = false
		label.text = "Mouse buttons to shoot."
		if Input.is_action_just_pressed("Mouse"):
			if $Timer.time_left == 0.0: $Timer.start()
	if step == 3:
		icon.visible = true
		icon.texture = icon_list[1]
		label.text = "Go to the next room."
		#print(game.player.position.length())
		if abs(game.player.position.length()) > 600:
			if $Timer.time_left == 0.0: $Timer.start()
	if step == 4:
		icon.visible = true
		label.text = "Kill 3 enemies."
		icon.texture = icon_list[2]
		if game.score >= 99:
			if $Timer.time_left == 0.0: $Timer.start()
	if step == 5:
		icon.visible = false
		label.text = "Find the portal, and repeat."
		if $Timer.time_left == 0.0: $Timer.start(5.0)
	if step == 6: queue_free()

func _on_timer_timeout() -> void:
	step += 1
