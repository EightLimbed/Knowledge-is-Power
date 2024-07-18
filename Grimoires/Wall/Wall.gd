#blocks bullets
extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : float
var speed : int = 100
@onready var path : PathFollow2D = $Path2D/PathFollow2D

func _process(delta):
	offset()
	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0
