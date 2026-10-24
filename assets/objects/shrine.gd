extends Node2D

@export var trees : Array[Node2D] = []

@onready var interact_prompt: Control = $"Interact Prompt"

var interact_is_active = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if interact_is_active && Input.is_action_just_pressed("interact"):
		if check_my_trees():
			pass
		else:
			print("Trees still need revitalizing!")

func check_my_trees() -> bool:
	# Check if trees are revitalized from trees var
	return false


func _on_interact_area_body_entered(_body: Node2D) -> void:
	interact_is_active = true
	interact_prompt.visible = true
	pass


func _on_interact_area_body_exited(_body: Node2D) -> void:
	interact_is_active = false
	interact_prompt.visible = false
	pass # Replace with function body.
