extends Area2D
@onready var particles : CPUParticles2D = $Sprite2D/CPUParticles2D

var speed = 200 
var total_range = speed * 10
var travelled_distance = 0


func _ready():
	print("Bullet made")
	##particles.rotation = PI
	#particles.angle_min = rad_to_deg(rotation)
	#particles.angle_max = rad_to_deg(rotation)
	#particles.rotation = rotation

func _process(delta):
	pass

# moves object forword acording to the direction facing when spawned
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	travelled_distance += speed * delta
	if travelled_distance > total_range:
		queue_free()
	pass

# checks if the body collided with is player
func _on_body_entered(body):
	print(str(self) + "--- Bullet hit")
	if body.is_in_group('Player'):
		queue_free()
	else:
		queue_free()
	pass
