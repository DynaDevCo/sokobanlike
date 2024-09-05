extends Node

func submit_push_attempt(direction:Vector2,box):
	var space = box.get_world_2d().direct_space_state
	var pp = PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	var box_dict = {}
	while box:
		box_dict[box] = true
		pp.position = box.position + 16 * direction
		box = check_collision(pp,space,"box")
	for b in box_dict:
		pp.position = b.position + 16 * direction
		if check_collision(pp,space,"wall"):
			return
		push_box(b,direction)
		if b.anti == check_collision(pp,space,"icy"):
			box_dict.erase(box)

func push_box(box:Node,direction:Vector2):
	var animation_player: AnimationPlayer = box.get_node("AnimationPlayer")
	var name = {
		Vector2.UP:"move_up",
		Vector2.DOWN:"move_down",
		Vector2.LEFT:"move_left",
		Vector2.RIGHT:"move_right",
	}[direction]
	animation_player.play(name)
	await animation_player.animation_finished
	box.offset = Vector2.ZERO
	box.position = box.position + 16 * direction
	

func check_collision(pp,space,mode:String):
	if mode == "wall":
		pp.collision_mask = 1
		return true if space.intersect_point(pp, 1) else false
	if mode == "box":
		pp.collision_mask = 2
		var box_collider = space.intersect_point(pp, 1)
		if box_collider:
			return box_collider[0]["collider"].get_parent()
		return null
	if mode == "icy":
		pp.collision_mask = 4
		return true if space.intersect_point(pp, 1) else false
		
