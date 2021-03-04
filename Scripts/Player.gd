extends KinematicBody2D

signal health_updated(health)
signal stamina_updated(stamina)
signal souls_updated(souls)
signal interacting()
signal grounded_update(is_grounded)


const up = Vector2(0, -1)
const SLOPE_STOP = 64
const SPELL_SCENE = preload("res://Scenes/Player_Spell.tscn")

var state_machine
var velocity = Vector2()
var move_speed = 4 * 96
var gravity = 1200
var jump_velocity = -600
var is_grounded
var is_dead = false
var sword_hitbox_side = "right"
var spell_cd = false
var is_jumping = false

export (float) var max_health = 100
export (float) var max_stamina = 100

onready var health = max_health setget _set_health
onready var stamina = max_stamina setget _set_stamina
onready var souls = Globals.souls

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	

func _physics_process(delta):
	position.x = clamp(position.x, 0, 12785.946)

	if !is_dead:
		_get_input()
		velocity.y += gravity * delta
		var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
		velocity = move_and_slide_with_snap(velocity, snap,  up)
		_camera_controller()
		stamina_regen()
		_assign_animation()
		_casting_spell()
		_spell_realese()

func _camera_controller():
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_update", is_grounded)
	
func _input(event):
	if event.is_action_pressed("jump") && is_grounded :
		velocity.y = jump_velocity
		is_jumping = true
	elif event.is_action_pressed("run") && is_grounded:
		move_speed = 8 * 96
	else: 
		move_speed = 4 * 96
	if event.is_action_pressed("interact"):
		emit_signal("interacting")

func _get_input():
	var move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())

func _get_h_weight():
	if is_grounded:
		return 0.2
	else:
		 return 0.1
	pass

func _assign_animation():
	var anim = "idle"
	
	if Input.is_action_pressed("jump"):
		anim = "jump"
		is_jumping = false
	elif Input.is_action_pressed("ui_right") && !Input.is_action_pressed("run"):
		anim = "walk"
	elif Input.is_action_pressed("ui_left") && !Input.is_action_pressed("run"):
		anim = "walk"
	elif Input.is_action_pressed("run") && velocity.x != 0:
		anim="run"
	elif Input.is_action_pressed("attack"):
		anim="attack"

	sword_hitbox()
	_is_sprite_flipped()
	
	state_machine.travel(anim)
	pass

func _is_sprite_flipped():
	if Input.is_action_pressed("ui_left"):
		get_node( "Body/AnimatedSprite" ).set_flip_h( true )
	elif Input.is_action_pressed("ui_right"):
		get_node( "Body/AnimatedSprite" ).set_flip_h( false )
	pass

func sword_hitbox():
	if sword_hitbox_side == "right" && Input.is_action_pressed("ui_left"):
		$Body/AnimatedSprite/SwordHit/SwordRange.position.x *= -1
		sword_hitbox_side = "left"
	if sword_hitbox_side == "left" && Input.is_action_pressed("ui_right"):
		$Body/AnimatedSprite/SwordHit/SwordRange.position.x *= -1
		sword_hitbox_side = "right"

func damage(amount):
	if $InvulnerabilityTimer.is_stopped():
		$Body/AnimatedSprite/Invulnerability.play("hurt")
		_set_health(health - amount)
		_dead()
		$InvulnerabilityTimer.start()

func _on_InvulnerabilityTimer_timeout():
	$Body/AnimatedSprite/Invulnerability.stop()
	$Body/AnimatedSprite.visible = true
	$Body/AnimatedSprite.self_modulate = Color(1,1,1,1)
	$InvulnerabilityTimer.stop()
	pass # Replace with function body.

func _dead():
	if health <= 0 && !is_dead:
		is_dead = true
		state_machine.travel("dead")
		$CollisionShape2D.disabled = true
		souls = round(souls / 2)
		$Respawn.start()
	pass

func _on_Timer_timeout():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _fell_out_map(body):
	if body.name == "Player":
		health = 0
		_dead()
	pass # Replace with function body.

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health, value)

func _set_stamina(value):
	var prev_stamina = stamina
	stamina = clamp(value, 0, max_stamina)
	if stamina != prev_stamina:
		emit_signal("stamina_updated", stamina, value)

func stamina_regen():
	if stamina != 100:
		_set_stamina(stamina+0.05)

func stamina_cost(action):
	var cost = 0
	if action == "spell":
		cost = 90
	return cost

func _on_SwordHit_body_entered(body):
	if body.get_name().begins_with("Enemy") || body.get_name().begins_with("Boss"):
		body._take_damage(1)
	pass # Replace with function body.

func _set_souls(value):
	var prev_souls = souls
	souls += value
	if souls != prev_souls:
		emit_signal("souls_updated", souls)

func _casting_spell():
	if Input.is_action_pressed("spell") && stamina > stamina_cost("spell"):
		$Spell_Casting.start()
		state_machine.travel("spell")
		_set_stamina(stamina - stamina_cost("spell"))

func _spell_realese():
	if spell_cd:
		var spell = SPELL_SCENE.instance()
		get_parent().add_child(spell)
		spell.set_position(get_node("Position2D").get_global_position())
		spell_cd = false

func _on_Spell_Casting_timeout():
	spell_cd = true
	pass # Replace with function body.

func _on_World_camera_limits(left, top, right, bottom):
	$Camera2D.limit_left = left
	$Camera2D.limit_top = top
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom
	pass # Replace with function body.


