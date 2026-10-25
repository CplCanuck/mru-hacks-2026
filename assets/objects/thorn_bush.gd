extends Node2D

@onready var unlock_particles: CPUParticles2D = $"Unlock Particles"
@onready var end_point: Marker2D = $"Unlock Particles/EndPoint"
@onready var rotation_point: Marker2D = $"Rotation Point"

var thorns := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thorns = rotation_point.get_children()

func disable_bush():
	for n in thorns:
		if n.has_method("disable_thorn"):
			n.disable_thorn()

func shoot_unlock_particles(pos: Vector2) -> void:
	unlock_particles.position = pos - global_position
	
	var distance: float = unlock_particles.position.distance_to(end_point.position)
	var direction: Vector2 = (end_point.position - unlock_particles.position).normalized()
	
	unlock_particles.rotation = direction.angle()
	
	var travel_time: float = 0.3 # Time to reach target (seconds)
	unlock_particles.lifetime = travel_time
	
	# Update particle velocity so it hits end_point
	var speed: float = distance / travel_time
	unlock_particles.initial_velocity_min = speed
	unlock_particles.initial_velocity_max = speed
	
	unlock_particles.emitting = true



func _on_shrine_success(pos: Vector2) -> void:
	shoot_unlock_particles(pos)
	disable_bush()
