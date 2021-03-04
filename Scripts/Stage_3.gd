extends Node2D

signal camera_limits(left, top, right, bottom)
signal next_scene(scene)

func _ready():
	var camera_left = 0
	var camera_top = -10000
	var camera_right = 11312.198
	var camera_bottom = 380
	var next_scene = "res://Scenes/Stage_4.tscn"
	
	emit_signal("camera_limits", camera_left, camera_top, camera_right, camera_bottom)
	emit_signal("next_scene", next_scene)
	pass # Replace with function body.

func _process(delta):
	pass
