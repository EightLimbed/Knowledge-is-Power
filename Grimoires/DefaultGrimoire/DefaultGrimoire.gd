#need to offset attack speed also
extends Node2D

var type = 0

@onready var grimoire = $Path2D/PathFollow2D/Texture

var speed : int = 75
var path_offset : float = 0.0
var path_prog : float = 0.0
var attack_speed : float = 0.25
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var projectile_emitter = $ProjectileEmitter
@onready var enemy_container = get_tree().get_root().get_node("Game").get_node("EnemiesContainer")
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var input = player.get_node("Mobile")
var attack : float = 0

var projectile_texture = preload("res://Grimoires/DefaultGrimoire/Art/DefaultGrimoireProjectile.png")

func _process(delta):
	if attack >= attack_speed:
		if input.shoot and player.mana >= 30:
			player.mana -= 30
			attack = 0
			#shoot(texture, spawn, target, multishot, spread, lifetime, speed, damage)
			projectile_emitter.shoot(projectile_texture, "PProj", grimoire.global_position - Vector2(0,28), find_nearest_enemy(), 1, 0, 1, 40000, 7)
	else:
		attack += delta
	path_prog += speed * delta
	path.progress = path_prog+path_offset

func find_nearest_enemy():
	var nearest : Vector2
	for child in enemy_container.get_children():
		if (player.position-child.position).length() < (player.position-nearest).length():
			nearest = child.position
	return nearest
