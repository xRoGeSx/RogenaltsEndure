class_name DamageNumber
extends Node2D

@onready var label: Label = $Label
@export
var text: String = '';
@export
var horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT;



# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text;
	label.horizontal_alignment = horizontal_alignment;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	queue_free()
