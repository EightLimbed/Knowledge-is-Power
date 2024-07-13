extends AnimatedSprite2D

var random = RandomNumberGenerator.new()

func _ready():
	global_position.y -= 16
	$BloodSplatter.emitting = true
	frame = random.randi_range(0,3)

func _on_lifetime_timeout():
	queue_free()
