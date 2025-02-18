extends TileMapLayer
class_name Map

func collides(area: Agent) -> bool:
	var s: float = area.scale.x / 2 - 0.015625
	var min: Vector2i = local_to_map(to_local(area.global_position - Vector2(s, s)))
	var max: Vector2i = local_to_map(to_local(area.global_position + Vector2(s, s)))
	
	for i: int in range(min.x, max.x + 1):
		for j: int in range(min.y, max.y + 1):
			if get_cell_tile_data(Vector2i(i, j)).get_custom_data("Solid"):
				return true
	
	return false
