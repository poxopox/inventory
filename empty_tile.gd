extends Control
class_name EmtpyTile

var _tile_size: int
@export var tile_size: int: 
	get:
		return tile_size;
	set(num):
		tile_size = num
		var texture_size = $Sprite2D.texture.get_size()
		var scale_x = tile_size / texture_size[0]
		var scale_y = tile_size / texture_size[1]
		$Sprite2D.scale = Vector2(scale_x, scale_y)
var _col: int = 0
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
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = Vector2(col * tile_size, row * tile_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
