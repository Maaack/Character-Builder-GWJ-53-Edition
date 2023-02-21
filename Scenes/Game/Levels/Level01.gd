tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered = false
var clicked = false
var goal_reached = false
var succeeded = false
var failures : int = 0

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

func _post_level_failure():
	failures += 1
	if failures == 1:
		animation_state_machine.travel("Failure1")
	elif failures == 2:
		animation_state_machine.travel("Failure2")
	elif failures == 3:
		animation_state_machine.travel("Failure3")
	elif failures == 4:
		animation_state_machine.travel("Failure4")
	elif failures == 5:
		animation_state_machine.travel("Failure5")
	elif failures == 5:
		animation_state_machine.travel("Failure5")
	elif failures == 8:
		animation_state_machine.travel("Failure6")
	._post_level_failure()

func kill_game():
	get_tree().quit()
