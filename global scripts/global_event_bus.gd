extends Node

func submit_push_attempt(direction:Vector2,box):
	var space = box.get_world_2d().direct_space_state
	var pp = PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	var box_dict = {}
	while box:
		box_dict[box] = true
		pp.position = box.position + 16 * direction
		if check_collision(pp,space,"wall"):
			return
		box = check_collision(pp,space,"box")
	for n in box_dict:
		n.position = n.position + 16 * direction
		if n.anti == check_collision(pp,space,"icy"):
			box_dict.erase(box)

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
		
