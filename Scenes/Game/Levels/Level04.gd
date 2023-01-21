extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var goal_reached = false
var succeeded = false

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true

func _level_success():
	if not succeeded:
		animation_state_machine.travel("Success")
		succeeded = true
		yield(get_tree().create_timer(2.5),"timeout")
		._level_success()

