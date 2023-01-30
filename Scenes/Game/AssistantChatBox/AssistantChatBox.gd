extends RichTextLabel


export(float) var char_wait_time = 0.5
export(Color) var assistant_color : Color
export(Color) var player_color : Color
export(float) var v_scroll_margin : float = 0.0 
var line_buffer : String

onready var _v_scroll := get_v_scroll()
onready var margin := get_parent()

func _ready() -> void:
	margin.set("custom_constants/margin_right", v_scroll_margin)
	_v_scroll.connect("visibility_changed", self, "_on_scroll_bar_visibility_changed")

func _on_scroll_bar_visibility_changed() -> void:
	if _v_scroll.visible:
		margin.set("custom_constants/margin_right", 0)
	else:
		margin.set("custom_constants/margin_right", v_scroll_margin)

func _line_buffer_empty():
	return line_buffer.empty()

func _stop_writing_assistant_text():
	line_buffer = ""
	$ClickSoundsPlayer.stop()

func _write_out_line():
	$ClickSoundsPlayer.play("Typing")
	while not _line_buffer_empty():
		var char_timer = get_tree().create_timer(char_wait_time)
		yield(char_timer, "timeout")
		bbcode_text += line_buffer.substr(0, 1)
		if line_buffer.length() > 1:
			line_buffer = line_buffer.substr(1)
		else:
			_stop_writing_assistant_text()

func advance_assistant_text():
	if not _line_buffer_empty():
		# finish the text
		bbcode_text += line_buffer
		_stop_writing_assistant_text()

func add_assistant_text(value : String):
	advance_assistant_text()
	bbcode_text += "\n[color=#%s][b]Assistant:[/b][/color]\n" % assistant_color.to_html(false)
	line_buffer = value
	_write_out_line()

func add_player_text(value : String):
	advance_assistant_text()
	bbcode_text += "\n[right][color=#%s][b]Creator:[/b][/color][/right]\n" % player_color.to_html(false)
	bbcode_text += "[right]" + value + "[/right]"
