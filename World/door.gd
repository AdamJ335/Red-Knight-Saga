extends Area2D

# Path to your dungeon scene
@export_file("*.tscn") var dungeon_scene_path: String = "res://World/dungeon.tscn"

func _on_body_entered(body: Node2D) -> void:
	print("Something hit the door: ", body.name)
	# Check if the colliding body is the player (adjust name or use groups if needed)
	if body.name == "Player" or body.is_in_group("player"):
		if dungeon_scene_path:
			get_tree().change_scene_to_file(dungeon_scene_path)
		else:
			print("[ERROR] No dungeon scene path assigned to this door!")
