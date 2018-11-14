extends Node2D

const GEN_STEPS = 800

onready var map = get_node("TileMap")
onready var world_size = get_viewport_rect().size
onready var tile_size = map.cell_size

const player = preload("res://scenes/player.tscn")

func _ready():
	make_map()
	
	for joy_id in Input.get_connected_joypads():
		var inst_player = player.instance()
		inst_player.position = Vector2(world_size.x / 2 + (tile_size.x / 2), world_size.y / 2 + (tile_size.y / 2))
		inst_player.ctrl_nr = joy_id
		
		add_child(inst_player)
	
	#$Camera2D.make_current()
	#$Camera2D.position = Vector2(map_size.x * tile_size / 2, map_size.y * tile_size / 2)

func _process(delta):
	# For debugging
	if (Input.is_action_just_pressed("ui_up")):
		make_map()

func make_map():
	init_map()
	generate_map()
	clean_map()
	remove_dead_ends()
	
func init_map():
	for x in range(0, world_size.x / tile_size.x):
		for y in range(0, world_size.y / tile_size.y):
			map.set_cell(x, y, 0)

func generate_map():
	randomize()
	
	var pos = Vector2(world_size.x / tile_size.x / 2, world_size.y / tile_size.y / 2)
	map.set_cellv(pos, -1)
	
	var possible_dirs = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
	var possible_dir = possible_dirs[randi() % 4]
	var odds = 2
	
	for i in range(GEN_STEPS):
		if randi() % odds:
			possible_dir = possible_dirs[randi() % 4]
		
		pos += possible_dir
		pos = Vector2(clamp(pos.x, 1, (world_size.x / tile_size.x) - 2), clamp(pos.y, 1, (world_size.y / tile_size.y) - 2))

		map.set_cellv(pos, -1)

func clean_map():
	for x in range(0, world_size.x / tile_size.x):
			for y in range(0, world_size.y / tile_size.y):
				if (map.get_cell(x - 1, y) == -1 && map.get_cell(x + 1, y) == -1 && map.get_cell(x, y - 1) == -1 && map.get_cell(x, y + 1) == -1):
					map.set_cell(x, y, -1)

func remove_dead_ends():
	var count_dead_end = 1
	var found_floors = 0
	
	while (count_dead_end > 0):
		count_dead_end = 0
		
		for x in range(1, (world_size.x / tile_size.x) - 1):
			for y in range(1, (world_size.y / tile_size.y) - 1):
				found_floors = 0
				
				if (map.get_cell(x - 1, y) == -1):
					found_floors += 1
				if (map.get_cell(x + 1, y) == -1):
					found_floors += 1
				if (map.get_cell(x, y - 1) == -1):
					found_floors += 1
				if (map.get_cell(x, y + 1) == -1):
					found_floors += 1
		
				if (map.get_cell(x, y) == -1 && found_floors == 1):
					map.set_cell(x, y, 0)
					count_dead_end += 1
	