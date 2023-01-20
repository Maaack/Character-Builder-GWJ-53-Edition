tool
extends Control
class_name BaseLevel

signal success

export(Array, Resource) var available_options : Array = [] setget set_available_options
export(Resource) var character_goal : Resource setget set_character_goal

var character_option_scene = preload("res://Scenes/CharacterOptions/CharacterOption.tscn")
var active_value_sums : Array = []

func _display_clear_available_options():
	var available_options_container = get_node_or_null("%AvailableContainer")
	if available_options_container == null:
		return
	for child in available_options_container.get_container().get_children():
		child.queue_free()

func _display_available_options():
	_display_clear_available_options()
	if available_options.size() == 0:
		return
	var available_options_container = get_node_or_null("%AvailableContainer")
	if available_options_container == null:
		return
	for available_option in available_options:
		if available_option is OptionData:
			var character_option_instance = character_option_scene.instance()
			character_option_instance.values = available_option.values
			character_option_instance.text = available_option.text
			character_option_instance.text_values = available_option.text_values
			available_options_container.get_container().add_child(character_option_instance)
			character_option_instance.connect("selected", self, "_option_selected", [character_option_instance])
			character_option_instance.connect("hovered_on", self, "_option_hovered_on", [character_option_instance])
			character_option_instance.connect("hovered_off", self, "_option_hovered_off", [character_option_instance])

func _display_character_goal():
	var character_goal_node = get_node_or_null("%CharacterGoal")
	if character_goal_node == null:
		return
	if character_goal is OptionData:
		character_goal_node.text = character_goal.text
		character_goal_node.values = character_goal.values
		character_goal_node.text_values = character_goal.text_values
	

func set_available_options(new_values):
	available_options = new_values
	_display_available_options()

func set_character_goal(new_value):
	character_goal = new_value
	_display_character_goal()

func _ready():
	_display_available_options()
	_display_character_goal()

func _add_values_to_sums(values : Array):
	var i : int = 0
	for value in values:
		if active_value_sums.size() < i + 1:
			active_value_sums.append(0)
		active_value_sums[i] += value
		i += 1

func _remove_values_from_sums(values : Array):
	var i : int = 0
	for value in values:
		if active_value_sums.size() < i + 1:
			active_value_sums.append(0)
		active_value_sums[i] -= value
		i += 1

func _option_hovered_on(_option_instance):
	pass

func _option_hovered_off(_option_instance):
	pass

func _goal_reached():
	pass

func _active_options_updated():
	var diff : int = _active_goal_diff()
	if diff == 0:
		_goal_reached()

func _option_selected(option_instance):
	var available_options_container = get_node_or_null("%AvailableContainer")
	if available_options_container == null:
		return
	var active_options_container = get_node_or_null("%ActiveContainer")
	if active_options_container == null:
		return
	if option_instance.get_parent() == available_options_container.get_container():
		available_options_container.get_container().remove_child(option_instance)
		active_options_container.get_container().add_child(option_instance)
		_add_values_to_sums(option_instance.values)
	else:
		active_options_container.get_container().remove_child(option_instance)
		available_options_container.get_container().add_child(option_instance)
		_remove_values_from_sums(option_instance.values)
	_active_options_updated()

func _active_goal_diff() -> int:
	var absolute_diff : int = 0
	if character_goal is OptionData:
		var i : int = 0
		for value in character_goal.values:
			if active_value_sums.size() >= i + 1:
				absolute_diff += abs(active_value_sums[i] - value)
			else:
				absolute_diff += abs(value)
			i += 1
	return absolute_diff

func _active_equals_goal() -> bool:
	if character_goal is OptionData:
		return _active_goal_diff() == 0
	return false

func _on_SubmitButton_pressed():
	if _active_equals_goal():
		emit_signal("success")
