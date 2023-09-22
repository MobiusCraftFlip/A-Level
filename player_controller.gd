extends Node

const CAMERA_SPEED = 20
var camera: Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = self.get_parent() as Camera2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement = Vector2(0,0)
	if Input.is_action_pressed('right'):
		movement += Vector2(1,0)
	if Input.is_action_pressed('left'):
		movement += Vector2(-1,0)
	if Input.is_action_pressed('up'):
		movement += Vector2(0,-1)
	if Input.is_action_pressed('down'):
		movement += Vector2(0,1)
		
	self.get_parent().position += movement.normalized()*CAMERA_SPEED
