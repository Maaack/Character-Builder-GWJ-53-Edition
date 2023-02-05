tool
extends Control

export(PackedScene) var level_scene : PackedScene setget set_level_scene
export(Resource) var level_list : Resource

var success_screen_packed = preload("res://Scenes/SuccessScreen/SuccessScreen.tscn")
var level_number : int = 0

func _level_success():
	GameLog.level_reached(level_number + 1)
	InGameMenuController.open_menu(success_screen_packed)

func set_level_scene(value : PackedScene) -> void:
	level_scene = value
	var level_container_node = get_node_or_null("%LevelContainer")
	if level_container_node == null:
		return
	for child in level_container_node.get_children():
		child.queue_free()
	if level_scene == null:
		return
	var level_instance = level_scene.instance()
	if level_instance.has_signal("success"):
		level_instance.connect("success", self, "_level_success")
	level_container_node.add_child(level_instance)

func _ready():
	if level_scene == null:
		level_number = GameLog.get_current_level()
		if level_number >= level_list.levels.size():
			level_number = level_list.levels.size() - 1
		level_scene = level_list.levels[level_number]
	self.level_scene = level_scene
