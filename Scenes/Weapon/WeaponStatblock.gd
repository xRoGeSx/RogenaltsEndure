class_name WeaponStatblock
extends Object

@export var attackSpeed = 4: get = getAttackSpeedWithModifiers;
var attackSpeedBaseModifier: float = 0.0;
var attackSpeedMultiplierModfier: float = 1.0;
func getAttackSpeedWithModifiers():
	return (attackSpeed + attackSpeedBaseModifier) * attackSpeedMultiplierModfier;
@export var distance = 80;
@export var speed = 400;
@export var default_attack_range: int  = 150;var attack_range: int = default_attack_range;
@export var attack_arc: int = 0;
@export var auto_attack: bool = false;
@export var damage = 1;
@export var scaleX = 1;
