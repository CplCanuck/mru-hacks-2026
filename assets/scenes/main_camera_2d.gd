extends Camera2D

@export var camera_speed_mult: float = 0.05

@onready var player: CharacterBody2D = $"../player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	follow_player()

func follow_player() -> void:
	position = position.move_toward(player.position, position.distance_to(player.position) * camera_speed_mult)
