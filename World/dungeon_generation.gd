extends Node2D

# This passes a Vector2 pixel position back up to Dungeon.gd
signal generation_completed(spawn_pixel_position: Vector2)

@onready var walker_generator = $WalkerGenerator
@onready var gaea_renderer = $TilemapGaeaRenderer

func start_generation() -> void:
	walker_generator.generate()
	
func _on_walker_generator_generation_finished() -> void:
	var grid_cells = walker_generator.grid.get_cells(0)
	
	if grid_cells.size() > 0:
		var mid_index = grid_cells.size() / 2
		var spawn_tile = grid_cells[mid_index]
		
		var tilemap: TileMap = gaea_renderer.tile_map

		var local_pos = tilemap.map_to_local(spawn_tile)
		var target_global_pos = tilemap.to_global(local_pos)
		
		# Send the absolute world position up to Dungeon.gd
		generation_completed.emit(target_global_pos)
	else:
		print("[ERROR] Gaea finished, but the generated tile array was empty!")
