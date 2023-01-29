tool
extends Control

export(Array, int) var values : Array = [0,0,0,0] setget set_values
export(Array, String) var text_values : Array = ["","","",""] setget set_text_values
export(Array, int) var current_sum : Array = [] setget set_current_sum

var value_container_scene = preload("res://Scenes/CharacterOptions/ValueContainer.tscn")

func _clear_container_children(container_name : String):
	var values_container = get_node_or_null(container_name)
	if values_container == null:
		return
	for child in values_container.get_children():
		child.queue_free()

func _display_array_in_container(values_array : Array, container : String, use_text_values : bool = true):
	_clear_container_children(container)
	if values_array.size() == 0:
		return
	var values_container = get_node(container)
	var i : int = 0
	for value in values_array:
		var value_container_instance = value_container_scene.instance()
		value_container_instance.value = value
		if use_text_values and text_values.size() >= i + 1:
			value_container_instance.text_value = text_values[i]
		values_container.add_child(value_container_instance)
		i += 1

func _display_current_sum():
	var sums_node = get_node_or_null("%SumsPanel")
	if sums_node == null:
		return
	if current_sum.size() == 0:
		sums_node.hide()
	else:
		sums_node.show()
	_display_array_in_container(current_sum, "%SumsContainer", false)

func _display_values():
	_display_array_in_container(values, "%ValuesContainer")

func set_values(new_values):
	values = new_values
	_display_values()

func set_text_values(new_values):
	text_values = new_values
	_display_values()

func set_current_sum(new_values):
	current_sum = new_values
	_display_current_sum()

func _ready():
	_display_values()
	_display_current_sum()
