tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered_on_goal = false
var goal_reached = false
var succeeded = false
var failures = 0

func _level_failure():
	failures += 1
	if failures >= 3:
		animation_state_machine.travel("Success")
		succeeded = true
		yield(get_tree().create_timer(8.0),"timeout")
		._level_success()
	elif failures == 2:
		animation_state_machine.travel("Failure2")
	elif failures == 1:
		animation_state_machine.travel("Failure1")


func _on_CharacterGoal_mouse_entered():
	if not hovered_on_goal and not goal_reached:
		animation_state_machine.travel("HoveredOnGoal")
		hovered_on_goal = true
