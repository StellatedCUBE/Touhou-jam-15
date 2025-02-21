extends Area2D
class_name SpinBreakableTile

var cutoff: int
var cell: Vector2i
var map: TileMapLayer

func _ready() -> void:
	connect("area_entered", hit)

func hit(area: Area2D) -> void:
	if area.name == "SpinArea" and area.get_node("%Behaviour").misfortune >= cutoff:
		map.set_cell(cell, map.get_cell_source_id(cell), map.get_cell_tile_data(cell).get_custom_data("DestroysInto"))
		map = null
		queue_free()
