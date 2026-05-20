extends CharacterBody2D

var movement_speed = 60.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

# weapon slot
@onready var current_weapon = $Attack 

func _physics_process(delta: float) -> void:
	movement()
	current_weapon.attack()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var mov = Vector2(x_mov, y_mov)
	if mov != Vector2.ZERO:
		if mov.x < 0:
			sprite.flip_h = true
			current_weapon.set_facing_direction(true) # Pass direction to weapon node
		elif mov.x > 0:
			sprite.flip_h = false
			current_weapon.set_facing_direction(false)
		
		velocity = mov.normalized() * movement_speed
		move_and_slide()
		animation_player.play("player_walk")
	else:
		animation_player.stop()
