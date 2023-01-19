extends BaseLevel

onready var animation_state_machine = $AnimationTree["parameters/playback"]

func _option_hovered_on(option_instance):
	print(animation_state_machine.get_current_node())
	animation_state_machine.travel("Hovered")
	._option_hovered_on(option_instance)

func _option_selected(option_instance):
	print(animation_state_machine.get_current_node())
	animation_state_machine.travel("AfterClick")
	._option_selected(option_instance)
	
