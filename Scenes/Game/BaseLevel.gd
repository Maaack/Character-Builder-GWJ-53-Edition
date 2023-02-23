tool
extends Control
class_name BaseLevel

signal success
signal failure

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
			available_options_container.get_container().add_child(character_option_instance)
			character_option_instance.values = available_option.values
			character_option_instance.text = available_option.text
			character_option_instance.text_values = available_option.text_values
			character_option_instance.connect("selected", self, "_option_selected", [character_option_instance])
			character_option_instance.connect("hovered_on", self, "_option_hovered_on", [character_option_instance])
			character_option_instance.connect("hovered_off", self, "_option_hovered_off", [character_option_instance])

func _display_character_goal():
	var character_goal_node = get_node_or_null("%CharacterGoal")
	var character_goal_sum_node = get_node_or_null("%CharacterGoalAndSum")
	if character_goal_sum_node == null or character_goal_node == null:
		return
	if character_goal is OptionData:
		character_goal_node.text = character_goal.text
		character_goal_node.values = character_goal.values
		character_goal_node.text_values = character_goal.text_values
		character_goal_sum_node.values = character_goal.values
		character_goal_sum_node.text_values = character_goal.text_values

func set_available_options(new_values):
	available_options = new_values
	_display_available_options()

func set_character_goal(new_value):
	character_goal = new_value
	_display_character_goal()

func _reset_sums():
	if character_goal is OptionData:
		var blank_array : Array = []
		blank_array.resize(character_goal.values.size())
		blank_array.fill(0)
		active_value_sums = blank_array
	_display_sums()

func _ready():
	_display_available_options()
	_display_character_goal()
	_reset_sums()
	hide_options()

func _display_sums():
	var character_goal_sum_node = get_node_or_null("%CharacterGoalAndSum")
	if character_goal_sum_node == null:
		return
	character_goal_sum_node.current_sum = active_value_sums

func _add_values_to_sums(values : Array):
	var i : int = 0
	for value in values:
		if active_value_sums.size() < i + 1:
			active_value_sums.append(0)
		active_value_sums[i] += value
		i += 1
	_display_sums()

func _remove_values_from_sums(values : Array):
	var i : int = 0
	for value in values:
		if active_value_sums.size() < i + 1:
			active_value_sums.append(0)
		active_value_sums[i] -= value
		i += 1
	_display_sums()

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
	_display_sums()

func show_options():
	var available_options_container = get_node_or_null("%AvailableContainer")
	if available_options_container == null:
		return
	available_options_container = available_options_container.get_container()
	for child in available_options_container.get_children():
		child.show()
		yield(get_tree().create_timer(0.3), "timeout")

func hide_options():
	var available_options_container = get_node_or_null("%AvailableContainer")
	if available_options_container == null:
		return
	available_options_container = available_options_container.get_container()
	for child in available_options_container.get_children():
		child.hide()

func _option_selected(option_instance):
	$ClickSFX.play()
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

func level_completed():
	emit_signal("success")

func _post_level_success():
	level_completed()

func _post_level_failure():
	emit_signal("failure")

func _level_success():
	var character_goal_sum_node = get_node_or_null("%CharacterGoalAndSum")
	if character_goal_sum_node == null:
		return
	character_goal_sum_node.flash_success()
	$SuccessSFX.play()
	_post_level_success()

func _level_failure():
	var character_goal_sum_node = get_node_or_null("%CharacterGoalAndSum")
	if character_goal_sum_node == null:
		return
	character_goal_sum_node.flash_failure()
	$FailureSFX.play()
	_post_level_failure()

func _level_success_or_failure():
	if _active_equals_goal():
		_level_success()
	else:
		_level_failure()

func _on_SubmitButton_pressed():
	_level_success_or_failure()

func send_assistant_text(message_text : String):
	var chat_container = get_node_or_null("%AssistantChatBox")
	if chat_container == null:
		return
	chat_container.add_assistant_text(message_text)

func send_player_text(message_text : String):
	var chat_container = get_node_or_null("%AssistantChatBox")
	if chat_container == null:
		return
	chat_container.add_player_text(message_text)

func send_terminal_text(message_text : String):
	var chat_container = get_node_or_null("%AssistantChatBox")
	if chat_container == null:
		return
	chat_container.add_terminal_text(message_text)

func _goal_hovered():
	pass

func _on_CharacterGoal_mouse_entered():
	_goal_hovered()

func get_level_texture():
	return $MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer3/CharacterGoal.icon

func kill_game():
	if OS.has_feature("web"):
		SceneLoader.load_scene("res://Scenes/MainMenu/MainMenu.tscn")
	else:
		get_tree().quit()
