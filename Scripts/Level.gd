extends Node2D

var wall_prefab = load("res://Prefabs/Wall.tscn")
var floor_prefab = load("res://Prefabs/Floor.tscn")
var crate_prefab = load("res://Prefabs/Crate.tscn")
var target_prefab = load("res://Prefabs/Target.tscn")

var level_data = []


func _ready():
	delete_children($Walls)
	delete_children($Floors)
	delete_children($Crates)
	delete_children($Targets)
	
	var file = File.new()
	file.open("res://Levels/1-1.sokolvl", File.READ)
	
	var row = 0
	
	while !file.eof_reached():
		var line = file.get_line()
		if !line.begins_with(";"):
			var col = 0
			
			for x in line:
				var tile_pos = Vector2(col * 32, row * 32)
				
				if x == '#':
					var wall = wall_prefab.instance()
					wall.position = tile_pos
					$Walls.add_child(wall)
				
				elif x in ['.', 'X', 'O', '@']:
					var flr = floor_prefab.instance()
					flr.position = tile_pos
					$Floors.add_child(flr)
				
				if x == '@':
					$Player.position = tile_pos
				
				elif x == 'X':
					var crate = crate_prefab.instance()
					crate.position = tile_pos
					$Crates.add_child(crate)
				
				elif x == 'O':
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
