extends Node2D

signal camera_limits(left, top, right, bottom)
signal next_scene(scene)

export var move_to = Vector2.RIGHT * 192
export var speed = 3.0

onready var platform1 = $Platforms/Platform1/AnimationPlayer
onready var platform2 = $Platforms/Platform2/AnimationPlayer
onready var platform3 = $Platforms/Platform3/AnimationPlayer


func _ready():
	var camera_left = 0
	var camera_top = -10000
	var camera_right = 7145.85
	var camera_bottom = 250
	var next_scene = "res://Scenes/Stage_3.tscn"
	
	emit_signal("camera_limits", camera_left, camera_top, camera_right, camera_bottom)
	emit_signal("next_scene", next_scene)
	platform1.play("movement")
	platform2.play("Movement")
	platform3.play("movement")
	pass # Replace with function body.
