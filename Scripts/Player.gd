extends KinematicBody2D

const GRID_SIZE = 32

var moves = 0

var last_move = null
var last_move_crate = null

func _unhandled_input(event):
	if $Tween.is_active():
		return
	
	var move_intent = Vector2.ZERO
	
	if event.is_action_pressed("ui_right", true):
		move_intent = Vector2.RIGHT
	elif event.is_action_pressed("ui_left", true):
		move_intent = Vector2.LEFT
	elif event.is_action_pressed("ui_up", true):
		move_intent = Vector2.UP
	elif event.is_action_pressed("ui_down", true):
		move_intent = Vector2.DOWN
	elif event.is_action_pressed("level_reload"):
		$".."._ready()
		_animate(Vector2.DOWN, false)
		_update_moves(0)
		last_move = null
		last_move_crate = null
		return
	elif event.is_action_pressed("undo_last_move"):
		if last_move != null:
			self.position -= last_move * GRID_SIZE
			if last_move_crate != null:
				last_move_crate.position -= last_move * GRID_SIZE
			_update_moves(moves - 1)
			last_move = null
			last_move_crate = null
		return
	
	if move_intent != Vector2.ZERO:
		var offset = move_intent * GRID_SIZE
		
		$RayCast.cast_to = offset
		$RayCast.force_raycast_update()
		
		if $RayCast.is_colliding():
			var collider = $RayCast.get_collider()
			if collider.is_in_group('crates'):
				if !collider.push(offset):
					_animate(move_intent, false)
					return
				
				last_move_crate = collider
			
			else:
				_animate(move_intent, false)
				return
		
		else:
			last_move_crate = null
		
		_update_moves(moves + 1)
		last_move = move_intent
		
		$Tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + offset,
			0.05,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
		$Tween.start()
		
		_animate(move_intent, true)

func _update_moves(new_moves: int):
	moves = new_moves
	$"../UI/MovesLabel".text = "Moves: " + str(moves)


func _animate(direction: Vector2, active: bool):
	if direction == Vector2.RIGHT:
		$AnimationPlayer.play("right")
	elif direction == Vector2.LEFT:
		$AnimationPlayer.play("left")
	elif direction == Vector2.UP:
		$AnimationPlayer.play("up")
	elif direction == Vector2.DOWN:
		$AnimationPlayer.play("down")
	
	if !active:
		$AnimationPlayer.seek(0.05)
