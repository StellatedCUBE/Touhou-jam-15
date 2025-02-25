extends Enemy

@export var spread: float = 15

func fire_at(target: Vector2) -> void:
	super.fire_at(target)
	target -= agent.global_position
	var a: float = deg_to_rad(spread)
	super.fire_at(target.rotated(a) + agent.global_position)
	super.fire_at(target.rotated(-a) + agent.global_position)
