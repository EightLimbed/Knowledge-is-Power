extends Resource

class_name Enemy

#textures
#enemy texture for each direction, need 8
@export var sprite_frames : SpriteFrames
#bullet textures
@export var projectile_texture : Texture2D

#stats
#damage per hit
@export var damage : int
#time between attacks in seconds
@export var attack_speed : int
#maximum health
@export var max_health : int
#walk speed
@export var speed : int

#projectiles
#bullets shot per attack
@export var multishot : int
#bullet spread between each shot
@export var spread : int
#bullet lifetime in seconds
@export var proj_lifetime : int
#projectile speed
@export var proj_speed : int

#behaviors
#how far pathfinding keeps enemy away from the player, in pixels
@export var hover_distance : int
#distance from player before attacking starts, in pixels
@export var attack_distance : int
#distance where enemy starts chasing, in pixels
@export var agro_distance : int

