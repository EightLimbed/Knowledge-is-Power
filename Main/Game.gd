extends Node2D

@onready var player = $Player
@onready var healthbar = $HUD/VBoxContainer/HealthBar
@onready var dashbar = $HUD/VBoxContainer/DashBar
@onready var manabar = $HUD/VBoxContainer/ManaBar
@onready var score_label = $HUD/Score
#grimoire weightings
var weightings = [0,0,1,1,1,1,3,4]
var score = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	healthbar.update(0, player.health, player.max_health)
	dashbar.update(0, player.dash_charge, player.dash_cooldown)
	manabar.update(0, player.mana, player.max_mana)
	score_label.text = "Score: " + str(score)

func _on_dungeon_next_level():
	score += $Dungeon.current_level**2 * 100
	$Player.position = Vector2(0,0)
	$Player.health = $Player.max_health
	clear_children($EnemiesContainer)
	clear_children($ProjectilesContainer)
	clear_children($AfterimagesContainer)
	if $Dungeon.current_level != 0:
		clear_children($PickupsContainer)

#clears children of a node
func clear_children(node):
	for n in node.get_children():
		n.queue_free()

func player_death():
	$HUD/VBoxContainer.hide()
	$HUD/Score.hide()
	$HUD/Death.show()
	$HUD/Death/VBoxContainer/Label.text += str(score)
	clear_children($EnemiesContainer)
	clear_children($ProjectilesContainer)
	player.hide()
	if load_data_from("user://highscore") < score:
		save_data_to("user://highscore",score)
		$HUD/Death/VBoxContainer/Label.text += "\n New High Score"

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menu/MainMenu.tscn")

func save_data_to(save_path : String, data):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)

func load_data_from(save_path : String):
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		return file.get_var()
	else:
		return 0
