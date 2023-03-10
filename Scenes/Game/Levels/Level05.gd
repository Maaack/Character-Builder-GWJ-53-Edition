tool
extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered_on_charisma = false
var hovered_on_goal = false
var goal_reached = false
var succeeded = false

func _option_hovered_on(option_instance):
	._option_hovered_on(option_instance)
	if not hovered_on_charisma and option_instance.is_option_in([[0,0,0,1],[0,0,0,2],[0,0,0,3]]):
		animation_state_machine.travel("HoveredOnCharisma")
		hovered_on_charisma = true

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true

func _post_level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true

func _goal_hovered():
	if not hovered_on_goal and not goal_reached:
		animation_state_machine.travel("HoveredOnGoal")
		hovered_on_goal = true
