extends TileMapLayer
class_name Map

var spin_breakable_tile: PackedScene = preload("res://in_game/tiles/spin_breakable_tile.tscn")
var explodable_tiles: Array[PackedScene] = [
	null,
	preload("res://in_game/tiles/explodable_tile_small.tscn"),
	preload("res://in_game/tiles/explodable_tile_large.tscn")
]

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
		var misfortune_cost: int = get_cell_tile_data(cell).get_custom_data("SpinBreakMisfortuneRequirement")
		if misfortune_cost > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: SpinBreakableTile = spin_breakable_tile.instantiate()
			node.map = self
			node.cell = cell
			node.cutoff = misfortune_cost
			get_parent().add_child.call_deferred(node)
			node.global_position = pos
			
		var explodable: int = get_cell_tile_data(cell).get_custom_data("Explodable")
		if explodable > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: ExplodableTile = explodable_tiles[explodable].instantiate()
			node.map = self
			node.cell = cell
			get_parent().add_child.call_deferred(node)
			node.global_position = pos

func do_gate_check() -> void:
	for agent: Agent in %Agents.get_children():
		if agent.process_mode == Node.PROCESS_MODE_PAUSABLE and agent.required_for_gate:
			return
	
	var camera: Camera = %MainCamera
	for x: int in range(floori(camera.map_pos.x), floori(camera.map_pos.x + camera.width)):
		for y: int in range(floori(camera.map_pos.y), floori(camera.map_pos.y + camera.height)):
			var cell: Vector2i = Vector2i(x, y)
			if get_cell_tile_data(cell).get_custom_data("Gate"):
				set_cell(cell, get_cell_source_id(cell), get_cell_tile_data(cell).get_custom_data("DestroysInto"))
