extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var dungeon_generation: Node2D = $DungeonGeneration

func _ready() -> void:
	randomize()
	# Kick off the generation process
	dungeon_generation.start_generation()

func _on_dungeon_generation_generation_completed(spawn_position: Vector2) -> void:
	player.global_position = Vector2.ZERO # guaranteed walkable spot for dungeon
	
	# Force the camera to immediately snap to the player's new position 
	# without any smoothing delay catching up
	var camera = player.get_node_or_null("Camera2D")
	if camera:
		camera.reset_smoothing()
