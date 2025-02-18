extends Camera2D

@export var width: float = 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var vps: Vector2 = get_viewport().size
	zoom = Vector2.ONE * (vps.x / width)
	position = Vector2(width / 2, width * vps.y / vps.x / 2)
