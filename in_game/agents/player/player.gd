extends Node
class_name Player

@onready var agent: Agent = get_parent()
@onready var input: InputManager = get_tree().root.get_node("World/%Input")
@onready var camera: Camera = get_tree().root.get_node("World/%MainCamera")
@onready var sprite: Sprite2D = %Sprite
@onready var damage_sfx: AudioStreamPlayer = %DamageSFX
@onready var expand_sfx: AudioStreamPlayer = %ExpandSFX
@onready var spin_animation: AnimatedSprite2D = %Spin
@onready var spin_collider: CollisionShape2D = %SpinCircle
@onready var spin_sfx: AudioStreamPlayer = %SpinSFX
@onready var cast_explosion_animation: AnimatedSprite2D = %CastExplosion
@onready var explosion_sfx: AudioStreamPlayer = %ExplosionSFX

@export var speed: float = 0.0625
@export var adjust: float = 0.25
@export var scale_speed: float = 0.0625
@export var misfortune: int = 0
@export var health: int = 10
@export var explosion_cost: int = 10

var spin_timer: int = 0
var facing: int = 0
var explosion: PackedScene = preload("res://in_game/agents/player/explosion/explosion.tscn")
var previous_position: Vector2

var step_anim_counter: int = 0
var last_movement: int = 8
var iframes: int = 0

var dead_sprite: Texture2D = preload("res://in_game/agents/player/dead.png")

func _physics_process(_delta: float) -> void:
	if health <= 0:
		sprite.visible = iframes % 2 == 0
		spin_animation.visible = false
		cast_explosion_animation.visible = false
		if iframes > 0:
			iframes -= 1
			if iframes == 0:
				get_tree().create_timer(0.4).timeout.connect(get_tree().root.get_node("World/%Fade").out)
				get_tree().create_timer(1).timeout.connect(get_tree().reload_current_scene)
		return
	
	var scale: float = agent.scale.x
	var speed_mul: float = 1
	var target_scale: float = misfortune_to_scale(misfortune)
	previous_position = agent.global_position
	
	if target_scale < scale:
		scale = max(target_scale, scale - scale_speed)
		agent.size(scale)
	elif target_scale > scale:
		if agent.size(min(target_scale, scale + scale_speed)):
			scale = agent.scale.x
		else:
			speed_mul = 0.5
	
	var moving: bool = false
	
	if input.left:
		moving = agent.move_x(-speed * speed_mul, adjust * scale)
		facing = 3
		
	elif input.right:
		moving = agent.move_x(speed * speed_mul, adjust * scale)
		facing = 2
		
	elif input.up:
		moving = agent.move_y(-speed * speed_mul, adjust * scale)
		facing = 1
		
	elif input.down:
		moving = agent.move_y(speed * speed_mul, adjust * scale)
		facing = 0
	
	if input.shrink and misfortune > 0.125: misfortune -= 1
	if input.expand: misfortune += 1
	
	if input.consume_spin() and spin_timer == 0:
		spin_animation.play()
		spin_sfx.play()
		spin_timer = 22
	elif spin_timer > 0:
		spin_timer -= 1
	
	if input.consume_explode() and misfortune >= explosion_cost:
		explode()
		
	
	spin_animation.visible = spin_timer > 0
	spin_collider.disabled = spin_timer == 0
	
	cast_explosion_animation.visible = cast_explosion_animation.is_playing()
	
	sprite.visible = spin_timer == 0 and not cast_explosion_animation.is_playing() and iframes % 2 == 0
	
	if moving:
		last_movement = 0
	
	var frame_y: int
	if last_movement < 3:
		frame_y = step_anim_counter / 12 % 2
		step_anim_counter += 1
		
		if agent.global_position.x < camera.map_pos.x + 0.5:
			cam_move(Vector2.LEFT)
		elif agent.global_position.y < camera.map_pos.y + 0.5:
			cam_move(Vector2.UP)
		elif agent.global_position.x > camera.map_pos.x + camera.width - 0.5:
			cam_move(Vector2.RIGHT)
		elif agent.global_position.y > camera.map_pos.y + camera.height - 0.5:
			cam_move(Vector2.DOWN)
	else:
		step_anim_counter = 0
		frame_y = 2
	
	last_movement += 1
	
	(sprite.texture as AtlasTexture).region = Rect2(16 * facing, frame_y * 24 + 1, 16, 23)
	
	if iframes > 0:
		iframes -= 1

func misfortune_to_scale(misfortune: float) -> float:
	if misfortune >= 20:
		return 3
	if misfortune >= 10:
		return 2
	return 1

func explode() -> void:
	var instance: Node2D = explosion.instantiate()
	agent.map.add_sibling(instance)
	instance.global_position = agent.global_position
	misfortune -= explosion_cost
	cast_explosion_animation.play()
	explosion_sfx.play()

func damage(by: int) -> void:
	if iframes == 0 and by > 0 and health > 0:
		health -= by
		iframes = 20
		damage_sfx.play()
		if health <= 0:
			agent.texture = dead_sprite
			get_node("/root/World/Music").stop()
			for agent: Node in get_node("/root/World/%Agents").get_children():
				var music: AudioStreamPlayer = agent.get_node("%Music")
				if music != null:
					music.stop()
			%DeathSFX.play()

func grant_misfortune() -> void:
	if misfortune < 20:
		if misfortune_to_scale(misfortune) != misfortune_to_scale(misfortune + 1):
			expand_sfx.play()
		misfortune += 1

func cam_move(by: Vector2) -> void:
	if get_node("/root/World/Music").process_mode == Node.PROCESS_MODE_ALWAYS:
		camera.transition(by)
	else:
		agent.global_position = previous_position
