extends CharacterBody2D

@export var max_speed = 400.0
@export var acceleration = 2000.0
@export var friction = 1500.0

@onready var attack_pivot: Marker2D = $"Attack Pivot"

func _process(_delta: float) -> void:
	handle_attack_click()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func handle_attack_click():
	if Input.is_action_just_pressed("attack"):
		# set attack direction
		attack_pivot.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		# trigger attack animation
		pass 
	pass
