tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered_on_goal = false
var goal_reached = false
var succeeded = false
var failures = 0

func _post_level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true

func _level_failure():
	failures += 1
	if failures >= 3:
		_level_success()
		return
	elif failures == 2:
		animation_state_machine.travel("Failure2")
	elif failures == 1:
		animation_state_machine.travel("Failure1")
	._level_failure()

func _level_success_or_failure():
	if _active_goal_diff() < 6:
		_level_success()
	else:
		_level_failure()


func _goal_hovered():
	if not hovered_on_goal and not goal_reached:
		animation_state_machine.travel("HoveredOnGoal")
		hovered_on_goal = true
