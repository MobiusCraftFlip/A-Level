

#class_name Chunk

#@export var chunk: Vector2i = Vector2i(0,0)
#@export var tilemap: TileMap = self.get_parent() as TileMap
## Called when the node enters the scene tree for the first time.
#func _init(chunk: Vector2i, tilemap: TileMap):
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
class_name TileChunk

const CHUNK_SIZE: int = 32

#@export var alt_freq : float = 0.005
#
#@export var oct : int = 4
#
#@export var lac : int = 2
#
#@export var gain : float = 0.5
#
#@export var amplitude : float = 1.0

var chunk: Vector2i
var tilemap: TileMap
var offset: Vector2i
var voxels = {}
var noise_map

func _init(_chunk: Vector2i, _tilemap: TileMap):
	self.chunk = _chunk
	self.tilemap = _tilemap
	self.offset = _chunk * CHUNK_SIZE
	
#func generate():
#	for position in noise:
#		var value = noise[position]
#		if value > 0.3:
##			print("yes")
#			self.tilemap.set_cell(0, position, 0, Vector2i(0,0), 0)
#		print("no")

#func load():
#	pass
	
func generate_noise(noise_seed, frequency, octaves, lacunarity, gain):
	print("Loading: ", chunk)

	# generate randomly seeded simplex noise map
	if not noise_map:
		noise_map = FastNoiseLite.new()

		noise_map.noise_type = FastNoiseLite.TYPE_SIMPLEX

		noise_map.seed = noise_seed

		noise_map.frequency = frequency

		noise_map.fractal_octaves = octaves

		noise_map.fractal_lacunarity = lacunarity

		noise_map.fractal_gain = gain
	print(offset)
	for x in CHUNK_SIZE:

		for y in CHUNK_SIZE:

			var rand = abs(noise_map.get_noise_2d(x + offset.x, y + offset.y) * 2 - 1 )
			if rand > 0.3:
	#			print("yes")
				self.tilemap.set_cell(0, Vector2i(x, y) + offset, 0, Vector2i(0,0), 0)
				self.voxels[Vector2i(x,y)] = true


func unload():
	for x in CHUNK_SIZE:
		for y in CHUNK_SIZE:
			self.tilemap.set_cell(0, Vector2i(x,y), -1)
