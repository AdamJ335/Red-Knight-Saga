extends CharacterBody2D

var movement_speed = 60.0

@export var slash_time = 1
@export var weapon_damage = 1

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var sword_slash_preload = preload("res://Player/Attack/sword_slash.tscn")
@onready var sword_timer = get_node("%SwordTimer")
@onready var sword_attack_timer = get_node("%SwordAttackTimer")

# Sword attack
var sword_ammo = 1
var sword_baseammo = 2
var flip_sword_attack: bool = false

func _ready():
	attack()

func _physics_process(delta: float) -> void:
	movement()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var mov = Vector2(x_mov,y_mov)
	if mov != Vector2.ZERO:
		if mov.x < 0:
			sprite.flip_h = true
			flip_sword_attack = true
		if mov.x > 0:
			sprite.flip_h = false
			flip_sword_attack = false
		
		velocity = mov.normalized()*movement_speed
		move_and_slide()
		animation_player.play("player_walk")
	else:
		animation_player.stop()

func attack():
	if sword_timer.is_stopped():
		sword_timer.start()

func _on_sword_attack_timer_timeout() -> void:
	if sword_ammo > 0:
		var attack_offset = Vector2(85,0)
		var sword_slash_var = sword_slash_preload.instantiate()
		sword_slash_var.global_position = global_position
		if flip_sword_attack: 
			sword_slash_var.global_position.x -= attack_offset.x
		# sword_slash_var.get_node("Sprite/AnimationPlayer").speed_scale \
		#	= sword_slash_var.get_node("Sprite/AnimationPlayer").get_animation("sword_slash").length / slash_time
		sword_slash_var.get_node("Sprite2D").flip_h = flip_sword_attack
		# sword_slash_var.weapon_damage = weapon_damage
		get_parent().add_child(sword_slash_var)
		sword_ammo -= 1
	if sword_ammo > 0:
		sword_attack_timer.start()
	else:
		sword_attack_timer.stop()
		

func _on_sword_timer_timeout() -> void:
	sword_ammo += sword_baseammo
	sword_attack_timer.start()
