extends Node
class_name Player

@onready var agent: Agent = get_parent()
@onready var input: InputManager = get_tree().root.get_node("World/%Input")
@onready var sprite: Sprite2D = %Sprite
@onready var spin_animation: AnimatedSprite2D = %Spin
@onready var spin_collider: CollisionShape2D = %SpinCircle
@onready var cast_explosion_animation: AnimatedSprite2D = %CastExplosion

@export var speed: float = 0.0625
@export var adjust: float = 0.25
@export var scale_speed: float = 0.0625
@export var misfortune: int = 0
@export var health: int = 10
@export var explosion_cost: int = 10

var spin_timer: int = 0
var facing: Vector2 = Vector2.DOWN
var explosion: PackedScene = preload("res://in_game/agents/player/explosion/explosion.tscn")

func _physics_process(_delta: float) -> void:
	var scale: float = agent.scale.x
	var speed_mul: float = 1
	var target_scale: float = misfortune_to_scale(misfortune)
	
	if target_scale < scale:
		scale = max(target_scale, scale - scale_speed)
		agent.size(scale)
	elif target_scale > scale:
		if agent.size(min(target_scale, scale + scale_speed)):
			scale = agent.scale.x
		else:
			speed_mul = 0.5
	
	if input.left:
		agent.move_x(-speed * speed_mul, adjust * scale)
		facing = Vector2.LEFT
		
	elif input.right:
		agent.move_x(speed * speed_mul, adjust * scale)
		facing = Vector2.RIGHT
		
	elif input.up:
		agent.move_y(-speed * speed_mul, adjust * scale)
		facing = Vector2.UP
		
	elif input.down:
		agent.move_y(speed * speed_mul, adjust * scale)
		facing = Vector2.DOWN
	
	if input.shrink and misfortune > 0.125: misfortune -= 1
	if input.expand: misfortune += 1
	
	if input.consume_spin():
		if spin_timer == 0:
			spin_animation.play()
		spin_timer = 22
	elif spin_timer > 0:
		spin_timer -= 1
	
	if input.consume_explode() and misfortune >= explosion_cost:
		explode()
		
	
	spin_animation.visible = spin_timer > 0
	spin_collider.disabled = spin_timer == 0
	
	cast_explosion_animation.visible = cast_explosion_animation.is_playing()
	
	sprite.visible = spin_timer == 0 and not cast_explosion_animation.is_playing()
	

func misfortune_to_scale(misfortune: float) -> float:
	if misfortune >= 20:
		return 3
	if misfortune >= 10:
		return 2
	return 1

func explode() -> void:
	var instance: Node2D = explosion.instantiate()
	agent.get_parent().add_child(instance)
	agent.get_parent().move_child(instance, 0)
	instance.global_position = agent.global_position
	misfortune -= explosion_cost
	cast_explosion_animation.play()
