extends Marker2D
const NEEDLE = preload("res://assets/objects/needle_bullet.tscn")
#@export var shooting_type = "Rotation"
@onready var single_timer = $SingleTimer
@onready var blast_timer = $BlastTimer
var shooting_type

func _ready():
	shooting_type = randi_range(0,1)

func _physics_process(delta):
	match shooting_type:
		0: #"Rotation":
			rotation += 1 * delta
		_:
			pass
	pass

func turn_on_shooter():
	match shooting_type:
		0: #"Rotation mode"
			print("Turning on single shooter")
			single_timer.start()
		1: #"Blast mode"
			print("Turning on blast shooter")
			blast_timer.start()
		_:
			pass
	pass

# single
func _on_single_timer_timeout():
	print("Single timer timeout")
	var new_needle = NEEDLE.instantiate()
	get_tree().current_scene.add_child(new_needle)
	new_needle.global_position = global_position
	new_needle.global_rotation = global_rotation - 1.57
	new_needle.particles.angle_min = rad_to_deg(new_needle.rotation) #+ 90
	new_needle.particles.angle_max = rad_to_deg(new_needle.rotation) #+ 90
	single_timer.start()
	pass

# blast
func _on_blast_timer_timeout():
	print("Blast timer timeout")
	var amount = 12
	for i in range(amount):
		var new_needle = NEEDLE.instantiate()
		get_tree().current_scene.add_child(new_needle)
		new_needle.global_position = global_position
		new_needle.rotation = deg_to_rad((i/float(amount)) * 360.0)
		new_needle.particles.angle_min = rad_to_deg(new_needle.rotation)#+ 90
		new_needle.particles.angle_max = rad_to_deg(new_needle.rotation)#+ 90
	blast_timer.start()
	pass 
