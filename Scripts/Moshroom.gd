extends KinematicBody2D


const SPEED = 60
const FLOOR = Vector2(0, -1)
const SOUL_SCENE = preload("res://Scenes/Soul.tscn")

var GRAVITY = 10
var velocity = Vector2()
var direction = -1
var dead = false
var health = 3
var damage = 20
var state_machine
var can_atk = false

onready var player = preload("res://Scenes/Player.tscn").instance()

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	if !dead:
		velocity.y += GRAVITY
		velocity.x = SPEED * direction
		velocity = move_and_slide(velocity, FLOOR)
		_is_flipped_anim()
		turn_back()

func _is_flipped_anim():
	if direction == 1:
		$AnimatedSprite.flip_h = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true

func _take_damage(amount):
	state_machine.travel("hitted")
	health -= amount
	_is_dead()

func _is_dead():
	if health <= 0:
		GRAVITY = 11
		state_machine.travel("dead")
		dead = true
		direction = 0
		$Timer.start()
		$Area2D/CollisionShape2D.disabled = true

func turn_back():
	if is_on_wall():
		direction = direction * -1

func _on_Timer_timeout():
	queue_free()
	var soul = SOUL_SCENE.instance()
	get_parent().get_parent().add_child(soul)
	soul.set_position(position)
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player" && !dead:
		direction = direction * -1
		body.damage(damage)
	pass # Replace with function body.
