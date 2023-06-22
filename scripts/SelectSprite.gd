extends Sprite2D

@onready var camera: Camera2D = $"../MainCamera"

var dir_map := {
	0 : 0,
	1 : 90,
	2 : 180,
	3 : -90,
}

func _process(_delta: float) -> void:
	position = get_global_mouse_position() - Vector2(2,0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		region_rect.position.x = ElementSingleton.select_block.x * 16
		rotation_degrees = dir_map[ElementSingleton.block_direction]
