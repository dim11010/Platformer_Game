extends actor
onready var stomp_area: Area2D = $StompArea2D
onready var anim_sprite: AnimatedSprite = $Player

export var score: = 100
export var stomp_impulse: = 1000.0

#Stomp jump in enemy
func _on_EnemyDetector_area_entered(_area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

#Player die
func _on_EnemyDetector_body_entered(_body: PhysicsBody2D) -> void:
	die()

#Player jump
func _physics_process(_delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

	update_animation(direction)  # Call the function here

#player will move left and right
func get_direction() -> Vector2: 
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0 
	)

func update_animation(direction: Vector2) -> void:
	if not is_on_floor():
		anim_sprite.play("jump")
	elif direction.x != 0:
		anim_sprite.play("run")
	elif direction.x != 0:
		anim_sprite.play("idle")
	else:
		anim_sprite.play("walk")

	# Flip the sprite based on direction
	if direction.x < 0:
		anim_sprite.flip_h = true  # Face left
	elif direction.x > 0:
		anim_sprite.flip_h = false # Face right


#calculation of player to jump
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y +=  gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

#calculation of player to have impulse jump
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity 
	out.y = -impulse
	return out


func die() -> void:
	PlayerData.deaths += 1
	queue_free()
	

	
