tool
extends Control

export(String) var text : String setget set_text
export(Array, int) var values : Array = [0,0,0,0] setget set_values
export(Array, String) var text_values : Array = ["","","",""] setget set_text_values

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
	if text_container == null:
		return
	if text_label.text == "":
		text_container.hide()
	else:
		text_container.show()

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
