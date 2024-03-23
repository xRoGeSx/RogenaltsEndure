class_name Weapon
extends Area2D

func get_class() -> String:
	return "Weapon"

var sword: Sprite2D = null;
var player: CharacterBody2D  = null;
@onready var hitbox = $Hitbox
@onready var saber = $SubViewport/Node3D/RussianCossackShashquaSaber
@onready var weapons = $SubViewport/Node3D/Weapons

var isSelfPointed = false;


var moveTarget: Vector2 = Vector2.ZERO;
var attack_start: Vector2 = Vector2.ZERO;
var attack_target: Vector2 = Vector2.ZERO;
var arcStart: Vector2; var arcEnd: Vector2;



@onready var knockback: Knockback = $Knockback
@onready var damaging: Damaging = $Damaging: get = getDamaging

var skills: Array[Skill] = []: get = getSkills
func getSkills() :
	return SkillManager.aquiredSkills.map(SkillManager.getSkill)
var t = 0.0

var stats = preload("res://Scenes/Weapon/WeaponStatblock.gd").new(): get = getStats;
func getStats() -> WeaponStatblock:
	return skills.reduce(Callable(Skill, "handleWeaponSkillModification"), stats)
func getDamaging() -> Damaging:
	return skills.reduce(Callable(Skill, "handleDamagingSkillModification"), damaging);
enum WeaponState {
	Idle,
	Attack,
	AttackReturn,
}

enum AttackState {
	Poke,
	Swing,
}
var currentState = WeaponState.Idle;
var currentAttackState = AttackState.Swing;
@onready var military_axe = $SubViewport/Node3D/MilitaryAxe

func _ready():
	scale.x = stats.scaleX;
	sword = $Sword;
	player = $"../Player"
	pass 

func isInIdlePosition() -> bool: 
		return position.is_equal_approx(moveTarget)
func isAttacking() -> bool:
		return currentState == WeaponState.Attack || currentState == WeaponState.AttackReturn
func getDistanceAttackSpeedModifier() -> float:
	return  stats.attack_range / attack_target.distance_to((attack_start)) ;
	

func moveToIdlePosition(delta, _speed = stats.speed):
	var mouse_dir = player.get_local_mouse_position().normalized();
	moveTarget = player.position + stats.distance * mouse_dir;
	if(!isAttacking()): 
		look_at(get_global_mouse_position())
	if(moveTarget != Vector2.ZERO && !isInIdlePosition() ):
		position = position.move_toward(moveTarget, delta * _speed )
	weapons.rotation.x= move_toward(weapons.rotation.x, moveTarget.angle_to(position)* 2, delta * _speed )


	
func swing(delta):
	
	var startAngle = (attack_target - attack_start).angle()
	t += delta * stats.attackSpeed * getDistanceAttackSpeedModifier()
	var angle = lerp(-stats.attack_arc / 2, stats.attack_arc / 2, min(t,1.0),) + rad_to_deg(startAngle);
	var angleDiff = angle - rad_to_deg(rotation);
	rotate(deg_to_rad(angleDiff))
	var relativePoint = position - attack_start;
	var p_radius =  (arcStart - attack_start).length();
	var p_angle = atan(relativePoint.y / relativePoint.x);
	p_angle = deg_to_rad(angle);
	position = Vector2(p_radius * cos(p_angle), p_radius * sin(p_angle)) + attack_start;
	if(round(p_angle) == round(startAngle + deg_to_rad(stats.attack_arc / 2))): 
		t = 0;
		hitbox.disabled = true;    
		currentState = WeaponState.AttackReturn;
		
func poke(delta):
	var startAngle = (attack_target - attack_start).angle()	
	var angle = lerp(rad_to_deg(startAngle), int(round(-stats.attack_arc / 2))  + rad_to_deg(startAngle), min(t, 1))
	var angleDiff = angle - rad_to_deg(rotation);
	rotate(deg_to_rad(angleDiff))
	t += delta * stats.attackSpeed * getDistanceAttackSpeedModifier();
	position = position.bezier_interpolate(attack_start, attack_target, arcStart, min(t, 1.0));
	if(position.is_equal_approx(arcStart)): 
		t = 0;
		currentAttackState = AttackState.Swing;
	
func processAttack(delta): 
	match currentAttackState:
		AttackState.Swing:
			swing(delta)
		AttackState.Poke:
			poke(delta)


func processAttackReturn(delta): 
	if(!isInIdlePosition()):
		t += delta * stats.attackSpeed * getDistanceAttackSpeedModifier()
		position = position.bezier_interpolate(arcEnd, attack_target, moveTarget, min(t, 1.0));
	else: 
		attack_target = Vector2.ZERO;
		if(stats.auto_attack):
			startAttack(delta)
		currentState = WeaponState.Idle;
		stats.attack_range = stats.default_attack_range;

func extendAttackRangeWhileMoving(gravity: Vector2) -> void:
	var velocity = player.velocity;
	var additional_range = 0;
	if(velocity.x > 0 && gravity.x > 0|| velocity.y > 0 && gravity.y > 0||velocity.x < 0 && gravity.x < 0|| velocity.y < 0 && gravity.y < 0):
		additional_range += velocity.length()  / stats.attackSpeed;
	stats.attack_range = stats.attack_range + additional_range;	

func startAttack(delta): 
	t = 0;
	damaging.damage = round(randf_range(damaging.default_damage, damaging.default_damage + 2))
	hitbox.disabled = false;
	stats.attack_range = stats.default_attack_range;
	moveToIdlePosition(delta);
	attack_start = position;
	attack_target = get_global_mouse_position()
	var gravity = (attack_target - attack_start).normalized();
	extendAttackRangeWhileMoving(gravity)
	
	var distanceToTarget = attack_start.distance_to(attack_target);
	if(distanceToTarget - stats.attack_range > 0):
		attack_target = attack_target - (gravity * (distanceToTarget - stats.attack_range))
	currentState = WeaponState.Attack;
	arcStart = (attack_target - player.global_position) / 3 +  (attack_target - player.global_position).rotated(deg_to_rad( -stats.attack_arc / 2)) + player.global_position
	arcEnd =   (attack_target - player.global_position) / 3 + (attack_target - player.global_position).rotated(deg_to_rad( stats.attack_arc / 2)) + player.global_position;
	
	currentAttackState = AttackState.Poke;
	return;
	
var angle = 0;

func _physics_process(delta):
	#angle += delta * 10;
	#position = player.global_position;
	#var relativePoint = position ;
	#var p_radius = 50;
	#var p_angle = atan(abs(relativePoint.y) / abs(relativePoint.x));
	#p_angle += angle;
	#position += Vector2(p_radius * cos(p_angle), p_radius * sin(p_angle)) 
	#return;
	if(Input.is_action_just_released("Attack") && !isAttacking()):
		startAttack(delta)
		return;
	moveToIdlePosition(delta)
	if(currentState == WeaponState.Attack): 
		processAttack(delta)
		return;
	if(currentState == WeaponState.AttackReturn):
		processAttackReturn(delta)
	pass
	return;

func _process(delta):
	queue_redraw()

