using Godot;
using System;
using System.Security.Cryptography.X509Certificates;

public partial class Chunk : Node
{
	public static int CHUNK_SIZE = 32;
	public Vector2I chunk;
	public TileMap tilemap;
	public Vector2I offset;
	private Boolean[,] voxels = new Boolean[CHUNK_SIZE,CHUNK_SIZE];

	private FastNoiseLite noise_map;
	public Chunk(TileMap tilemap, Vector2I chunk, FastNoiseLite noise_map) {
		this.tilemap = tilemap;
		this.chunk = chunk;
		this.noise_map = noise_map;
		this.offset = chunk * CHUNK_SIZE;
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void generate_terrain() {
		for (int x = 0; x < CHUNK_SIZE; x++) {
			for (int y = 0; y < CHUNK_SIZE; y++) {
				float rand = Math.Abs(this.noise_map.GetNoise2D(x + this.offset.X, y + this.offset.Y));
				if (rand > 0.3f) {
					this.voxels[x,y] = true;
					this.tilemap.SetCell(0, new Vector2I(x,y) + this.offset, 0, Vector2I.Zero, 0);
				}
			}
		}
	}

	public void Unload() {
		for (int x = 0; x < CHUNK_SIZE; x++) {
			for (int y = 0; y < CHUNK_SIZE; y++) {
				this.tilemap.SetCell(0, new Vector2I(x,y) + this.offset, -1);	
			}
		}
	}
}
