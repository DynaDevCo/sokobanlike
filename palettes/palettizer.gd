@tool
extends Node

@export var palette: Texture2D:
	set(new_p):
		palette = new_p
		preload("res://palettes/palette_material.tres").set_shader_parameter("Palette",new_p)

func _ready() -> void:
	randomize()
	var path = "res://palettes/palettes/"
	var files = DirAccess.get_files_at(path)
	palette = load(path+files[2*randi_range(0,files.size()/2-1)])
