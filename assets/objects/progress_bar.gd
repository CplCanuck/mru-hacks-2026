extends TextureProgressBar

@onready var attack_cooldown: Timer = $"../Attack Cooldown"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set max value of the progress bar to the player's attack cooldown
	max_value = $"..".attack_cooldown_value
	step = max_value/60
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	value = attack_cooldown.time_left
	pass
