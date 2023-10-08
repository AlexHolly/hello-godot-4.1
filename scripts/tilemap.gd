extends TileMap

# Choose parent Node
@onready var map = get_parent()

func _ready():
	var objects = get_objects("res://scenes/tile_set_walls.tscn")
	build_tilemap(self, objects, map)

# tileset_path - Path to the scene containg the nodes to be added to the map node
# returns - Dictionary NodeName -> Node
func get_objects(tileset_path: String):
	var tileset = load(tileset_path).instantiate()
	
	var rs : Dictionary = {}
	for child in tileset.get_children():
		rs[child.get_name()] = child
	
	return rs

func build_tilemap(tilemap, objects, parent=tilemap, keep_tiles=false):
	var layer_id = 0
	
	#var test_tile_position = Vector2(1, 1)
	#var test_id = tilemap.get_cell_source_id(layer_id, test_tile_position)
	
	for pos in tilemap.get_used_cells(layer_id):
		var local_coordinates = tilemap.map_to_local(pos)
		var cell_data = tilemap.get_cell_tile_data(0, pos)
		var tile_name = cell_data.get_custom_data("name")
	
		var obj_class
		var obj
		
		for key in objects:
			if tile_name == key:
				if typeof(objects[key]) == TYPE_STRING:
					obj_class = load( objects[key] )
					obj = obj_class.instance()
				else:
					obj = load( objects[key].get_scene_file_path() ).instantiate()
				
				# apply tilemap node offset
				local_coordinates += tilemap.get_position()
					
				# tile origin - cant see any difference
				# 
				#if tilemap.get_tile_origin() == tilemap.TILE_ORIGIN_TOP_LEFT:
					# apply center
				#	local_coordinates.x += tilemap.get_cell_size().x/2#obj.get_texture().get_width()/2
				#	local_coordinates.y += tilemap.get_cell_size().y/2##obj.get_texture().get_height()/2

				#elif tilemap.get_tile_origin() == tilemap.TILE_ORIGIN_CENTER:
					# apply center
				#	local_coordinates.x += tilemap.get_cell_size().x/2#obj.get_texture().get_width()/2
				#	local_coordinates.y += tilemap.get_cell_size().y/2##obj.get_texture().get_height()/2

				# flip - looks strange but is working
				#var x_flipped = tilemap.is_cell_x_flipped( pos.x,pos.y )
				#var y_flipped = tilemap.is_cell_y_flipped( pos.x,pos.y )
					
				#if tilemap.is_cell_transposed( pos.x,pos.y ):
				#	if x_flipped && !y_flipped:
				#		obj.set_rotation(deg_to_rad(-90))
				#	elif y_flipped && !x_flipped:
				#		obj.set_rotation(deg_to_rad(90))
				#	elif x_flipped && y_flipped:
				#		obj.set_rotation(deg_to_rad(90))
				#		obj.set_flip_v( y_flipped )
				#else:
				#	obj.set_flip_h( x_flipped )
				#	obj.set_flip_v( y_flipped )
				
				# y sort
				if tilemap.is_layer_y_sort_enabled(layer_id):
					obj.set_z_index( -local_coordinates.y )

				# TODO ...
				
				obj.set_position( local_coordinates )
				parent.call_deferred("add_child", obj )
				
	# removes the tileset node
	if !keep_tiles:
		if tilemap == parent:
			tilemap.clear()
		else:
			tilemap.queue_free()
	else:
		tilemap.hide()
