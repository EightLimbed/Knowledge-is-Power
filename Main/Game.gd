extends Node2D

@onready var player = $Player
@onready var healthbar = $HUD/HealthBar
@onready var dashbar = $HUD/DashBar

func _process(_delta):
	healthbar.update(0, player.health, player.max_health)
	dashbar.update(0, player.dash_charge, player.dash_cooldown)
	if healthbar.visible:
		dashbar.position.y = 28
	else:
		dashbar.position.y = 4

func _on_dungeon_next_level():
	$Player.position = Vector2(0,0)
	$Player.health = $Player.max_health
	clear_children($EnemiesContainer)
	clear_children($ProjectilesContainer)

#clears children of a node
func clear_children(node):
	for n in node.get_children():
		n.queue_free()
