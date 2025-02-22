extends Node2D

@onready var camera: Camera = %MainCamera

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = camera.map_pos
