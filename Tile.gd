extends Container
class_name Tile
var tap_sound_res = preload("res://tap.ogg")
var _col: int     = 0
@export var tile_size: int

@export var col: int : 
	get:
		return _col
	set(num): 
		self.position.x = num * tile_size;
		_col = num
var _row: int = 0
@export var row: int : 
	get:
		return _row
	set(num): 
		self.position.y = num * tile_size;
		_row = num
var dragging: bool = false;

func _ready () -> void:
	var texture_size = $Sprite2D.texture.get_size()
	var scale_x = tile_size / texture_size[0]
	var scale_y = tile_size / texture_size[1]
	$Sprite2D.scale = Vector2(scale_x, scale_y)
	set_custom_minimum_size(Vector2(tile_size, tile_size))
	self.position = Vector2(col * tile_size, row * tile_size)


func _process(delta: float) -> void:
	if dragging:
		$Sprite2D.self_modulate.a = 0.1
	else:
		$Sprite2D.self_modulate.a = 1

#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#print("Variant" + str(at_position) + " " + str(data))
	#return true
	
