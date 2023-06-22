extends Node

enum PowerIndecatorList{
	ENABLE,
	DISABLE,
	ONE_MINUS,
	ERROR
}

var power_indecator_cord = {
	PowerIndecatorList.ENABLE : Vector2i(0,0),
	PowerIndecatorList.DISABLE : Vector2i(1,0),
	PowerIndecatorList.ONE_MINUS : Vector2i(0,1),
	PowerIndecatorList.ERROR : Vector2i(1,1),
}
