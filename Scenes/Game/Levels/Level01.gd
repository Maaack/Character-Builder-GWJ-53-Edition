tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered = false
var clicked = false
var goal_reached = false
var succeeded = false

func _option_hovered_on(option_instance):
	if not hovered:
		animation_state_machine.travel("Hovered")
		hovered = true
	._option_hovered_on(option_instance)

func _option_selected(option_instance):
	if not clicked:
		animation_state_machine.travel("Clicked")
		clicked = true
	._option_selected(option_instance)

func _goal_reached():
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true
	._goal_reached()

func _post_level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true
		yield(get_tree().create_timer(2.5),"timeout")
		._post_level_success()
