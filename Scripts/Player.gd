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
		$RayCast.cast_to = move_intent * GRID_SIZE
		$RayCast.force_raycast_update()
		
		if $RayCast.is_colliding():
			return
		
		$Tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + move_intent * GRID_SIZE,
			0.05,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
		$Tween.start()
