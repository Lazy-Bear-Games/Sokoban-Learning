extends Node2D

var wall_prefab = load("res://Prefabs/Wall.tscn")
var floor_prefab = load("res://Prefabs/Floor.tscn")
var crate_prefab = load("res://Prefabs/Crate.tscn")
var target_prefab = load("res://Prefabs/Target.tscn")

var current_level: String = ""
var level_data = []

signal level_completed()
signal level_reset()

func _ready():
	$Player.connect("level_reset_requested", self, "_on_Player_level_reset_requested")

func load_level(level: String):
	current_level = level
	_reset_level()

func _reset_level():
	delete_children($Walls)
	delete_children($Floors)
	delete_children($Crates)
	delete_children($Targets)
	
	if current_level == "":
		return
	
	var file = File.new()
	file.open("res://Levels/%s.sokolvl" % current_level, File.READ)
	
	var version = 0
	var row = 0
	
	while !file.eof_reached():
		var line = file.get_line()
		if line.begins_with(";"):
			var meta = line.split(': ', false, 1)
			if meta[0] == ';version':
				version = int(meta[1])
		elif line != '':
			if version != 1:
				push_error("Not supported .sokolvl version: " + str(version))
				return
			var col = 0
			
			for x in line:
				var tile_pos = Vector2(col * 32, row * 32)
				
				if x == '#':
					var wall = wall_prefab.instance()
					wall.position = tile_pos
					$Walls.add_child(wall)
				
				if x in ['.', 'X', 'O', '@', '%', 'A']:
					var flr = floor_prefab.instance()
					flr.position = tile_pos
					$Floors.add_child(flr)
				
				if x in ['@', 'A']:
					$Player.position = tile_pos
				
				if x in ['X', '%']:
					var crate = crate_prefab.instance()
					crate.position = tile_pos
					crate.connect("target_updated", self, "_on_Crate_target_updated")
					$Crates.add_child(crate)
				
				if x in ['O', '%', 'A']:
					var target = target_prefab.instance()
					target.position = tile_pos
					$Targets.add_child(target)
				
				col += 1
				
			row += 1
	file.close()

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_Crate_target_updated():
	var crates_in_place = 0
	
	for crate in $Crates.get_children():
		if crate.target_count > 0:
			crates_in_place += 1
	
	if crates_in_place == $Crates.get_child_count():
		emit_signal("level_completed")

func _on_Player_level_reset_requested():
	_reset_level()
	emit_signal("level_reset")
