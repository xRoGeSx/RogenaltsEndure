extends Node2D

var DamageNumber = preload("res://Behaivours/DamageNumbers/DamageNumber.tscn")

var numbers_created: int = 0;

func createFloatingDamageNumber(value: int):
	numbers_created+= 1;
	var damageNumber: DamageNumber = DamageNumber.instantiate()
	damageNumber.text = str(value)
	damageNumber.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if numbers_created % 2 else HORIZONTAL_ALIGNMENT_RIGHT
	add_child(damageNumber)
	


func _on_health_health_decreased(decreased_by_value):
	createFloatingDamageNumber(decreased_by_value)
