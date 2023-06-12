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

enum Elements {
	SOURCE_BLOCK = 0,
	DISABLE_CABLE = 1,
	ENABLE_CABLE = 2,
	NOT_BLOCK = 3,
}

const ELEMENTS_LAYER := 1
const BUFER := 2


func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("create_tail"):
		mouse_cord = local_to_map(get_global_mouse_position())
		if get_cell_atlas_coords(ELEMENTS_LAYER, mouse_cord) == -Vector2i.ONE and get_cell_atlas_coords(BUFER, mouse_cord) == -Vector2i.ONE:
			create_block()
		else:
			delete_block()


func create_block() -> void:
#	if get_cell_atlas_coords(ELEMENTS_LAYER, mouse_cord) != -Vector2i.ONE and get_cell_atlas_coords(BUFER, mouse_cord) != -Vector2i.ONE:
#		return
	
	
	if Blocks.select_block == Blocks.BlockType.CABLE:
		set_cell(BUFER, mouse_cord, 0, Vector2i(Blocks.select_block,0),Blocks.block_directional)
	elif Blocks.select_block != Blocks.BlockType.CABLE:
		set_cell(BUFER, mouse_cord, 0, Vector2i(Blocks.select_block,0))

func delete_block() -> void:
#	if get_cell_atlas_coords(ELEMENTS_LAYER, mouse_cord) == -Vector2i.ONE and get_cell_atlas_coords(BUFER, mouse_cord) == -Vector2i.ONE:
#		return
	
	erase_cell(ELEMENTS_LAYER, mouse_cord)
	erase_cell(BUFER, mouse_cord)

func stroke() -> void:
	transfer_from_bufer()
	transfer_power_disable_cable()
	transfer_power_enable_cable()
	transfer_power_source_block()


func transfer_from_bufer() -> void:
	for i in get_used_cells(BUFER):
		set_cell(ELEMENTS_LAYER, i, 0, get_cell_atlas_coords(BUFER, i), get_cell_alternative_tile(BUFER, i)) # переносим элементы с буфера на слой с элементами
	
	clear_layer(BUFER)



func transfer_power_disable_cable() -> void:
	for i in get_used_cells_by_id(ELEMENTS_LAYER,0,Vector2i(Elements.DISABLE_CABLE,0)):
		
		var neighbourhood_counter := 0
		
		var neighbourhood_cells := [i+Vector2i.UP, i+Vector2i.DOWN, i+Vector2i.LEFT, i+Vector2i.RIGHT]
		neighbourhood_cells.erase(i+direction_map[get_cell_alternative_tile(1, i)])
		
		for j in neighbourhood_cells:
			var direction = j-i
			
			if is_powered(j):
				neighbourhood_counter += 1
			
			if is_powered(j) and is_wired(j, -direction):
				neighbourhood_counter += 1
		
		if neighbourhood_counter != 0:
			enable_cable(i)

func transfer_power_enable_cable() -> void:
	for i in get_used_cells_by_id(ELEMENTS_LAYER,0,Vector2i(Elements.ENABLE_CABLE,0)):
		var neighbourhood_counter := 0
		
		var neighbourhood_cells := [i+Vector2i.UP, i+Vector2i.DOWN, i+Vector2i.LEFT, i+Vector2i.RIGHT]
		neighbourhood_cells.erase(i+direction_map[get_cell_alternative_tile(ELEMENTS_LAYER, i)])
		
		for j in neighbourhood_cells:
			var direction = j-i
			
			if is_powered(j):
				neighbourhood_counter += 1
			
			if is_powered(j) and is_wired(j, -direction):
				neighbourhood_counter += 1
		
		
		if neighbourhood_counter == 0:
			disable_cable(i)

func transfer_power_source_block() -> void:
	for i in get_used_cells_by_id(ELEMENTS_LAYER, 0, Vector2i(0,0)):
		for j in get_surrounding_cells(i):
			
			var direction = j-i
			
			if get_cell_atlas_coords(ELEMENTS_LAYER, j) == Vector2i(1,0) and is_wired(j, direction):
				enable_cable(j)


func is_powered(cord: Vector2i) -> bool:
	const source_block := Vector2i(Elements.SOURCE_BLOCK,0)
	const enable_cable_block := Vector2i(Elements.ENABLE_CABLE,0)
	
	var get_block := get_cell_atlas_coords(ELEMENTS_LAYER, cord)
	
	return get_block == source_block or get_block == enable_cable_block



func disable_cable(cord) -> void:
	set_cell(BUFER, cord, 0, Vector2i(Elements.DISABLE_CABLE,0), get_cell_alternative_tile(ELEMENTS_LAYER, cord))

func enable_cable(cord) -> void:
	set_cell(BUFER, cord, 0, Vector2i(Elements.ENABLE_CABLE,0), get_cell_alternative_tile(ELEMENTS_LAYER, cord))



func is_wired(cord: Vector2i, direction: Vector2i) -> bool:
	return get_cell_alternative_tile(ELEMENTS_LAYER,cord) == direction_map[direction]



func _on_timer_timeout() -> void:
	stroke()
