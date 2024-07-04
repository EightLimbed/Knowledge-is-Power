extends Node2D

@onready var player = $Player
@onready var healthbar = $HUD/HealthBar
@onready var dashbar = $HUD/DashBar

func _process(_delta):
	healthbar.update(0, player.health, player.max_health)
	dashbar.update(0, player.dash, player.dash_cooldown)

func _on_dungeon_next_level():
	$Player.position = Vector2(0,0)
