extends AnimatedSprite2D
class_name Poof

var age: float = 0

func run(area: CollisionShape2D) -> void:
	global_position = area.global_position
	scale = Vector2.ONE * (area.shape.size.x * area.global_scale.x / sprite_frames.get_frame_texture("default", 0).get_width())
	visible = true
	play()

func _process(delta: float) -> void:
	age += delta
	if age > sprite_frames.get_frame_count("default") / sprite_frames.get_animation_speed("default"):
		queue_free()
