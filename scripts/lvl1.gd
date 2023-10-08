extends Node2D

func _ready():
	# Not working as expected when Screen management software is used (PowerToys)
	#DisplayServer.window_set_position(DisplayServer.window_get_size()/2 - DisplayServer.window_get_size()/2)
	DisplayServer.window_set_position(Vector2(100, 100))
	set_process_input(true)
	pass

func _input(event):
	var reset_game = Input.is_key_pressed(KEY_R)
	if reset_game:
		get_tree().change_scene_to_file("res://scenes/lvl1.scn")
