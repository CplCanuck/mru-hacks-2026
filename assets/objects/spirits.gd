extends CharacterBody2D

#var Backpack : Backpack
var player
var player_in_range = false
var speed = 1
var cur_direction = Vector2(0,0)
var max_distance = 160
enum type {
	VINE,
	PINE
}
@export var soul_type = type.VINE

func _ready():
	pass
	#Backpack = get_tree().current_scene.find_child("Backpack")
	#var trys = 0
	#while (!Backpack):
	#	await get_tree().process_frame
	#	#Backpack = get_tree().get_first_node_in_group("Backpack")
	#	trys += 1
	#	if trys > 10:
	#		print("Couldn't find backpact for setting up spirit")

func _physics_process(delta):
	if player and player_in_range:
		var distance = global_position.distance_to(player.global_position)
		distance = distance / max_distance # further away -> 1
		speed = 0.01/distance
		position = position.move_toward(player.position, position.distance_to(player.position) * speed)
	"""
		var wanted_direction = global_position.direction_to(player.global_position)
		if cur_direction[0] > wanted_direction[0]:
			cur_direction[0] -= 1 * delta
		if cur_direction[0] < wanted_direction[0]:
			cur_direction[0] += 1 * delta
		if cur_direction[1] > wanted_direction[1]:
			cur_direction[1] -= 1 * delta
		if cur_direction[1] < wanted_direction[1]:
			cur_direction[1] += 1 * delta
		velocity = cur_direction * speed
	"""
	pass
	
func collect():
	Backpack.add_vine_soul()
	pass

func _on_player_near_box_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		player = body
	else:
		print("Spirit range deteched something entering thats not the player")

func _on_player_near_box_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player out of range")
	else:
		print("Spirit range deteched something exiting thats not the player")
