tool
extends CenterContainer


export(int) var value : int = 0

func _ready():
	$Panel/Label.text = String(value)
