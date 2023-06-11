extends Node

var block_directional := 0

enum BlockType{
	SOURCE_BLOCK,
	CABLE,
}
var select_block := BlockType.SOURCE_BLOCK

var tilemap: TileMap

func _input(event: InputEvent) -> void:
	if !event is InputEventKey:
		return
	
	if event.keycode == KEY_1 or event.keycode == KEY_KP_1:
		select_block = BlockType.SOURCE_BLOCK
#		print(select_block)
	elif event.keycode == KEY_2 or event.keycode == KEY_KP_2:
		select_block = BlockType.CABLE
#		print(select_block)
	
	if event.keycode == KEY_UP or event.keycode == KEY_W:
		block_directional = 0
		print("Block Dir: ", block_directional)
	elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
		block_directional = 2
		print("Block Dir: ", block_directional)
	elif event.keycode == KEY_LEFT or event.keycode == KEY_A:
		block_directional = 3
		print("Block Dir: ", block_directional)
	elif event.keycode == KEY_RIGHT or event.keycode == KEY_D:
		block_directional = 1
		print("Block Dir: ", block_directional)
