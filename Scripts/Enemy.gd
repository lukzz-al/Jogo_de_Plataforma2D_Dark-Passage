extends KinematicBody2D

signal tutorial_pts

const GRAVITY = 10
const SPEED = 60
const FLOOR = Vector2(0, -1)
const SOUL_SCENE = preload("res://Scenes/Soul.tscn")

var velocity = Vector2()
var direction = 0
var dead = false
var health = 5
var in_vrange = false
var state_machine
var atk_cd = false
var can_atk = false
var damage = 20

onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	if !dead:
		chase_player()
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		_is_flipped_anim()
		
		if can_atk && atk_cd == false:
			state_machine.travel("attack")
			atk_cd = true
			$Attack_Range/ATK_CD.start()

func _is_flipped_anim():
	if direction == 1:
		$AnimatedSprite.flip_h = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true

func _take_damage(amount):
	state_machine.travel("hitted")
	health -= amount
	direction = 0
	_is_dead()

func _is_dead():
	if health <= 0:
		state_machine.travel("dead")
		dead = true
		$Timer.start()
		$Attack_Range/Attack_Range.disabled = true

func _on_Timer_timeout():
	queue_free()
	var soul = SOUL_SCENE.instance()
	get_parent().get_parent().add_child(soul)
	soul.set_position(position)
	emit_signal("tutorial_pts")
	pass # Replace with function body.

func chase_player():
	if in_vrange == true:
		if player.position.x > position.x:
			direction = 1
		elif player.position.x < position.x:
			direction = -1
		state_machine.travel("walk")

func _on_Vision_Range_body_entered(body):
	if body.get_name() == "Player":
		in_vrange = true
	pass # Replace with function body.

func _on_Vision_Range_body_exited(body):
	in_vrange = false
	pass # Replace with function body.

func _on_Attack_Range_body_entered(body):
	if body.get_name() == "Player":
		can_atk = true
	pass 

func _on_Attack_Range_body_exited(body):
	if body.get_name() == "Player":
		can_atk = false
	pass # Replace with function body.

func _on_Damage_Range_body_entered(body):
	if body.get_name() == "Player":
		body.damage(damage)
	pass # Replace with function body.

func _on_ATK_CD_timeout():
	atk_cd = false
	pass # Replace with function body.
