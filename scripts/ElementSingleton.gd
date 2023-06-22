extends Node

enum ElementList{
	SOURCE_BLOCK,
	DISABLE_CABLE,
	ENABLE_CABLE,
	NOT_ELEMENT,
	AND_ELEMENT,
}

var element_cord := {
	ElementList.SOURCE_BLOCK: Vector2i(0,0),
	ElementList.DISABLE_CABLE: Vector2i(1,0),
	ElementList.ENABLE_CABLE: Vector2i(2,0),
	ElementList.NOT_ELEMENT: Vector2i(3,0),
}

var direction_map := {
	Vector2i.UP: 0,
	Vector2i.RIGHT: 1,
	Vector2i.DOWN: 2,
	Vector2i.LEFT: 3,
	0: Vector2i.UP,
	1: Vector2i.RIGHT,
	2: Vector2i.DOWN,
	3: Vector2i.LEFT,
}

var selictions_element := {
	ElementList.SOURCE_BLOCK: Vector2i(0,0),
	ElementList.DISABLE_CABLE: Vector2i(1,0),
	ElementList.NOT_ELEMENT: Vector2i(3,0),
}


var list := 0

var select_block: Vector2i = selictions_element[ElementList.SOURCE_BLOCK]
var block_direction := 0

# не лезь оно тебя сожрёт
func _input(_event: InputEvent) -> void:
	list = clamp(list, 0, selictions_element.size()-1)
	if Input.is_action_just_pressed("next_list"):
		list += 1
	if Input.is_action_just_pressed("past_list"):
		list -= 1
	
	if Input.is_action_just_pressed("select_item_1"):
		select_block = selictions_element[selictions_element.keys()[list*4]]
	elif Input.is_action_just_pressed("select_item_2"):
		select_block = selictions_element[selictions_element.keys()[list*4+1]]
	elif Input.is_action_just_pressed("select_item_3"):
		select_block = selictions_element[selictions_element.keys()[list*4+2]]
	elif Input.is_action_just_pressed("select_item_4"):
		select_block = selictions_element[selictions_element.keys()[list*4+3]]
	
	if Input.is_action_just_pressed("direction_up"):
		block_direction = direction_map[Vector2i.UP]
	elif Input.is_action_just_pressed("direction_down"):
		block_direction = direction_map[Vector2i.DOWN]
	elif Input.is_action_just_pressed("direction_left"):
		block_direction = direction_map[Vector2i.LEFT]
	elif Input.is_action_just_pressed("direction_right"):
		block_direction = direction_map[Vector2i.RIGHT]
