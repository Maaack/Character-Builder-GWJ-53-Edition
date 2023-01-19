extends RichTextLabel


export(float) var char_wait_time = 0.5
var line_buffer : String

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

func add_assistant_text(value : String):
	advance_assistant_text()
	bbcode_text += "\n[b]Assistant :[/b] "
	line_buffer = value
	_write_out_line()

func advance_assistant_text():
	if not _line_buffer_empty():
		# finish the text
		bbcode_text += line_buffer
		_stop_writing_assistant_text()

func add_player_text(value : String):
	advance_assistant_text()
	bbcode_text += "\n[b]Creator :[/b] "
	bbcode_text += value
