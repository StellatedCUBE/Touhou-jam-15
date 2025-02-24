extends Area2D
class_name ExplodableTile

@export var size: int = 1

var cell: Vector2i
var map: TileMapLayer

func _ready() -> void:
	connect("area_entered", hit)

func hit(area: Area2D) -> void:
	if area.name == "ExplosionArea":
		var source_id: int = map.get_cell_source_id(cell)
		var tile: Vector2i = map.get_cell_tile_data(cell).get_custom_data("DestroysInto")
		for x: int in range(size):
			for y: int in range(size):
				map.set_cell(cell + Vector2i(x, y), source_id, tile)
		map = null
		TileBreakSfx.scheduled = true
		var poof: Poof = preload("res://in_game/poof.tscn").instantiate()
		get_parent().add_child(poof)
		poof.run($CollisionShape2D)
		queue_free()
