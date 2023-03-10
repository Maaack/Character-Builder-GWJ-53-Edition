extends CanvasLayer

var can_next : bool = false

func _next():
	if not can_next:
		return
	SceneLoader.reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $Panel/ConfirmExit.visible:
			$Panel/ConfirmExit.hide()
		elif $Panel/ConfirmMainMenu.visible:
			$Panel/ConfirmMainMenu.hide()
		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_select"):
		_next()
		get_tree().set_input_as_handled()

func _on_ConfirmMainMenu_confirmed():
	InGameMenuController.close_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_ConfirmExit_confirmed():
	get_tree().quit()

func _on_RestartButton_pressed():
	SceneLoader.reload_current_scene()

func _on_MainMenuButton_pressed():
	$Panel/ConfirmMainMenu.popup_centered()

func _on_ExitButton_pressed():
	$Panel/ConfirmExit.popup_centered()

func _ready():
	if OS.has_feature("web"):
		get_node("%ExitButton").hide()
	if GameLog.get_max_level_reached() < 2:
		$Panel/MarginContainer/NinePatchRect/MarginContainer/Control/ButtonsContainer/SelectLevelButton.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	can_next = true

func _on_NextLevelButton_pressed():
	SceneLoader.reload_current_scene()

func _on_SelectLevelButton_pressed():
	SceneLoader.load_scene("res://Scenes/Game/LevelSelect/LevelSelect.tscn")
