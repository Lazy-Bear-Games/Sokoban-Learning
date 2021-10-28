extends CanvasLayer

func _ready():
	hide()

func show():
	$Container/AnimationPlayer.play("show")
	$Container.visible = true

func hide():
	$Container.visible = false
