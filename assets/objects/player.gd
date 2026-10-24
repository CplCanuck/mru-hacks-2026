extends CharacterBody2D

@export var max_speed = 400.0
@export var acceleration = 2000.0
@export var friction = 1500.0

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
