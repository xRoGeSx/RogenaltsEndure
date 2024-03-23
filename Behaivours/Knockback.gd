class_name Knockback
extends Node2D
const className = "Knockback"

func get_class() -> String:
	return className;
func is_class(name: String) -> bool:
	return  name == className || Node2D.new().is_class(name)

@export 
var knockback_strength = 1;
