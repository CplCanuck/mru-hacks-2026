extends CharacterBody2D

@export var max_speed = 400.0
@export var acceleration = 2000.0
@export var friction = 1500.0
@export var attack_cooldown_value = 1

@onready var attack_pivot: Marker2D = $"Attack Pivot"
@onready var attack_cooldown: Timer = $"Attack Cooldown"
@onready var bark_collider: CollisionShape2D = $"Attack Pivot/Attackbox/CollisionShape2D"
@onready var bark_animation: AnimatedSprite2D = $"Attack Pivot/Bark Animation"
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(_delta: float) -> void:
	handle_walk_animation()
	handle_attack_click()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	move_and_slide()



func handle_walk_animation():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if !velocity.is_zero_approx() && !input_direction.is_zero_approx():
		animation_player.play("waddle")

func handle_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func handle_attack_click():
	if Input.is_action_just_pressed("attack") && attack_cooldown.is_stopped():
		# start attack cooldown timer
		attack_cooldown.start(attack_cooldown_value)
		
		# set attack direction
		attack_pivot.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		
		# trigger attack animation
		bark_animation.visible = true
		bark_animation.play("bark")
		
		# trigger attack hitbox (currently turned off in timer time out)
		bark_collider.disabled = false

func _on_walk_cycle_rest() -> void:
	if velocity.is_zero_approx():
		animation_player.play("RESET")

func _on_attack_cooldown_timeout() -> void:
	bark_collider.disabled = true
	bark_animation.visible = false
	pass # Replace with function body.
