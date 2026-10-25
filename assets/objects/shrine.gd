extends Node2D

signal _on_shrine_success(position  : Vector2)

@export var trees : Array[Node2D] = []

@onready var interact_prompt: Control = $"Interact Prompt"
@onready var hurray_particles: CPUParticles2D = $HurrayParticles

var interact_is_active = false
var shrine_done = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if shrine_done:
		return
	
	if interact_is_active && Input.is_action_just_pressed("interact"):
		if check_my_trees():
			_on_shrine_success.emit(global_position)
			shrine_hurray()
			
			shrine_done = true
			interact_is_active = false
			interact_prompt.visible = false
			print("Shrine Success!")
		else:
			print("Trees still need revitalizing!")

func check_my_trees() -> bool:
	# Check if trees are revitalized from trees var
	for n in trees:
		if n.current_state != 3: # 3 = states.REVITALIZED
			print("tree corrupted")
			return false
	print("no trees corrupted")
	return true

func shrine_hurray():
	hurray_particles.emitting = true


func _on_interact_area_body_entered(_body: Node2D) -> void:
	if shrine_done:
		return
		
	interact_is_active = true
	interact_prompt.visible = true
	pass


func _on_interact_area_body_exited(_body: Node2D) -> void:
	interact_is_active = false
	interact_prompt.visible = false
	pass # Replace with function body.
