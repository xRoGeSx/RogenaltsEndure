extends Node2D
@export
var node = preload("res://Scenes/Enemy/Enemy.tscn")

@onready var player = $"../Player"
@export
var enemies = 2;

# Called when the node enters the scene tree for the first time.
var t = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t+=1;
	if(t  <= enemies ):
		var enemy = node.instantiate()
		enemy.position = Vector2(randf_range(0,100),randf_range(0,100))
		enemy.target = player;
		enemy.spawner = self;
		self.add_child(enemy)
	pass
