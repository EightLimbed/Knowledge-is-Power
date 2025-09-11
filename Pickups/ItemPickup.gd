extends Area2D

@export var textures : Array[Texture]
@onready var random = RandomNumberGenerator.new()
var type : int = 0

func generate() -> void:
	type = random.randi_range(0,4)
	$Item.texture = textures[type]
