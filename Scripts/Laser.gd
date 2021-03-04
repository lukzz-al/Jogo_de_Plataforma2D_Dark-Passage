extends Area2D

const LASER_SPEED = 600

var speed = 1000
var velocity = Vector2()
var damage = 25

onready var player = preload("res://Scenes/Player.tscn").instance()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
	
func _physics_process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass

func _on_Laser_body_entered(body):
	if body.get_name() == "Player":
		body.damage(damage)
	elif !body.get_name().begins_with("Enemy"):
		queue_free()
