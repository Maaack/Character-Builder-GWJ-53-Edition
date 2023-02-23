tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered = false
var goal_reached = false
var succeeded = false
var failures = 0

func _option_hovered_on(option_instance):
	._option_hovered_on(option_instance)
	if not hovered and option_instance.is_option_in([[0,3,0],[0,2,0],[0,1,0]]):
		animation_state_machine.travel("Hovered")
		hovered = true

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true

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
	elif failures == 7:
		animation_state_machine.travel("FailureLast")
	elif failures > 3:
		if active_value_sums[1] > 4:
			animation_state_machine.travel("FailureLess")
		elif active_value_sums[1] < 4:
			animation_state_machine.travel("FailureMore")
	._post_level_failure()
