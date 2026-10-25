extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func disable_thorn():
	animated_sprite_2d.play("default")
	collision_shape_2d.disabled = true
	pass
