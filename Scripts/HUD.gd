extends Control


func _ready():
	get_tree().get_root().connect("size_changed", self, "handle_resize")
	_handle_resize()

func _handle_resize():
	rect_size = get_viewport_rect().size
