extends Area2D

@export var textures : Array[Texture]
@export var grimoires : Array[PackedScene]
@onready var random = RandomNumberGenerator.new()
@onready var game = get_tree().get_root().get_node("Game")
var type : int = 2

func generate() -> void:
	type = game.weightings[random.randi_range(0,game.weightings.size()-1)]
	$Item.texture = textures[type]
	$CanvasLayer/HBoxContainer/TextureRect.texture = textures[type]

func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	$Bubble.visible = false
	$Item.visible = false
	if game.weightings.has(2): $CanvasLayer.visible = true
	game.weightings.append(type)
	if type == 0:
		$CanvasLayer/HBoxContainer/Label.text = "+50 Health"
		body.max_health += 50
		body.health += 50
	elif type == 1:
		if random.randi_range(0,1) == 0:
			$CanvasLayer/HBoxContainer/Label.text = "+100 Mana"
			body.max_mana += 100
		else:
			$CanvasLayer/HBoxContainer/Label.text = "+20 Mana Charge"
			body.mana_regen += 20
	else:
		$CanvasLayer/HBoxContainer/Label.text = "New Grimoire"
		body.add_grimoire(grimoires[type-2])
	$Timer.start()

func _on_timer_timeout() -> void:
	queue_free()
