extends Node2D

@export var lingers_for: int = 15

func _physics_process(_delta: float) -> void:
	if lingers_for == 0:
		queue_free()
	lingers_for -= 1
