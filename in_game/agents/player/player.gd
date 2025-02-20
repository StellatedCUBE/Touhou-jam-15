extends Node

@onready var agent: Agent = get_parent()
@onready var input: InputManager = get_tree().root.get_node("World/%Input")
@onready var sprite: Sprite2D = %Sprite
@onready var spin_animation: AnimatedSprite2D = %Spin
@onready var spin_collider: CollisionShape2D = %SpinCircle

@export var speed: float = 0.0625
@export var adjust: float = 0.25
@export var scale_speed: float = 0.0625
@export var miasma: int = 0

var spin_timer: int = 0

var facing: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var scale: float = agent.scale.x
	var speed_mul: float = 1
	var target_scale: float = miasma_to_scale(miasma)
	
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
	
	if input.shrink and miasma > 0.125: miasma -= 1
	if input.expand: miasma += 1
	
	if input.consume_spin():
		spin_timer = 22
		spin_animation.play()
	elif spin_timer > 0:
		spin_timer -= 1
	
	spin_animation.visible = spin_timer > 0
	spin_collider.disabled = spin_timer == 0
	
	sprite.visible = spin_timer == 0
	

func miasma_to_scale(miasma: float) -> float:
	if miasma >= 20:
		return 3
	if miasma >= 10:
		return 2
	return 1
