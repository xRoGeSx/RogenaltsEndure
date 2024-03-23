class_name Damaging
extends Node2D
const className = "Damaging"

func get_class() -> String:
	return className;
func is_class(name: String) -> bool:
	return  name == className || Node2D.new().is_class(name)

@export var default_damage: int = 1;
@export var damage: int = default_damage;
