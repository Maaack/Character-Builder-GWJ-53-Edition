tool
extends Panel


export(String) var key_text : String setget set_key_text
export(String) var value_text : String setget set_value_text

func set_key_text(new_value):
	key_text = new_value
	$MarginContainer/HBoxContainer/KeyLabel.text = key_text

func set_value_text(new_value):
	value_text = String(new_value)
	$MarginContainer/HBoxContainer/ValueLabel.text = value_text
