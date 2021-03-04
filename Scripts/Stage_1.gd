extends Node2D

signal camera_limits(left, top, right, bottom)

onready var tutorial = $CanvasLayer/Tutorial
onready var player = $Player
onready var hud = $CanvasLayer/HUD
onready var intro_sprite = $intro/AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():	
	var camera_left = 0
	var camera_top = -10000
	var camera_right = 13407.523
	var camera_bottom = 350
	emit_signal("camera_limits", camera_left, camera_top, camera_right, camera_bottom)
	player.is_dead = true
	pass # Replace with function body.


func _on_Timer_timeout():
	player.is_dead = false
	player.visible = true
	hud.visible = true
	tutorial.visible = true
	$intro.queue_free()
	pass # Replace with function body.


func _on_start_timeout():
	intro_sprite.play("default")
	$intro/AnimatedSprite/Timer.start()
	pass # Replace with function body.
