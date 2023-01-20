extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var selected_420 = false
var goal_reached = false

func _option_selected(option_instance):
	._option_selected(option_instance)
	if not selected_420 and option_instance._get_option_diff([4,2,0]) == 0:
		animation_state_machine.travel("SelectionNoted")
		selected_420 = true

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true
