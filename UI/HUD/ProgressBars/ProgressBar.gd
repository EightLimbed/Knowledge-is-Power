extends TextureProgressBar

func update(minimum, val, maximum):
	min_value = minimum
	max_value = maximum
	value = val
	if val <= minimum: #or val >= maximum:
		visible = false
	else:
		visible = true
