@tool
extends Node2D
class_name Agent

@onready var map: Map = get_tree().root.get_node("World/%TileMap")

@export_category("Debug")
@export var reset_sprite_transform: bool:
	set(value):
		texture = texture

@export var texture: Texture2D:
	set(value):
		if $Sprite != null:
			$Sprite.texture = value
			$Sprite.scale = Vector2.ONE / value.get_width()
			$Sprite.position = Vector2.UP * (value.get_height() as float / value.get_width() / 2 - 0.5)
	get():
		return $Sprite.texture

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		position = round(position * 2) / 2

func collides() -> bool:
	return map.collides(self)

func move(by: Vector2) -> bool:
	position += by
	if collides():
		position -= by
		return false
	return true

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
