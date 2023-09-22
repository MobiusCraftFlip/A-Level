using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

public partial class ChunkManager : TileMap
{
	[Export]
	private TileMap tileMap;
	[Export]
	private FastNoiseLite noise_map = new FastNoiseLite();
	private Transform2D playerLocation;
	private Dictionary<Vector2I, Chunk> chunks = new Dictionary<Vector2I, Chunk>();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		this.noise_map.NoiseType = FastNoiseLite.NoiseTypeEnum.Simplex;
		this.noise_map.Seed = 782336472;
		this.noise_map.Frequency = 50;
		this.noise_map.FractalOctaves = 5;
		this.noise_map.FractalLacunarity = 0.07f;
		this.noise_map.FractalGain = 6;

		Timer timer = new Timer();
		AddChild(timer);
		timer.Timeout += this.CullChunks;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void LoadChunk(Vector2I chunkLocation) {
		Chunk chunk = new Chunk(this.tileMap, chunkLocation, noise_map);
		this.chunks[chunkLocation] = chunk;
	}

	public void CullChunks() {
		Vector2I[] loadedChunks = {};

		for (int x = 0; x < 8; x++) {
			for (int y = 0; y < 8; y++) {
				loadedChunks.Append(new Vector2I(x,y));
			}
		}

		foreach (KeyValuePair<Vector2I, Chunk> entry in this.chunks) {
			Chunk chunk = entry.Value;
			if (!loadedChunks.Contains(entry.Key)) {
				GD.Print("ERASe");
				chunk.Unload();
				chunks.Remove(entry.Key);
			}
		}
	}
}
