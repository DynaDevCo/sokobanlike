@tool
extends Sprite2D

@export var inverted = false:
	set(new_val):
		inverted = new_val
		update_sprite()

var active = false


func correct() -> bool:
	return active != inverted

func update_sprite() -> void:
	region_rect = Rect2((16 if inverted else 0),0,16,16)
	if active != inverted:
		self_modulate = Color(1,0,0)
	else:
		self_modulate = Color(1,1,0)

func _on_entered(_area) -> void:
	active = true
	update_sprite()

func _on_exited(_area) -> void:
	active = false
	update_sprite()

func _ready() -> void:
	update_sprite()
