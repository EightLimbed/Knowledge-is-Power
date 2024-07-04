extends Node2D

var random = RandomNumberGenerator.new()
@export var ground = []
@export var walls = []
@export var room_centers = []

#uses rooms and pathways to create dungeon
func design_dungeon(coordinates: Vector2, room_count, branch_rarity):
	ground = []
	walls = []
	room_centers = []
	position = coordinates
	design_room()
	for i in room_count-1:
		design_path()
		design_room()
		if random.randi_range(0,branch_rarity-1) == 0:
			position = room_centers[random.randi_range(1,room_centers.size()-2)]
	position = coordinates
	#queue_redraw()

#temporary testing to show dungeon layout, maybe will use same thng for minimap
func _draw():
	#draw_polyline(ground, Color.GREEN, 1, false)
	pass

#creates rooms
func design_room():
	var size = Vector2i(0,0)
	#starts at center
	var center = position
	room_centers.append(center)
	#dimensions of rooms
	size.x = random.randi_range(32,38)
	size.y = random.randi_range(32,28)

	#adds coordinates of room walls
	for x in size.x:
		for y in size.y:
			position = Vector2(center.x+x-size.x/2, center.y+y-size.y/2)
			walls.append(position)
	#adds coordinates of room floor, and removes room walls
	for x in size.x-2:
		for y in size.y-2:
			position = Vector2(center.x+x-size.x/2+1, center.y+y-size.y/2+1)
			ground.append(position)
	position = center
	#adds points of interest at center, for example chests, or enemies
	#dungeon generator can get these, and add said scenes


#creates pathways beetween rooms
func design_path():
	var direction = Vector2(0,0)
	#Vector2 will be made from these to move in a set direction
	var directions = [-1,1]

	#thickness of path
	var path_thickness = 4
	var path_length = 40
	#build Vector 2 from direction
	direction.x = directions[random.randi_range(0,1)]
	direction.y = directions[random.randi_range(0,1)]

	#rebuilds direction until the path does not intersect with another room
	while (ground.has(path_length*direction+position) or walls.has(path_length*direction+position)):
		position = room_centers[random.randi_range(0,room_centers.size()-2)]
		direction.x = directions[random.randi_range(0,1)]
		direction.y = directions[random.randi_range(0,1)]

	#adds all coordinates of pathway floor and walls
	for a in path_length:
		position += direction
		ground.append(position)
		#adds all coordinates of pathway walls
		walls.append(position-Vector2(0,path_thickness))
		walls.append(position+Vector2(0,path_thickness))
		walls.append(position-Vector2(path_thickness,0))
		walls.append(position+Vector2(path_thickness,0))
		for i in path_thickness:
			ground.append(position-Vector2(0,i))
			ground.append(position+Vector2(0,i))
			ground.append(position-Vector2(i,0))
			ground.append(position+Vector2(i,0))
