@tool
extends Sprite2D

enum modes {INACTIVE,CLICKABLE,ACTIVE}
@export var mode: modes = modes.INACTIVE:
	set(new_val):
		mode = new_val
		update_sprite()

var grabbed = false


func update_sprite() -> void:
	region_rect = Rect2(16*(mode),0,16,16)
	match mode:
		modes.INACTIVE: self_modulate = Color(1,1,0)
		modes.CLICKABLE: self_modulate = Color(1,0.5,0)
		modes.ACTIVE: self_modulate = Color(1,0,0)

func _on_mouse_entered() -> void:
	if mode == modes.CLICKABLE: self_modulate = Color(1,1,0)

func _on_mouse_exited() -> void:
	if mode == modes.CLICKABLE: self_modulate = Color(1,0.5,0)
	grabbed = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	if mode == modes.CLICKABLE and event is InputEventMouseButton:
		if not grabbed: grabbed = event.pressed
		else:
			grabbed = false
			mode = 2

#func push(direction:Vector2) -> bool:
	#var pp = PhysicsPointQueryParameters2D.new()
	#pp.collide_with_areas = true 
	#pp.position = position + 16 * direction
	#pp.collision_mask = 1
	#if get_world_2d().direct_space_state.intersect_point(pp, 1):
		#return false
	#pp.collision_mask = 2
	#var collider = get_world_2d().direct_space_state.intersect_point(pp, 1)
	#if collider: if not collider[0]["collider"].get_parent().push(direction): return false
	#position += 16 * direction
	#force_update_transform()
	#pp.collision_mask = 4
	#var inverted = true if get_world_2d().direct_space_state.intersect_point(pp, 1) else false
	#if icy != inverted: push(direction)
	#return true
