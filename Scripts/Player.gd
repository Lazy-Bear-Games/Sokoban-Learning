extends KinematicBody2D

const GRID_SIZE = 32

func _unhandled_input(event):
	if $Tween.is_active():
		return
	
	var move_intent = Vector2.ZERO
	
	if event.is_action_pressed("ui_right", true):
		move_intent = Vector2(1, 0)
	elif event.is_action_pressed("ui_left", true):
		move_intent = Vector2(-1, 0)
	elif event.is_action_pressed("ui_up", true):
		move_intent = Vector2(0, -1)
	elif event.is_action_pressed("ui_down", true):
		move_intent = Vector2(0, 1)
	
	if move_intent != Vector2.ZERO:
		var offset = move_intent * GRID_SIZE
		
		$RayCast.cast_to = offset
		$RayCast.force_raycast_update()
		
		if $RayCast.is_colliding():
			var collider = $RayCast.get_collider()
			if collider.is_in_group('crates'):
				if !collider.push(offset):
					return
			
			else:
				return
		
		$Tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + offset,
			0.05,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
		$Tween.start()
