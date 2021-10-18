extends KinematicBody2D


func push(offset: Vector2) -> bool:
	$RayCast.cast_to = offset
	$RayCast.force_raycast_update()
	
	if $RayCast.is_colliding():
		return false
	
	
	$Tween.interpolate_property(
			self,
			"position",
			self.position,
			self.position + offset,
			0.05,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
	$Tween.start()
	
	return true
