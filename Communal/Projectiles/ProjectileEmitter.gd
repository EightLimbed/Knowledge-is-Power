extends Node2D

#setup
var projectiles_main
var bullets_total : int = 0
var projectile = preload("res://Communal/Projectiles/Projectile.tscn")

func _ready():
	projectiles_main = get_tree().get_root().get_node("Game").get_node("ProjectilesContainer")

func shoot(texture, label, spawn, target, multishot, spread, lifetime, speed, damage):
	var spread_offset = deg_to_rad(spread)*(multishot-1)/2
	for i in multishot:
		#start for spread
		var instance = projectile.instantiate()
		#sets starting transfom
		instance.global_position = spawn
		#sets rotation, modified by spread
		instance.direction = spawn.angle_to_point(target) + i*deg_to_rad(spread) - spread_offset
		#sets projectile stats and texture
		instance.texture = texture
		instance.lifetime = lifetime
		instance.speed = speed
		instance.damage = damage
		instance.name = label+str(bullets_total)
		#adds child
		projectiles_main.add_child.call_deferred(instance)
		bullets_total += 1
