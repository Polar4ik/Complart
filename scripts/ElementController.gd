extends TileMap

const ELEMENT_LAYER := 0
const BUFER := 1
const POWER_LAYER := 2
const POWER_BUFER := 3


var mouse_pos := Vector2.ZERO

var create_pressed := false
var delete_pressed := false
func _input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("create_tail"):
		create_pressed = false
		delete_pressed = false
		return
	
	mouse_pos = local_to_map(get_global_mouse_position())
	
	if get_cell_atlas_coords(ELEMENT_LAYER, mouse_pos) == -Vector2i.ONE and get_cell_atlas_coords(BUFER, mouse_pos) == -Vector2i.ONE and delete_pressed == false:
		create_pressed = true
		create_block()
	elif get_cell_atlas_coords(ELEMENT_LAYER, mouse_pos) != -Vector2i.ONE and create_pressed == false:
		delete_pressed = true
		delete_block()


# Создание блока
func create_block() -> void:
	if tile_set.get_source(0).get_alternative_tiles_count(ElementSingleton.select_block) > 1: # есть ли у выброного обьекта тайлы с направлением
		set_cell(BUFER, mouse_pos, 0, ElementSingleton.select_block, ElementSingleton.block_direction) # создаём блок с вращением
	else: # если нету у обьекта направлений
		set_cell(BUFER, mouse_pos, 0, ElementSingleton.select_block) # создаём блок без вращения

# удаление блока
func delete_block() -> void:
	erase_cell(ELEMENT_LAYER, mouse_pos)
	erase_cell(BUFER, mouse_pos)
	disable_cell(mouse_pos)

# переносим все тайлы с буфера на слой элементов
func transfer_from_bufer() -> void:
	for cell in get_used_cells(BUFER): # проходимся по всем обьектам
		set_cell(ELEMENT_LAYER, cell, 0, get_cell_atlas_coords(BUFER, cell), get_cell_alternative_tile(BUFER, cell)) # закидываем тайл в слой элементов
	
	clear_layer(BUFER) # очищаем буфер после завершения переноса тайлов

func transfer_from_power_bufer() -> void:
	for cell in get_used_cells(POWER_BUFER): # проходимся по всем обьектам
		set_cell(POWER_LAYER, cell, 1, get_cell_atlas_coords(POWER_BUFER, cell)) # закидываем тайл в слой элементов
	
	clear_layer(POWER_BUFER) # очищаем буфер после завершения переноса тайлов

# обработка источника энергии
func source_block_process() -> void:
	for source in get_used_cells_by_id(ELEMENT_LAYER, 0, ElementSingleton.element_cord[ElementSingleton.ElementList.SOURCE_BLOCK]): # проходимя по всем источникам энергии
		enable_cell(source) # включаем тайл


func disable_cable_process() -> void:
	for element in get_used_cells_by_id(ELEMENT_LAYER, 0, ElementSingleton.element_cord[ElementSingleton.ElementList.DISABLE_CABLE]):
		disable_cell(element)
		
		var cell_neighboor := [element+Vector2i.UP, element+Vector2i.RIGHT, element+Vector2i.DOWN, element+Vector2i.LEFT]
		cell_neighboor.erase(element+ElementSingleton.direction_map[get_cell_alternative_tile(ELEMENT_LAYER, element)])
		
		for neighboor in cell_neighboor:
			var direction = neighboor - element
			
			if not is_cell_enable(neighboor):
				continue
			
			if tile_set.get_source(0).get_alternative_tiles_count(get_cell_atlas_coords(ELEMENT_LAYER, neighboor)) == 1:
				enable_cell(element)
			elif tile_set.get_source(0).get_alternative_tiles_count(get_cell_atlas_coords(ELEMENT_LAYER, neighboor)) > 1 and get_cell_alternative_tile(ELEMENT_LAYER, neighboor) == ElementSingleton.direction_map[-direction]:
				enable_cell(element)
		
		if is_cell_enable(element):
			set_element(element, ElementSingleton.ElementList.ENABLE_CABLE)

func is_turned_on_us() -> bool:
	return false


func set_element(cord: Vector2i, element: ElementSingleton.ElementList) -> void:
	set_cell(BUFER, cord, 0, ElementSingleton.element_cord[element], get_cell_alternative_tile(ELEMENT_LAYER, cord))

# клетка включена?
func is_cell_enable(cord: Vector2i) -> bool:
	return get_cell_atlas_coords(POWER_LAYER, cord) == PowerIndecatorSingleton.power_indecator_cord[PowerIndecatorSingleton.PowerIndecatorList.ENABLE]


# включаем - выключаем клетку
func enable_cell(cord: Vector2i) -> void:
	set_cell(POWER_BUFER, cord, 1, PowerIndecatorSingleton.power_indecator_cord[PowerIndecatorSingleton.PowerIndecatorList.ENABLE])

func disable_cell(cord: Vector2i) -> void:
	set_cell(POWER_BUFER, cord, 1, PowerIndecatorSingleton.power_indecator_cord[PowerIndecatorSingleton.PowerIndecatorList.DISABLE])


# обработка хода
func stroke() -> void:
	transfer_from_power_bufer()
	transfer_from_bufer()
	source_block_process()
	disable_cable_process()

# вызов хода
func _stroke_update() -> void:
	stroke()
