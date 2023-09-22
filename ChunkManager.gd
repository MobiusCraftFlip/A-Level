extends Node

@export var camera: Sprite2D

const TileChunk = preload("res://chunk.gd")

var chunks = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.loadChunk(Vector2i(0,0))
	self.loadChunk(Vector2i(-1,0))
	self.loadChunk(Vector2i(-1,1))
	self.loadChunk(Vector2i(0,1))
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self.cull_chunks)
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
func loadChunk(position: Vector2i):
	var chunk = TileChunk.new(position, self.get_parent() as TileMap)
	chunk.generate_noise(782336472, 50, 5, 0.07, 6)
#	chunk.generate() 
	chunks[position] = chunk
#	print(chunks)
	
func cull_chunks():
	var loaded_chunks: Array = []
	var camera_chunk = Vector2i((camera.position / (32 * 16)))
	print(camera_chunk, camera.position)
	
	for x in 8:
		await get_tree().process_frame
		for y in 8:
			loaded_chunks.append(Vector2i(x-4,y-4) + camera_chunk)
			
	for position in chunks:
		var chunk = chunks[position]
		var array_position = loaded_chunks.find(position)
		if array_position == -1:
			print("ERASe")
			chunk.unload()
			chunks.erase(position)
#			chunks.remove(chunk)
#			chunks.er
	print(loaded_chunks.size(), chunks.size())
	for position in loaded_chunks:
		if not chunks.has(position):
			loadChunk(position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	cull_chunks()

