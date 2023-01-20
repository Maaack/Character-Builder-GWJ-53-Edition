extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var goal_reached = false

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true
