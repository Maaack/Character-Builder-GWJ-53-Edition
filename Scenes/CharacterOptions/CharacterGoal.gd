tool
extends Control

export(String) var text : String setget set_text
export(Array, int) var values : Array = [0,0,0,0] setget set_values
export(Array, String) var text_values : Array = ["","","",""] setget set_text_values
export(Array, String) var keys : Array = ["Str", "Wis", "Agi", "Cha", "Wea", "Sad"]
export(Texture) var icon : Texture setget set_icon

var value_container_scene = preload("res://Scenes/CharacterOptions/ValueContainer.tscn")
var key_value_container_scene = preload("res://Scenes/CharacterOptions/KeyValueContainer.tscn")

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
	var values_container = get_node_or_null(container)
	if values_container == null:
		return
	var i : int = 0
	for value in values_array:
		var value_container_instance = value_container_scene.instance()
		value_container_instance.value = value
		if use_text_values and text_values.size() >= i + 1:
			value_container_instance.text_value = text_values[i]
		values_container.add_child(value_container_instance)
		i += 1

func _display_key_text_in_grid(values_array : Array, text_values_array : Array, container : String):
	_clear_container_children(container)
	if values_array.size() == 0:
		return
	var values_container = get_node_or_null(container)
	if values_container == null:
		return
	var i : int = 0
	for value in values_array:
		var key_value_container_instance = key_value_container_scene.instance()
		key_value_container_instance.value_text = value
		if text_values_array.size() >= i + 1 and text_values_array[i] != "":
			key_value_container_instance.value_text = text_values_array[i]
		if keys.size() >= i + 1:
			key_value_container_instance.key_text = keys[i]
		values_container.add_child(key_value_container_instance)
		i += 1

func _display_values():
	_display_array_in_container(values, "%ValuesContainer")
	_display_key_text_in_grid(values, text_values, "%ValuesGridContainer")

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

func set_icon(new_value):
	icon = new_value
	var texture_rect = get_node_or_null("%IconTextureRect")
	if texture_rect == null:
		return
	texture_rect.texture = icon

func _ready():
	_display_values()
	_display_text()

func _on_MarginContainer_resized():
	var container = $Panel/MarginContainer
	if container == null:
		return
	rect_min_size.y = container.rect_size.y

