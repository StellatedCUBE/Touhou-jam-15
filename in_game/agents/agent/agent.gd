@tool
extends Node2D
class_name Agent

@onready var map: Map = get_tree().root.get_node("World/%TileMap")

@export var texture: Texture2D:
	set(value):
		if $Sprite != null and value != null:
			$Sprite.texture = value
			$Sprite.scale = Vector2.ONE / value.get_width()
			$Sprite.position = Vector2.UP * (value.get_height() as float / value.get_width() / 2 - 0.5)
	get():
		return $Sprite.texture

@export_category("Debug")
@export var reset_sprite_transform: bool:
	set(value):
		texture = texture

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		#if get_parent() != null and get_parent().name == "World":
		#	var target: Node = get_node("../Agents")
		#	get_parent().remove_child(self)
		#	target.add_child(self)
		position = round(position * 2) / 2

func _ready() -> void:
	if not Engine.is_editor_hint() and get_parent().name != "Agents":
		print("AGENT IN WRONG COLLECTION")
		queue_free()

func collides() -> bool:
	return map.collides(self)

func move(by: Vector2) -> bool:
	position += by
	if collides():
		position -= by
		return false
	return true

func move_x(by: float, adjust: float) -> bool:
	if move(Vector2(by, 0)):
		return true
		
	var s: float = scale.x / 2
	var y: float = global_position.y + s
	if y - floor(y) <= adjust:
		return move(Vector2(by, floor(y) - y))
	
	y = global_position.y - s
	if ceil(y) - y <= adjust:
		return move(Vector2(by, ceil(y) - y))
	
	return false

func move_y(by: float, adjust: float) -> bool:
	if move(Vector2(0, by)):
		return true
		
	var s: float = scale.x / 2
	var x: float = global_position.x + s
	if x - floor(x) <= adjust:
		return move(Vector2(floor(x) - x, by))
	
	x = global_position.x - s
	if ceil(x) - x <= adjust:
		return move(Vector2(ceil(x) - x, by))
	
	return false

func size(to: float) -> bool:
	var current: float = scale.x
	scale = Vector2.ONE * to
	
	if to <= current or not collides():
		return true
	
	var shift: float = (to - current) / 2
	var cpos: Vector2 = position

	position = cpos + Vector2(shift, 0)
	if not collides():
		return true
		
	position = cpos - Vector2(shift, 0)
	if not collides():
		return true
		
	position = cpos + Vector2(0, shift)
	if not collides():
		return true
	
	position = cpos - Vector2(0, shift)
	if not collides():
		return true
	
	position = cpos + Vector2(shift, shift)
	if not collides():
		return true
		
	position = cpos - Vector2(shift, shift)
	if not collides():
		return true
		
	position = cpos + Vector2(-shift, shift)
	if not collides():
		return true
	
	position = cpos - Vector2(-shift, shift)
	if not collides():
		return true
	
	position = cpos
	scale = Vector2.ONE * current
	return false

func change_size(by: float) -> bool:
	return size(scale.x + by)
