extends Control
class_name EmptyTile

@export var on_drop: Callable

@export var tile_size: int:
	get:
		return tile_size;
	set(num):
		tile_size = num
		var texture_size = $Sprite2D.texture.get_size()
		var scale_x = tile_size / texture_size[0]
		var scale_y = tile_size / texture_size[1]
		$Sprite2D.scale = Vector2(scale_x, scale_y)
		custom_minimum_size = Vector2(tile_size, tile_size)
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
	mouse_filter = Control.MOUSE_FILTER_STOP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("Dropping item on empty tile at col:", col, "row:", row)
	# Check if the dropped data is an Item
	if data is Item and on_drop != null:
		on_drop.call(Vector2(col * tile_size, row * tile_size), data)



func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Only accept Item objects
	if data is Item:
		print("Can drop item on empty tile at col:", col, "row:", row)
		return true
	return false
