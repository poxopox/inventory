extends Node2D
class_name Inventory
var tile_scene: PackedScene       = preload("res://Tile.tscn")
var empty_tile_scene: PackedScene = preload("res://EmptyTile.tscn")
var item_scene: PackedScene       = preload("res://Item.tscn")

@export var cols: int                     = 8
@export var rows: int                     = 5

@export var tile_size: int : 
	get():
		return tile_size
	set(value): 
		tile_size = value
		for child in get_children():
			child.tile_size = value 

var selected_item: Item

func set_tile(col: int, row: int):
	var tile: Tile = tile_scene.instantiate();
	tile.name = 'Tile'+ str(col) + ':' + str(row);
	tile.col = col
	tile.row = row
	tile.position = Vector2(10, 10)
	add_child(tile)

func set_item(col: int, row: int):
	var item: Item = item_scene.instantiate();
	item.name = 'Item'+ str(col) + ':' + str(row);
	item.col = col
	item.row = row
	item.tile_size = tile_size
	item.position = Vector2(tile_size * col, tile_size * row)
	item.on_drop = Callable(self, "item_drop")
	item.on_click = Callable(self, "item_click")
	add_child(item)
func move_item(item: Item, col: int, row: int):
	item.col = col
	item.row = row
	item.position = Vector2(tile_size * col, tile_size * row)
	#item.position = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryStore.register_inventory(self)
	for row in rows:
		for col in cols:
			var emtpy_tile: EmptyTile = empty_tile_scene.instantiate()
			emtpy_tile.col = col
			emtpy_tile.row = row
			emtpy_tile.on_drop = Callable(self, "item_drop")
			emtpy_tile.tile_size = tile_size
			add_child(emtpy_tile)
	set_item(0, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_coords: Vector2
	if selected_item != null:
		if Input.is_action_just_pressed("ui_left"):
			move_coords = Vector2(selected_item.col - 1, selected_item.row)
		if Input.is_action_just_pressed("ui_right"):
			move_coords = Vector2(selected_item.col + 1, selected_item.row)
		if Input.is_action_just_pressed("ui_up"):
			move_coords = Vector2(selected_item.col, selected_item.row - 1)
		if Input.is_action_just_pressed("ui_down"):
			move_coords = Vector2(selected_item.col, selected_item.row + 1)
		if move_coords:
			move_item(selected_item, move_coords.x, move_coords.y)
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("Inventory Variant" + str(at_position) + " " + str(data))
	return true
func item_drop(at_position: Vector2, data: Variant):
	print(at_position)
	print("Nearest X: ", floor(at_position.x / tile_size))
	print("Nearest Y: ", floor(at_position.y / tile_size))
	move_item(data as Item, floor(at_position.x / tile_size), floor(at_position.y / tile_size))
func item_click(item: Item):
	if item == selected_item:
		selected_item = null
	else:
		selected_item = item
