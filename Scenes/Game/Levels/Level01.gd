extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

var hovered = false
var clicked = false
var goal_reached = false

func _option_hovered_on(option_instance):
	._option_hovered_on(option_instance)
	if not hovered:
		animation_state_machine.travel("Hovered")
		hovered = true

func _option_selected(option_instance):
	._option_selected(option_instance)
	if not clicked:
		animation_state_machine.travel("Clicked")
		clicked = true

func _goal_reached():
	._goal_reached()
	if not goal_reached:
		animation_state_machine.travel("Solved")
		goal_reached = true
