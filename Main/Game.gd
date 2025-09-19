extends Node2D

@onready var player = $Player
@onready var healthbar = $HUD/VBoxContainer/HealthBar
@onready var dashbar = $HUD/VBoxContainer/DashBar
@onready var manabar = $HUD/VBoxContainer/ManaBar
#grimoire weightings
var weightings = [0,0,1,1,1,1,3,4]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	healthbar.update(0, player.health, player.max_health)
	dashbar.update(0, player.dash_charge, player.dash_cooldown)
	manabar.update(0, player.mana, player.max_mana)

func _on_dungeon_next_level():
	$Player.position = Vector2(0,0)
	$Player.health = $Player.max_health
	clear_children($EnemiesContainer)
	clear_children($ProjectilesContainer)
	if $Dungeon.current_level != 0:
		clear_children($PickupsContainer)

#clears children of a node
func clear_children(node):
	for n in node.get_children():
		n.queue_free()
