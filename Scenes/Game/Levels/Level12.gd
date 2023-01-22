tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered_on_goal = false
var goal_reached = false
var succeeded = false
var failures = 0

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true

func _level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true
		yield(get_tree().create_timer(12.0),"timeout")
		._level_success()

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


func _on_CharacterGoal_mouse_entered():
	pass # Replace with function body.
