tool
extends CenterContainer


export(int) var value : int = 0 setget set_value
export(String) var text_value : String = "" setget set_text_value

func _display_value():
	if text_value != "":
		$Panel/Label.text = text_value
	else:
		$Panel/Label.text = String(value)

func set_text_value(new_value):
	text_value = new_value
	_display_value()

func set_value(new_value):
	value = new_value
	_display_value()

func _ready():
	_display_value()
