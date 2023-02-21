extends Control

onready var fullscreen_button = $VBoxContainer/FullscreenControl/FullscreenButton
onready var crt_mode_button = $VBoxContainer/CRTModeControl/CRTModeButton

func _update_ui():
	fullscreen_button.pressed = OS.window_fullscreen
	crt_mode_button.pressed = AppSettings.get_crt_mode_enabled()

func _ready():
	AppSettings.init_video_config()
	_update_ui()

func _on_FullscreenButton_toggled(button_pressed):
	AppSettings.set_fullscreen_enabled(button_pressed)

func _on_CRTModeButton_toggled(button_pressed):
	AppSettings.set_crt_mode_enabled(button_pressed)
