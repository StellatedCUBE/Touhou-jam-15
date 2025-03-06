extends Area2D

@export var restore: int = 2

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_node("%Behaviour").addHealth(restore)
		queue_free()
	pass # Replace with function body.
