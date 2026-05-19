extends Node2D

@export var weapon_damage: float = 1.0
@onready var animation = $AnimationPlayer

func _ready():
	animation.play("sword_slash")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		pass # ToDo : add enemies to take damage
		# body.take_damage(weapon_damage) damages enemy

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "sword_slash":
		queue_free()
