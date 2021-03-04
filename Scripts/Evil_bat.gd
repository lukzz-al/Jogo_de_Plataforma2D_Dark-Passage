extends KinematicBody2D


const SPEED = 80
const FLOOR = Vector2(0, -1)
const SOUL_SCENE = preload("res://Scenes/Soul.tscn")

var GRAVITY = 0
var velocity = Vector2()
var direction = 1
var dead = false
var health = 3
var damage = 20
var state_machine
var can_atk = false
var old_direction

onready var player = preload("res://Scenes/Player.tscn").instance()

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	velocity.y += GRAVITY
	turn_back()
	velocity.x = SPEED * direction
	if !dead:
		_is_flipped_anim()
	velocity = move_and_slide(velocity, FLOOR)

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
		state_machine.travel("death")
		dead = true
		direction = 0
		$Timer.start()
		$Damage/CollisionShape2D.disabled = true

func turn_back():
	if is_on_wall():
		direction *= -1

func _on_Damage_area_body_entered(body):

	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
	var soul = SOUL_SCENE.instance()
	get_parent().get_parent().add_child(soul)
	soul.set_position(position)
	pass # Replace with function body.

func _on_proximity_body_entered(body):
	if body.get_name() == "Player":
		old_direction = direction
		direction = 0
		state_machine.travel("attacking")
	pass # Replace with function body.

func _on_proximity_body_exited(body):
	if body.get_name() == "Player":
		direction = old_direction
	pass # Replace with function body.

func _on_Damage_body_entered(body):
	if body.get_name() == "Player":
		body.damage(damage)
	pass # Replace with function body.
