extends Camera2D

@export var camera_speed_mult: float = 0.03

@onready var main_camera_2d: Camera2D = $"."
@onready var player: CharacterBody2D = $"../player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow_player(delta)

func follow_player(delta: float) -> void:
	position = position.move_toward(player.position, position.distance_to(player.position) * camera_speed_mult)
