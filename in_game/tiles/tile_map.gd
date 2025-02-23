extends TileMapLayer
class_name Map

var spin_breakable_tile: PackedScene = preload("res://in_game/tiles/spin_breakable_tile.tscn")
var explodable_tiles: Array[PackedScene] = [
	null,
	preload("res://in_game/tiles/explodable_tile_small.tscn"),
	preload("res://in_game/tiles/explodable_tile_large.tscn")
]
var push_blocks: Array[PackedScene] = [
	null,
	preload("res://in_game/agents/push_block/push_block_1.tscn"),
	preload("res://in_game/agents/push_block/push_block_2.tscn"),
	preload("res://in_game/agents/push_block/push_block_3.tscn")
]
var door_tile: PackedScene = preload("res://in_game/tiles/door_tile.tscn")

var solid_agents: Array[Agent] = []

func collides(area: Agent) -> int:
	var s: float = area.scale.x / 2 - 0.015625
	var min: Vector2i = local_to_map(to_local(area.global_position - Vector2(s, s)))
	var max: Vector2i = local_to_map(to_local(area.global_position + Vector2(s, s)))
	
	for i: int in range(min.x, max.x + 1):
		for j: int in range(min.y, max.y + 1):
			if get_cell_tile_data(Vector2i(i, j)).get_custom_data("Solid") and not (area.small and get_cell_tile_data(Vector2i(i, j)).get_custom_data("AllowSmall")):
				return 1
	
	var rect: Rect2 = Rect2(area.global_position - Vector2(s, s), Vector2.ONE * (s * 2))
	
	for agent: Agent in solid_agents:
		if agent != area:
			var s2: float = agent.scale.x / 2 - 0.015625
			if Rect2(agent.global_position - Vector2(s2, s2), Vector2.ONE * (s2 * 2)).intersects(rect):
				agent.get_node("%Behaviour").pushed_by(area)
				return 2
			
	
	return 0

func _ready() -> void:
	var agents: Node = %Agents
	var overhead: TileMapLayer = $Overhead
	for cell: Vector2i in get_used_cells():
		if get_cell_tile_data(cell).get_custom_data("Overhead"):
			var ac: Vector2i = get_cell_atlas_coords(cell)
			overhead.set_cell(cell, 0, ac)
			var into: Vector2i = get_cell_tile_data(cell).get_custom_data("DestroysInto")
			if into == Vector2i.ZERO:
				into = Vector2i(0, ac.y & ~3)
			set_cell(cell, get_cell_source_id(cell), into)
			continue
			
		var misfortune_cost: int = get_cell_tile_data(cell).get_custom_data("SpinBreakMisfortuneRequirement")
		if misfortune_cost > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: SpinBreakableTile = spin_breakable_tile.instantiate()
			node.map = self
			node.cell = cell
			node.cutoff = misfortune_cost
			get_parent().add_child.call_deferred(node)
			node.global_position = pos
			continue
			
		var explodable: int = get_cell_tile_data(cell).get_custom_data("Explodable")
		if explodable > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: ExplodableTile = explodable_tiles[explodable].instantiate()
			node.map = self
			node.cell = cell
			get_parent().add_child.call_deferred(node)
			node.global_position = pos
			continue
		
		var push_block: int = get_cell_tile_data(cell).get_custom_data("PushBlock")
		if push_block > 0:
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: Agent = push_blocks[push_block].instantiate()
			agents.add_child(node)
			agents.move_child(node, 0)
			node.global_position = pos + Vector2(0.5, 0.5)
			var behind: Vector2i = get_cell_tile_data(cell).get_custom_data("DestroysInto")
			var source: int = get_cell_source_id(cell)
			set_cell(cell, source, behind)
			set_cell(cell + Vector2i.RIGHT, source, behind)
			set_cell(cell + Vector2i.DOWN, source, behind)
			set_cell(cell + Vector2i.ONE, source, behind)
			continue
		
		var destination: String = get_cell_tile_data(cell).get_custom_data("Destination")
		if destination != null and destination != "":
			var pos: Vector2 = to_global(map_to_local(cell))
			var node: DoorTile = door_tile.instantiate()
			node.destination = destination
			get_parent().add_child.call_deferred(node)
			node.global_position = pos
			continue
	
	overhead.visible = true

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
