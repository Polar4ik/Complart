extends TileMap

var mouse_cord := Vector2i.ZERO

var direction_map = {
	Vector2i.UP: 0,
	Vector2i.RIGHT: 1,
	Vector2i.DOWN: 2,
	Vector2i.LEFT: 3,
	0: Vector2i.UP,
	1: Vector2i.RIGHT,
	2: Vector2i.DOWN,
	3: Vector2i.LEFT,
}

func _input(event: InputEvent) -> void:	
	if not Input.is_action_just_pressed("create_tail"):
		return
	
	mouse_cord = local_to_map(get_global_mouse_position())
	if Blocks.select_block == Blocks.BlockType.SOURCE_BLOCK: create_sourse()
	elif Blocks.select_block == Blocks.BlockType.CABLE: create_cable()

func create_sourse() -> void:
	if get_cell_atlas_coords(1, mouse_cord) == Vector2i(-1,-1) and get_cell_atlas_coords(2, mouse_cord) == Vector2i(-1,-1):
		set_cell(2, mouse_cord, 0, Vector2i(1,0))
	else:
		erase_cell(1, mouse_cord)
		erase_cell(2, mouse_cord)

func create_cable() -> void:
	if get_cell_atlas_coords(1, mouse_cord) == Vector2i(-1,-1) and get_cell_atlas_coords(2, mouse_cord) == Vector2i(-1,-1):
		set_cell(2, mouse_cord, 0, Vector2i(2,0), Blocks.block_directional)
	else:
		erase_cell(1, mouse_cord)
		erase_cell(2, mouse_cord)

func transfer_from_bufer() -> void:
	for i in get_used_cells(2):
		set_cell(1, i, 0, get_cell_atlas_coords(2, i), get_cell_alternative_tile(2, i)) # переносим элементы с буфера на слой с элементами
	
	clear_layer(2)

func stroke() -> void:
	transfer_from_bufer()
	translate_power_disable_cable()
	translate_power_source_block()
	translate_power_enable_cable()

func translate_power_disable_cable() -> void:
	for i in get_used_cells_by_id(1,0,Vector2i(2,0)):
		for j in get_surrounding_cells(i):
			var direction = j-i
			
			if get_cell_atlas_coords(1, j) == Vector2i(3,0) and get_cell_alternative_tile(1,j) == direction_map[-direction]:
				set_cell(2, i, 0, Vector2i(3,0), get_cell_alternative_tile(1,i))



func translate_power_enable_cable() -> void:
	for i in get_used_cells_by_id(1,0,Vector2i(3,0)):
		var neighbourhood_counter := 0
		
		var neighbourhood_cells := [i+Vector2i.UP, i+Vector2i.DOWN, i+Vector2i.LEFT, i+Vector2i.RIGHT]
		
		neighbourhood_cells.erase(i+direction_map[get_cell_alternative_tile(1, i)])
		
		for j in neighbourhood_cells:
			var direction = j-i
				
			if get_cell_atlas_coords(1, j) == Vector2i(3,0) or get_cell_atlas_coords(1, j) == Vector2i(1,0):
				neighbourhood_counter += 1

		
		if neighbourhood_counter == 0:
			set_cell(2, i, 0, Vector2i(2,0), get_cell_alternative_tile(1,i))

func translate_power_source_block() -> void:
	for i in get_used_cells_by_id(1, 0, Vector2i(1,0)):
		for j in get_surrounding_cells(i):
			
			if get_cell_atlas_coords(1, j) == Vector2i(2,0):
				set_cell(2, j, 0, Vector2i(3,0), get_cell_alternative_tile(1,j))



func _on_timer_timeout() -> void:
#	print("UPDATE!")
	stroke()
