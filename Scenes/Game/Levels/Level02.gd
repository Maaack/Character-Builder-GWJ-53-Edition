extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered = false
var goal_reached = false

func _option_hovered_on(option_instance):
	._option_hovered_on(option_instance)
	if not hovered and option_instance.is_option_in([[0,3,0],[0,1,0]]):
		animation_state_machine.travel("Hovered")
		hovered = true

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true
