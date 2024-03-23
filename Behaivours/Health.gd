class_name Health;
extends Node2D


@export var max_health: int = 1;
@onready var health = max_health : set = set_health;

signal health_changed(new_value: int)
signal health_decreased(decreased_by_value: int)
signal health_depleted

func set_health(value: int):
	emit_signal("health_changed", value)
	if(value < health):
		emit_signal("health_decreased", health - value)
	if(value <= 0):
		emit_signal("health_depleted")
	health = value;
	
