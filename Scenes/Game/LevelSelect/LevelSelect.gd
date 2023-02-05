tool
extends Control

export(Resource) var level_list : Resource setget set_level_list
export(String, FILE, "*.tscn") var game_scene : String

var level_number : int = 0
var level_button_scene : PackedScene = preload("res://Scenes/Game/LevelSelect/LevelButtons/LevelButton.tscn")

func _clear_level_buttons():
	var container_node = get_node_or_null("%GridContainer")
	if container_node == null:
		return
	for child in container_node.get_children():
		child.queue_free()

func _load_level_buttons():
	var container_node = get_node_or_null("%GridContainer")
	if container_node == null:
		return
	_clear_level_buttons()
	if level_list is LevelList:
		var index : int = 0
		for level_scene in level_list.levels:
			var level_button_instance = level_button_scene.instance()
			if level_number >= index:
				var level_instance = level_scene.instance()
				if level_instance.has_method("get_level_texture"):
					level_button_instance.image_texture = level_instance.get_level_texture()
				level_button_instance.connect("pressed", self, "_level_button_pressed", [index])
			container_node.add_child(level_button_instance)
			index += 1

func set_level_list(new_value : Resource):
	level_list = new_value
	_load_level_buttons()

func _level_button_pressed(index : int):
	GameLog.set_current_level(index)
	SceneLoader.load_scene(game_scene)

func _ready():
	level_number = GameLog.get_max_level_reached()
	if level_number >= level_list.levels.size():
		level_number = level_list.levels.size() - 1
	_load_level_buttons()
