extends Control

signal pulse()

onready var health_bar = $Healthbar
onready var health_under = $HealthUnder
onready var stamina_bar = $Staminabar
onready var stamina_under = $StaminaUnder
onready var update_tween = $UpdateTween
onready var label = $Healthbar/Label
onready var count_souls = $Soul/Soul_Counter

export (Color) var healthly_color = Color.darkgreen
export (Color) var caution_color = Color.darkgoldenrod
export (Color) var danger_color = Color.darkred


export (float, 0, 1, 0.5) var caution_zone = 0.5
export (float, 0, 1, 0.5) var danger_zone = 0.2


func _on_Player_health_updated(health, amount):
	health_bar.value = health
	label.set_text("Health     " + str(health) + "/" + "100") 
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
	_assign_color(health)

func _assign_color(health):

	if health < health_bar.max_value * danger_zone:
		health_bar.tint_progress = danger_color
	elif health < health_bar.max_value * caution_zone:
		health_bar.tint_progress = caution_color
	else:
		health_bar.tint_progress = healthly_color

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
	health_under.max_value = max_health

func _on_Player_stamina_updated(stamina, amount):
	stamina_bar.value = stamina
	update_tween.interpolate_property(stamina_under, "value", stamina_under.value, stamina, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
	pass # Replace with function body.

func _on_Player_souls_updated(souls):
	count_souls.set_text("x" + str(souls))
	$SFX.play()
	pass # Replace with function body.


