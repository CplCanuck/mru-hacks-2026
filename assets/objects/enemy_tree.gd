extends Node2D
@onready var sprite := $AnimatedSprite2D
var corrupted_color := Color(0.459, 0.0, 0.69, 1.0)
var revitalized_color := Color(1.0, 1.0, 1.0, 1.0)
var player
const SOUL = preload("res://assets/objects/spirits.tscn")

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
var length_of_vine_atk = 4.0

@export var cur_type = tree_type.VINES_C
var corrupt_sprite = "needle_c"
var wither_sprite = "needle_c"
var revitalize_sprite = "needle_c"

@export var atk_cooldown_max = 3;
var atk_cooldown = atk_cooldown_max;

@export var hit_cooldown_max = 3;
var hit_cooldown = hit_cooldown_max;

func _ready():
	# start_atk()
	$Warning/VineAttack2.visible = false
	$Warning.visible = false
	var overlapping_bodies = $HitRange.get_overlapping_bodies()
	if overlapping_bodies:
		for body in overlapping_bodies:
			if body.is_in_group("Player"):
				player_in_range = true
				player = body
				break
	
	match cur_type:
		tree_type.NEEDLES_C:
			corrupt_sprite = "needle_c"
			wither_sprite = "vine_w"
			revitalize_sprite = "vine_r"
			pass
		tree_type.VINES_C:
			corrupt_sprite = "vine_c"
			wither_sprite = "needle_w"
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
		
	if current_state == states.IDLE || current_state == states.CORRUPTED:
		if atk_cooldown > 0:
			atk_cooldown -= speed * delta
		elif atk_cooldown <= 0:
			if player_in_range:
				start_atk()
	pass

func setup_cur_state():
	"""
	if current_state == states.REVITALIZED:
		sprite.play(revitalize_sprite)
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", revitalized_color, 5)
		await tween.finished
	
	elif current_state == states.IDLE && sprite.modulate != corrupted_color:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", corrupted_color, 5)
		await tween.finished
	"""
	match current_state:
		states.IDLE:
			if sprite.animation != corrupt_sprite:
				sprite.play(corrupt_sprite)
			pass
		states.REVITALIZED:
			pass
		states.DEFEATED:
			pass
		_:
			print("Invalid enemy state." + str(current_state))
			pass
	setuped_state = current_state
	return
	
func spawn_warning():
	if player:
		$Warning.visible = true
		var tween = create_tween()
		tween.tween_property($Warning, "scale", Vector2($Warning.scale.x,length_of_vine_atk), 1
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		var direction: Vector2 = player.global_position - global_position
		var player_angle: float = direction.angle() + deg_to_rad(-90)
		var target_angle
		
		var random_i = randi_range(2,5)
		for i in range(random_i):
			"""
			if i % 2 == 0:
				target_angle = deg_to_rad(randi_range(0, 180))
			else:
				target_angle = deg_to_rad(randi_range(-180, 0))
			"""
			#var ran_offset = deg_to_rad(randf_range(5,55))
			if i % 2 == 0:
				target_angle = player_angle + randf_range(0, deg_to_rad(90))
			else:
				target_angle = player_angle - randf_range(0, deg_to_rad(90))
		
			var tween1 = create_tween()
			tween1.tween_property($Warning, "global_rotation", target_angle, 0.3
				).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			await tween1.finished
			"""
			while angle_difference($Warning.global_rotation, target_angle) > 0.01:
				$Warning.global_rotation = lerp_angle($Warning.global_rotation, target_angle, 0.1)
				await get_tree().process_frame
			"""
		spawn_atk()
		pass

func start_atk():
	$Warning/VineAttack2.scale.y = 0
	atk_cooldown = atk_cooldown_max
	#print("Starting enemy attack")
	if cur_type == tree_type.VINES_C:
		spawn_warning()
	else:
		$AnimationPlayer.play("attacking")

func spawn_atk():
	match cur_type:
		tree_type.NEEDLES_C:
			$BulletSpawnPoint.turn_on_shooter()
			$BulletSpawnPoint/Duration.start()
			pass
		tree_type.VINES_C:
			#print("Growing vines")
			$Warning/VineAttack2.visible = true
			var tween_scale_up = create_tween()
			tween_scale_up.tween_property($Warning/VineAttack2, "scale", Vector2($Warning/VineAttack2.scale.x, 1), 0.15)
			await tween_scale_up.finished
			var tween_scale_down = create_tween()
			tween_scale_down.tween_property($Warning/VineAttack2, "scale", Vector2($Warning/VineAttack2.scale.x, 0), 0.1)
			await tween_scale_down.finished
			end_atk()
	#print("Spawning enemy attack")
	pass

func end_atk():
	#print("Ending atk")
	current_state = states.IDLE
	if cur_type == tree_type.VINES_C:
		#print("Ending visable")
		$Warning/VineAttack2.visible = false
		$Warning.visible = false
	pass

func _on_hit_range_body_entered(body:Node):
	if body.is_in_group("Player"):
		player_in_range = true
		player = body
		#print("Player in range")
	else:
		#print("Enemy range deteched something entering thats not the player")
		pass
	
	pass

func _on_hit_range_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
	else:
		#print("Enemy range deteched something exiting thats not the player")
		pass
	#print("Player out of range")
	pass


func _on_duration_timeout():
	$BulletSpawnPoint/SingleTimer.stop()
	$BulletSpawnPoint/BlastTimer.stop()
	pass

func _on_body_area_entered(_area: Area2D) -> void:
	if current_state == states.IDLE:
		sprite.play(wither_sprite)
		var new_soul = SOUL.instantiate()
		get_tree().current_scene.add_child(new_soul)
		if tree_type.NEEDLES_C || tree_type.VINES_R:
			new_soul.soul_type = new_soul.type.VINE
		if tree_type.VINES_C || tree_type.NEEDLES_R:
			new_soul.soul_type = new_soul.type.PINE
		new_soul.global_position = global_position 
		#sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		current_state = states.DEFEATED
	elif current_state == states.DEFEATED:
		if cur_type == tree_type.NEEDLES_C: # should be vines
			if Backpack.vine_souls > 0:
				Backpack.sub_vine_soul()
				current_state = states.REVITALIZED
		elif cur_type == tree_type.VINES_C: # should be pines
			if Backpack.pine_souls > 0:
				Backpack.sub_pine_soul()
				current_state = states.REVITALIZED
			pass
		pass
	pass
