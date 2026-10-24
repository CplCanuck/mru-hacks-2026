extends CharacterBody2D

@export var max_speed := 400.0
@export var acceleration := 2000.0
@export var friction := 1500.0
@export var attack_cooldown_value := 1.0
@export var invincibility_duration := 3.0
@export var stun_duration : float = 0.75
@export var stun_knockback_force := 700.0

@onready var player_sprite: Sprite2D = $"Player Sprite"
@onready var attack_pivot: Marker2D = $"Attack Pivot"
@onready var attack_cooldown: Timer = $"Attack Cooldown"
@onready var bark_collider: CollisionShape2D = $"Attack Pivot/Attackbox/CollisionShape2D"
@onready var bark_animation: AnimatedSprite2D = $"Attack Pivot/Bark Animation"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var invincibility_timer: Timer = $"Invincibility Timer"
@onready var stun_timer: Timer = $"Stun Timer"
@onready var stun_stars: AnimatedSprite2D = $"Stun Stars"

var is_stunned : bool = false
var is_invincible : bool = false



func _process(_delta: float) -> void:
	# Change out for enemy hit once we have enemies
	if Input.is_action_just_pressed("interact"):
		handle_damage(global_position.direction_to(get_global_mouse_position()).normalized())
	
	if is_invincible:
		run_invincibility_animation()
	else:
		player_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
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
	
	if input_direction != Vector2.ZERO && is_stunned == false:
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

func handle_damage(incoming_direction) -> void:
	# don't need to handle damage if we have i frames
	if is_invincible:
		return
	
	# knock player in the opposite direction of incoming attack
	velocity = Vector2.ONE * (-(incoming_direction) * stun_knockback_force)
	
	# set invincibility
	is_invincible = true
	player_sprite.modulate = Color(1.0, 1.0, 1.0, 0.6)
	invincibility_timer.start(invincibility_duration)
	
	# set stun
	is_stunned = true
	stun_stars.visible = true
	if !stun_timer.is_stopped():
		stun_timer.stop()
	stun_timer.start(stun_duration)

func run_invincibility_animation():
	var time = Time.get_ticks_msec() # Not divided for smoother pulse
	var pulse_speed := 0.03 # Higher is faster
	var alpha_value = 0.25 * sin(time * pulse_speed) + 0.75
	player_sprite.modulate = Color(1.0, 1.0, 1.0, alpha_value)



func _handle_rest() -> void:
	if velocity.is_zero_approx():
		animation_player.play("RESET")

func _on_attack_cooldown_timeout() -> void:
	bark_collider.disabled = true
	bark_animation.visible = false
	pass # Replace with function body.

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
	player_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_stun_timer_timeout() -> void:
	is_stunned = false
	stun_stars.visible = false
