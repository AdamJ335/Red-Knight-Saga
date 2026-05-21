extends Node2D

@export var weapon_damage = 5
@export var base_offset: Vector2 = Vector2(85, 0)

var sword_slash_preload = preload("res://Player/Attack/sword_slash.tscn")

@onready var sword_timer = get_node("%SwordTimer")
@onready var sword_attack_timer = get_node("%SwordAttackTimer")

@onready var player = get_parent().get_parent()

var sword_ammo = 1
var sword_baseammo = 2
var flip_sword_attack: bool = false

func set_facing_direction(is_flipped: bool) -> void:
	flip_sword_attack = is_flipped

func attack():
	if sword_timer.is_stopped():
		sword_timer.start()

func _on_sword_attack_timer_timeout() -> void:
	if sword_ammo > 0:
		var sword_slash_var = sword_slash_preload.instantiate()
		
		# flip animation
		var direction = -1 if flip_sword_attack else 1
		var final_offset = Vector2(base_offset.x * direction, base_offset.y)
		
		# follow the player
		sword_slash_var.global_position = player.global_position
		if flip_sword_attack:
			sword_slash_var.global_position += final_offset
		sword_slash_var.get_node("Sprite2D").flip_h = flip_sword_attack
		
		owner.add_child(sword_slash_var)
		sword_ammo -= 1
		
	if sword_ammo > 0:
		sword_attack_timer.start()
	else:
		sword_attack_timer.stop()

func _on_sword_timer_timeout() -> void:
	sword_ammo += sword_baseammo
	sword_attack_timer.start()
