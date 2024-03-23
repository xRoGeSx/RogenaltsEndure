extends Node2D

@onready var weapon : Weapon = $Weapon
@onready var player = $Player

func _draw():
	#draw_circle( weapon.position + weapon.global_position - weapon.attack_target, 10, 'red')
	#draw_circle(weapon.position, 10, 'red')
	pass;
	
