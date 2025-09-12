extends Area2D

@export var textures : Array[Texture]
@export var grimoires : Array[PackedScene]
@onready var random = RandomNumberGenerator.new()
var type : int = 6

func generate() -> void:
	type = random.randi_range(0,textures.size()-1)
	$Item.texture = textures[type]
	$CanvasLayer/ColorRect/HBoxContainer/TextureRect.texture = textures[type]

func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	$Bubble.visible = false
	$Item.visible = false
	$CanvasLayer.visible = true
	if type == 0 or type == 3:
		$CanvasLayer/ColorRect/HBoxContainer/Label.text = "+50 Health"
		body.max_health += 50
		body.health += 50
	elif type == 1 or type == 2 or type == 4 or type == 5:
		if random.randi_range(0,1) == 0:
			$CanvasLayer/ColorRect/HBoxContainer/Label.text = "+100 Mana"
			body.max_mana += 200
		else:
			$CanvasLayer/ColorRect/HBoxContainer/Label.text = "+10 Mana Regen"
			body.mana_regen += 20
	else:
		$CanvasLayer/ColorRect/HBoxContainer/Label.text = "New Grimoire"
		body.add_grimoire(grimoires[type-6])
	$Timer.start()

func _on_timer_timeout() -> void:
	queue_free()
