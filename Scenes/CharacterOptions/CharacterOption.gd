tool
extends Control

signal hovered_on
signal hovered_off
signal selected

export(String) var text : String setget set_text
export(Array, int) var values : Array = [0,0,0,0] setget set_values
export(Array, String) var text_values : Array = ["","","",""] setget set_text_values

onready var text_box_y_delta = rect_size.y - $MarginContainer/Button/MarginContainer/VBoxContainer/TextContainer/DescriptiveText.rect_size.y
var value_container_scene = preload("res://Scenes/CharacterOptions/ValueContainer.tscn")
	
func _display_clear_values():
	var values_container = get_node("%ValuesContainer")
	if values_container == null:
		return
	for child in values_container.get_children():
		child.queue_free()

func get_option_diff(input_values : Array) -> int:
	var absolute_diff : int = 0
	var i : int = 0
	for input_value in input_values:
		if values.size() < i + 1:
			break
		absolute_diff += abs(values[i] - input_value)
		i += 1
	return absolute_diff

func is_option_in(input_value_arrays : Array) -> bool:
	for input_values in input_value_arrays:
		if get_option_diff(input_values) == 0:
			return true
	return false

func _display_values():
	_display_clear_values()
	if values.size() == 0:
		return
	var values_container = get_node("%ValuesContainer")
	var i : int = 0
	for value in values:
		var value_container_instance = value_container_scene.instance()
		value_container_instance.value = value
		if text_values.size() >= i + 1:
			value_container_instance.text_value = text_values[i]
		values_container.add_child(value_container_instance)
		i += 1

func _display_text():
	var text_label = get_node_or_null("%DescriptiveText")
	if text_label == null:
		return
	text_label.text = text
	var text_container = get_node_or_null("%TextContainer")
	var values_background = get_node_or_null("%ValuesBackground")
	if text_container == null or values_background == null:
		return
	if text_label.text == "":
		text_container.hide()
		values_background.hide()
	else:
		text_container.show()
		values_background.show()

func set_values(new_values):
	values = new_values
	_display_values()

func set_text_values(new_values):
	text_values = new_values
	_display_values()

func set_text(new_value):
	text = new_value
	_display_text()

func _ready():
	_display_values()
	_display_text()

func _on_Button_pressed():
	emit_signal("selected")

func _on_Button_mouse_entered():
	emit_signal("hovered_on")

func _on_Button_mouse_exited():
	emit_signal("hovered_off")

func _on_DescriptiveText_resized():
	var text_label = get_node_or_null("%DescriptiveText")
	if text_label == null or text_box_y_delta == null:
		return
	rect_min_size.y = text_label.rect_size.y + text_box_y_delta
