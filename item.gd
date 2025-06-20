extends PanelContainer
class_name Item

@export var item_size: Vector2 = Vector2(2, 2)
@export var shape: Array[int] = [0]
var _tile_size: int
@export var tile_size: int:
	get:
		return tile_size;
	set(num):
		tile_size = num
var tile_scene: PackedScene = preload("res://Tile.tscn")
var tap_sound_res = preload("res://tap.ogg")

var dragging: bool = false;

var _col: int
@export var col: int :
	get:
		return _col
	set(num):
		self.position.x = num * tile_size;
		_col = num
var _row: int
@export var row: int :
	get:
		return _row
	set(num):
		_row = num

func set_tile(col: int, row: int):
	var tile: Tile = tile_scene.instantiate();
	tile.name = 'Tile'+ str(col) + ':' + str(row);
	tile.tile_size = tile_size
	tile.col = col
	tile.row = row
	$TileContainer.add_child(tile)
	tile.position = Vector2(tile_size * col, tile_size * row)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(tile_size * item_size[0], tile_size * item_size[1])
	for row_idx in range(0, item_size[0]):
		for col_idx in range(0, item_size[1]):
			set_tile(col_idx, row_idx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		for child in $TileContainer.get_children():
			if child is Tile:
				child.get_node("Sprite2D").self_modulate.a = 0.5
	else:
		for child in $TileContainer.get_children():
			if child is Tile:
				child.get_node("Sprite2D").self_modulate.a = 1

#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#print("_drop_data", at_position, data)
	#dragging = false
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("_can_drop_data", at_position, data)
	return true
func _on_tree_exiting() -> void:
	dragging = false
func _get_drag_data(position) -> Item:
	dragging = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if $AudioStreamPlayer2D:
		$AudioStreamPlayer2D.stream = tap_sound_res
		$AudioStreamPlayer2D.pitch_scale = 2
		$AudioStreamPlayer2D.play()
	var preview: Node = self.duplicate(true)
	var control       = Control.new()
	control.add_child(preview)
	var size: Vector2 = custom_minimum_size
	var x: float      = size[0]
	var y: float = size[1]
	preview.position = Vector2(-(x/2), -(y/2))
	set_drag_preview(control)
	return self

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			dragging = false
