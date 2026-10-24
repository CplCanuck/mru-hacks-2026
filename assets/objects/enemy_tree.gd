extends Node2D
@onready var sprite := $AnimatedSprite2D
var corrupted_color := Color(0.459, 0.0, 0.69, 1.0)
var revitalized_color := Color(1.0, 1.0, 1.0, 1.0)

enum tree_type {
	NEEDLES_C,
	VINES_R,
	VINES_C,
	NEEDLES_R,
}

enum states {
	CORRUPTED,
	DEFEATED,
	REVITALIZED,
	IDLE,
	ATTACKING,
	HIT
}

var current_state = states.IDLE
var setuped_state = -1
var player_in_range := false

@export var cur_type = tree_type.NEEDLES_C
var corrupt_sprite = "vine_r"
var revitalize_sprite = "vine_r"

@export var atk_cooldown_max = 3;
var atk_cooldown = atk_cooldown_max;

@export var hit_cooldown_max = 3;
var hit_cooldown = hit_cooldown_max;

func _ready():
	start_atk()
	var overlapping_bodies = $HitRange.get_overlapping_bodies()
	if overlapping_bodies:
		for body in overlapping_bodies:
			if body.is_in_group("Player"):
				player_in_range = true
				break
	
	match cur_type:
		tree_type.NEEDLES_C:
			corrupt_sprite = "needle_c"
			revitalize_sprite = "vine_r"
			pass
		tree_type.VINES_C:
			corrupt_sprite = "vine_c"
			revitalize_sprite = "needle_c"
			pass
		tree_type.VINES_R:
			print("Trees shouldn't start in revitalized state")
			pass
		tree_type.NEEDLES_R:
			print("Trees shouldn't start in revitalized state")
			pass
		_: 
			print("Invalid start state for tree")
			
	pass

func _process(delta):
	var speed = 1
	$Label.text = str(atk_cooldown)
	if setuped_state != current_state:
		await setup_cur_state()
		
	if atk_cooldown > 0:
		atk_cooldown -= speed * delta
	elif atk_cooldown <= 0:
		if player_in_range:
			start_atk()
		
	pass

func setup_cur_state():
	if current_state == states.REVITALIZED:
		sprite.play(revitalize_sprite)
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", revitalized_color, 5)
		await tween.finished
	
	elif current_state == states.IDLE && sprite.modulate != corrupted_color:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", corrupted_color, 5)
		await tween.finished
		
	match current_state:
		states.IDLE:
			if sprite.animation != corrupt_sprite:
				sprite.play(corrupt_sprite)
			pass
		states.ATTACKING:
			if sprite.animation != corrupt_sprite:
				sprite.play(corrupt_sprite)
				sprite.modulate = Color(0.0, 0.0, 1.0, 1.0)
			pass
		states.HIT:
			if sprite.animation != corrupt_sprite:
				sprite.play(corrupt_sprite)
				sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
			pass
		states.DEFEATED:
			if sprite.animation != corrupt_sprite:
				sprite.play(corrupt_sprite)
				sprite.modulate = Color(0.093, 0.014, 0.133, 1.0)
			pass
		_:
			print("Invalid enemy state.")
			pass
	setuped_state = current_state
	return
	
func start_atk():
	atk_cooldown = atk_cooldown_max
	print("Starting enemy attack")
	$AnimationPlayer.play("attacking")

func spawn_atk():
	match cur_type:
		tree_type.NEEDLES_C:
			$BulletSpawnPoint.turn_on_shooter()
			pass
		tree_type.VINES_C:
			pass
	print("Spawning enemy attack")
	pass

func end_atk():
	current_state = states.IDLE
	pass


func _on_hit_range_body_entered(body:Node):
	if body.is_in_group("Player"):
		player_in_range = true
	else:
		print("Enemy range deteched something entering thats not the player")
	print("Player in range")
	pass

func _on_hit_range_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
	else:
		print("Enemy range deteched something exiting thats not the player")
	print("Player out of range")
	pass
