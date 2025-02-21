extends Node2D

@export var icons: Array[Texture2D] = []
@export var max: int
@export var hp: bool = true

@onready var per: int = len(icons) - 1
@onready var player: Player = %Player/Behaviour
var sprites: Array[Sprite2D] = []

func _ready() -> void:
	for i: int in range(max / per):
		var sprite: Sprite2D = Sprite2D.new()
		sprite.position = Vector2(i * icons[0].get_width(), 0)
		add_child.call_deferred(sprite)
		sprites.append(sprite)

func _process(_delta: float) -> void:
	var value: int = get_value()
	for sprite: Sprite2D in sprites:
		sprite.texture = icons[clamp(value, 0, per)]
		value -= per

func get_value() -> int:
	if hp:
		return player.health
	else:
		return player.misfortune
