extends Node

func _process(_delta: float) -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	if OS.get_name() == "Web":
		get_tree().change_scene_to_file("res://menu/main_menu_web.tscn")
	else:
		get_tree().change_scene_to_file("res://menu/main_menu_desktop.tscn")
