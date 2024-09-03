@tool
extends Sprite2D

@export var icy = false:
	set(new_val):
		icy = new_val
		update_sprite()
@export var turns = -1:
	set(new_val):
		turns = new_val
		update_sprite()

var grabbed = false


func update_sprite() -> void:
	region_rect = Rect2(16*(turns+1),(16*0)+(16 if icy else 0),16,16)

func _on_mouse_entered() -> void:
	self_modulate = Color(1,1,0)

func _on_mouse_exited() -> void:
	self_modulate = Color(1,0.5,0)
	if grabbed and not turns == 0:
		if push(Vector2.from_angle(floor((PI/4)+(get_local_mouse_position().normalized().angle()*4/TAU))*TAU/4)):
			if turns > 0: turns -= 1
	grabbed = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	if event is InputEventMouseButton:
		grabbed = event.pressed

func push(direction:Vector2) -> bool:
	var pp = PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	pp.position = position + 16 * direction
	pp.collision_mask = 1
	if get_world_2d().direct_space_state.intersect_point(pp, 1):
		return false
	pp.collision_mask = 2
	var collider = get_world_2d().direct_space_state.intersect_point(pp, 1)
	if collider: if not collider[0]["collider"].get_parent().push(direction): return false
	position += 16 * direction
	force_update_transform()
	pp.collision_mask = 4
	var inverted = true if get_world_2d().direct_space_state.intersect_point(pp, 1) else false
	if icy != inverted: push(direction)
	return true

func _process(_delta) -> void:
	if not Engine.is_editor_hint():
		visible = not Input.is_action_pressed("peek")
