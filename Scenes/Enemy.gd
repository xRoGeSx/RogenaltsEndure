extends CharacterBody2D

enum CollisionLayers {
	Player = 1, 
	Weapon = 2,
	Enemy = 3
}

@export
var speed = 150;
@export
var target: CharacterBody2D;
@export
var spawner: Node2D;

@onready var knockbackable: Knockbackable = $Knockbackable
@onready var health: Health = $Health
@onready var animation_player = $AnimationPlayer
@onready var hurt = $Hurt



# Called when twhe node enters the scene tree for the first time.
func _ready():
	hurt.material = load("res://Scenes/Enemy/GetHit.tres").duplicate()
	pass # Replace with function body.

func relativeToPosition(absolutePosition: Vector2) -> Vector2:
	return absolutePosition - spawner.position - position


func relativeTargetPosition() -> Vector2:
	return relativeToPosition(target.position)
	
func moveToTarget(delta): 
	if(relativeTargetPosition().length() < 10):
		return;
	var motion = relativeTargetPosition().normalized();
	move_and_collide( motion * speed * delta)
	
func takeDamage(damaging: Damaging):
	health.health -= damaging.damage;
	

	
func _physics_process(delta):
	moveToTarget(delta)


func _on_health_health_depleted():
	queue_free()
	pass # Replace with function body.


func _on_hurtbox_area_entered(area: Area2D):
	if("knockback" in area): 
		knockbackable.handleKnockback(area.knockback)
	if("damaging" in area):
		takeDamage(area.damaging)
	#if(area.collision_layer == CollisionLayers.Weapon):
	#	queue_free()
	pass # Replace with function body.


func _on_health_health_decreased(decreased_by_value):
	animation_player.play("GetHit")
	pass # Replace with function body.
