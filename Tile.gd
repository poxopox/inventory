extends Control
class_name Tile

var _col: int
@export var tile_size: int
@export var col: int :
	get:
		return _col
	set(num):
		_col = num
var _row: int
@export var row: int :
	get:
		return _row
	set(num):
		_row = num
func _ready () -> void:
	var texture_size = $Sprite2D.texture.get_size()
	var scale_x = tile_size / texture_size[0]
	var scale_y = tile_size / texture_size[1]
	$Sprite2D.scale = Vector2(scale_x, scale_y)
	mouse_filter = MOUSE_FILTER_PASS
	set_custom_minimum_size(Vector2(tile_size, tile_size))

func _process(delta: float) -> void:
	pass

#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#print("Tile Variant" + str(at_position) + " " + str(data))
	#return true
