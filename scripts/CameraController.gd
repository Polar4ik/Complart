extends Camera2D

const MIN_ZOOM = Vector2(1.5,1.5)
const MAX_ZOOM = Vector2(4.5,4.5)

var direction := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		direction = event.relative

	if Input.is_action_pressed("camera_move"):
		move()
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_in()
	
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_out()

func move() -> void:
	position += -direction * 0.5 / (zoom / 1.5)

func zoom_in() -> void:
	if zoom < MAX_ZOOM:
		zoom += Vector2.ONE

func zoom_out() -> void:
	if zoom > MIN_ZOOM:
		zoom -= Vector2.ONE
