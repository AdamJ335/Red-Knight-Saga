extends Node2D

@export var door_scene = preload("res://World/door.tscn")
@onready var gaea_renderer: TilemapGaeaRenderer = $TilemapGaeaRenderer
@onready var noise_generator: NoiseGenerator = $NoiseGenerator

# Define the coordinates you mapped for dark grass in your Gaea settings
# Based on the tutorial, Source 0 / AtlasCoords (0, 0) was dark grass
const DARK_GRASS_ATLAS = Vector2i(0, 0)
const DARK_GRASS_SOURCE_ID = 0

func _ready() -> void:
	# Wait for Gaea to emit its completion signal
	noise_generator.generation_finished.connect(_on_generation_finished)

func _on_generation_finished() -> void:
	place_dungeon_door()

func place_dungeon_door() -> void:
	# Gaea tracks generated grids in the generator data. 
	# Let's get all coordinates that have tiles placed.
	var grid_cells = noise_generator.grid.get_cells(0)
	var valid_positions: Array[Vector2i] = []
	
	# Fetch the TileMap used by the renderer
	var tilemap: TileMap = gaea_renderer.tile_map
	
	for cell_coords in grid_cells:
		# Check what tile was actually placed at this coordinate on Layer 0
		var atlas_coords = tilemap.get_cell_atlas_coords(0, cell_coords)
		var source_id = tilemap.get_cell_source_id(0, cell_coords)
		
		if source_id == DARK_GRASS_SOURCE_ID and atlas_coords == DARK_GRASS_ATLAS:
			valid_positions.append(cell_coords)
			
	if valid_positions.size() > 0:
		# Pick one random dark grass cell
		var chosen_cell = valid_positions[randi() % valid_positions.size()]
		
		# Convert tile coordinates to global/local pixel position
		# tilemap.map_to_local handles centering the position on that tile
		var spawn_position = tilemap.map_to_local(chosen_cell)
		
		# Instantiate and add the door
		var door_instance = door_scene.instantiate()
		door_instance.position = spawn_position
		add_child(door_instance)
		
		print("Dungeon door spawned successfully at: ", chosen_cell)
	else:
		print("[ERROR] Could not find any valid dark grass tiles to place the door!")
