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
