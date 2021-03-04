extends KinematicBody2D

const SPEED = 80
const FLOOR = Vector2(0, -1)
const LASER_SCENE = preload("res://Scenes/Laser.tscn")
const SOUL_SCENE = preload("res://Scenes/Soul.tscn")

var velocity = Vector2()
var dead = false
var health = 5
var in_vrange = false
var state_machine
var atk_cd = false
var is_close_enough = false

onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	if !dead:
		chase_player()
		velocity = move_and_slide(velocity, FLOOR)
		_is_flipped_anim()
		_attacking()

func _is_flipped_anim():
	if player.position < position:
		$AnimatedSprite.flip_h = false
	elif player.position > position:
		$AnimatedSprite.flip_h = true

func _take_damage(amount):
	health -= amount
	state_machine.travel("hitted")
	_is_dead()

func _is_dead():
	if health <= 0:
		dead = true
		state_machine.travel("dead")
		$Timer.start()

func _on_Timer_timeout():
	queue_free()
	var soul = SOUL_SCENE.instance()
	get_parent().get_parent().add_child(soul)
	soul.set_position(position)
	pass # Replace with function body.

func chase_player():
	if in_vrange:
		velocity = Vector2.ZERO
		if !is_close_enough:
			velocity = (player.global_position - position).normalized() * SPEED

func _on_Vision_range_body_entered(body):
	if body.get_name() == "Player":
		in_vrange = true
	pass # Replace with function body.

func _on_Vision_range_body_exited(body):
	in_vrange = false
	pass # Replace with function body.

func _attacking():
	if in_vrange && atk_cd == false:
		var laser_shot = LASER_SCENE.instance()
		var a = (player.position - global_position).angle()
		laser_shot.start(global_position, a + rand_range(-0.05, 0.05))
		get_parent().add_child(laser_shot)
		laser_shot.set_position(get_node("Position2D").get_global_position())
		atk_cd = true
		$ATK_Cooldown.start()

func _on_ATK_Cooldown_timeout():
	atk_cd = false
	pass # Replace with function body.

func _on_Proximity_Range_body_entered(body):
	if body.get_name() == "Player":
		is_close_enough = true
	pass # Replace with function body.

func _on_Proximity_Range_body_exited(body):
	if body.get_name() == "Player":
		is_close_enough = false
	pass # Replace with function body.
