extends KinematicBody2D

# warning-ignore:unused_signal
signal swap_side(side)
signal end_game

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
const SOUL_SCENE = preload("res://Scenes/Soul.tscn")
const storm_scene = preload("res://Scenes/Storm_rage.tscn")

var SPEED = 100
var direction = 0
var velocity = Vector2()
var dead = false
var health = 40
var damage = 20
var state_machine
var atk_cd = false
var can_atk = false
var chaser = true
var trigger = false
var sword_hitbox_side
var prev_sword_hitbox_side = "right"


onready var player = get_parent().get_parent().get_node("Player")
onready var music = get_parent().get_parent().get_node("ST")
onready var health_bar = $Health/Healthbar
onready var health_under = $Health/HealthUnder
onready var update_tween = $Health/UpdateTween

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

# warning-ignore:unused_argument
func _physics_process(delta):
	if !dead:
		chase_player()
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		_is_flipped_anim()
		_attacking()
		health_stats()
		_stage()

func _is_flipped_anim():
	if player.position < position:
		$AnimatedSprite.flip_h = true
		sword_hitbox_side = "left"
	elif player.position > position:
		$AnimatedSprite.flip_h = false
		sword_hitbox_side = "right"
	_sword_hitbox_side()

func _sword_hitbox_side():
	if sword_hitbox_side == "right" && prev_sword_hitbox_side == "left":
		$SwordRange/CollisionShape2D.position.x *= -1
	elif sword_hitbox_side == "left" && prev_sword_hitbox_side == "right":
		$SwordRange/CollisionShape2D.position.x *= -1
	prev_sword_hitbox_side = sword_hitbox_side

func _take_damage(amount):
	health -= amount
	state_machine.travel("hitted")

func _on_Dead_timeout():
	queue_free()
	var soul = SOUL_SCENE.instance()
	get_parent().get_parent().add_child(soul)
	soul.set_position(position)
	emit_signal("end_game")
	pass # Replace with function body.

func chase_player():
	if chaser:
		if player.position.x > position.x:
			direction = 1
		elif player.position.x < position.x:
			direction = -1
		state_machine.travel("running")

func _attacking():
	if can_atk && !atk_cd:
		state_machine.travel("attacking")
		atk_cd = true
		$ATK_Cooldown.start()

func _on_ATK_Cooldown_timeout():
	atk_cd = false
	pass # Replace with function body.

func _on_SwordRange_body_entered(body):
	if body.get_name() == "Player":
		body.damage(damage)
	pass # Replace with function body.

func Storm_Rage():
	var screen_size = get_viewport().size
	var shot = storm_scene.instance()
	get_parent().add_child(shot)
	shot.position.x=rand_range(40,screen_size.x-40)
	trigger = false
	pass

func _stage():
	if health <= 0 && !dead:
		print("morri")
		$AnimatedSprite.speed_scale = 1
		$AnimationPlayer.playback_speed = 1
		dead = true
		state_machine.travel("dead")
		$Dead.start()

	elif health <= 15:
		if !trigger:
				$Storm_rage.start()
				trigger = true
				music.pitch_scale = 2.1

	elif health <= 25:
		$ATK_Cooldown.wait_time = 3.3
		music.pitch_scale = 1.7

	elif health <= 30:
		$AnimatedSprite.speed_scale = 1.5
		$AnimationPlayer.playback_speed = 1.5
		SPEED = 210
		damage = 25
		music.pitch_scale = 1.5

func _on_Tired_timeout():
	chaser = false
	state_machine.travel("iddle")
	direction = 0
	$Tired/Recharge.start()
	pass # Replace with function body.

func _on_Recharge_timeout():
	chaser = true
	$Tired.start()
	pass # Replace with function body.

func _on_Storm_rage_timeout():
	Storm_Rage()
	trigger = false
	pass

func _on_Attackable_Area_body_entered(body):
	if body.get_name() == "Player":
		can_atk = true
	pass 

func _on_Attackable_Area_body_exited(body):
	if body.get_name() == "Player":
		can_atk = false
	pass

func health_stats():
	health_bar.value = health
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
