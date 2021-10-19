extends Node2D

func _ready():
	visible = false
	var screen = get_viewport_rect().size
	$LevelCompleteBackground.set_size(screen)
	$LevelCompleteLabel.set_size(Vector2(screen.x, 100))
	$LevelCompleteLabel.set_position(Vector2(0, screen.y / 2))
	$LevelCompleteLabel.rect_pivot_offset.x = screen.x / 2

func show():
	$AnimationPlayer.play("show")
	visible = true

func hide():
	$AnimationPlayer.play("show")
	$AnimationPlayer.seek(0, true)
	$AnimationPlayer.stop()
