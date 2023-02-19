tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered_on_goal = false
var goal_reached = false
var succeeded = false

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true

func _post_level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true
		yield(get_tree().create_timer(2.5),"timeout")
		._post_level_success()

func _goal_hovered():
	if not hovered_on_goal and not goal_reached:
		animation_state_machine.travel("HoveredOnGoal")
		hovered_on_goal = true
