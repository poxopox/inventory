extends PanelContainer
class_name Item

var tile_scene: PackedScene = preload("res://Tile.tscn")
var tap_sound_res = preload("res://tap.ogg")

@export var on_drop: Callable
@export var on_click: Callable
@export var item_size: Vector2 = Vector2(2, 2)
@export var shape: Array[int] = [
	1, 1,
	1, 1
]

@export var tile_size: int:
	get:
		return tile_size;
	set(num):
		tile_size = num

var dragging: bool = false;
var click_time = 0
var timing_click = false

@export var col: int
@export var row: int

func _gui_input(event):
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			timing_click = true
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			timing_click = false
			if click_time < 500 and on_click:
				on_click.call(self)
			click_time = 0
			timing_click = false

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
	if timing_click:
		click_time += floor(delta * 1000)
	if dragging:
		for child in $TileContainer.get_children():
			if child is Tile:
				child.get_node("Sprite2D").self_modulate.a = 0.5
	else:
		for child in $TileContainer.get_children():
			if child is Tile:
				child.get_node("Sprite2D").self_modulate.a = 1

func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("Is same: ", data == self)
	if data == self:
		var drop_pos = Vector2(col * tile_size, row * tile_size)
		var mouse_quadrant_vals = at_position - (size/2);
		var is_left = mouse_quadrant_vals.x <= -0
		var is_right = mouse_quadrant_vals.x >= -0
		var is_top = mouse_quadrant_vals.y <= -0
		var is_bottom = mouse_quadrant_vals.y >= -0
		if is_left and is_top:
			print("Top Left")
		elif is_right and is_top:
			print("Top Right")
			drop_pos.x += tile_size
		elif is_left and is_bottom:
			drop_pos.y += tile_size
			print("Bottom Left")
		elif is_right and is_bottom:
			print("Bottom Right")
			drop_pos.x += tile_size
			drop_pos.y += tile_size
		dragging = false
		if on_drop != null:
			on_drop.call(drop_pos, data)
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var mouse_quadrant_vals = at_position - (size/2);
	var is_within_bounds = at_position
	var is_left = mouse_quadrant_vals.x <= -0
	var is_top = mouse_quadrant_vals.y <= -0
	if is_left and is_top:
		return false
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
