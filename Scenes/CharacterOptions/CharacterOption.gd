tool
extends Control

signal hovered_on
signal hovered_off
signal selected

export(String) var text : String setget set_text
export(Array, int) var values : Array = [0,0,0,0] setget set_values

var value_container_scene = preload("res://Scenes/CharacterOptions/ValueContainer.tscn")
	
func _display_clear_values():
	var values_container = get_node("%ValuesContainer")
	if values_container == null:
		return
	for child in values_container.get_children():
		child.queue_free()

func _display_values():
	_display_clear_values()
	if values.size() == 0:
		return
	var values_container = get_node("%ValuesContainer")
	for value in values:
		var value_container_instance = value_container_scene.instance()
		value_container_instance.value = value
		values_container.add_child(value_container_instance)

func _display_text():
	var text_container = get_node_or_null("%DescriptiveText")
	if text_container == null:
		return
	text_container.text = text

func set_values(new_values):
	values = new_values
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
