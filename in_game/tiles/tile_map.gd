extends TileMapLayer
class_name Map

var spin_breakable_tile: PackedScene = preload("res://in_game/tiles/spin_breakable_tile.tscn")

func collides(area: Agent) -> bool:
	var s: float = area.scale.x / 2 - 0.015625
	var min: Vector2i = local_to_map(to_local(area.global_position - Vector2(s, s)))
	var max: Vector2i = local_to_map(to_local(area.global_position + Vector2(s, s)))
	
	for i: int in range(min.x, max.x + 1):
		for j: int in range(min.y, max.y + 1):
			if get_cell_tile_data(Vector2i(i, j)).get_custom_data("Solid"):
				return true
	
	return false

func _ready() -> void:
	for cell: Vector2i in get_used_cells():
		var miasma_cost: int = get_cell_tile_data(cell).get_custom_data("SpinBreakMiasmaRequirement")
		if miasma_cost > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: SpinBreakableTile = spin_breakable_tile.instantiate()
			node.map = self
			node.cell = cell
			node.cutoff = miasma_cost
			get_parent().add_child.call_deferred(node)
			node.global_position = pos
