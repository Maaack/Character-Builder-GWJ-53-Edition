tool
extends Control

signal pressed

export(Texture) var image_texture : Texture setget set_image_texture
export(Texture) var default_image_texture : Texture

func set_image_texture(new_value : Texture):
	image_texture = new_value
	if image_texture != null:
		$CenterContainer/TextureButton.texture_normal = image_texture
	else:
		$CenterContainer/TextureButton.texture_normal = default_image_texture

func _on_TextureButton_pressed():
	emit_signal("pressed")
