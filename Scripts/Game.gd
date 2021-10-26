extends Node2D

func _ready():
	$WinScreen.hide()
	$Level.connect("level_completed", self, "_on_Level_level_completed")
	$Level.connect("level_reset", self, "_on_Level_level_reset")
	
	$Level.load_level("1-1")

func _on_Level_level_completed():
	$WinScreen.show()

func _on_Level_level_reset():
	$WinScreen.hide()
