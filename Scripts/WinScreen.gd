extends Node2D

func _ready():
	visible = false

func show():
	$AnimationPlayer.play("show")
	visible = true

func hide():
	$AnimationPlayer.play("show")
	$AnimationPlayer.seek(0, true)
	$AnimationPlayer.stop()
