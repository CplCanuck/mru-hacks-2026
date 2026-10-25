extends Label

@onready var enemy_tree: Node2D = $"../EnemyTree"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = str(enemy_tree.current_state)
	pass
