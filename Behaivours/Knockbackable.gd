class_name Knockbackable
extends Node2D

var total_knockback_distance: int = 0;
var knockback_motion: Vector2;
var knockback_source: Knockback;

@onready var parent = self.get_parent() as CharacterBody2D;

func processKnockback(delta):
		if(!knockback_source || !knockback_motion.length()):
			return;
		var posBeforeCollision = parent.position;
		parent.move_and_collide(knockback_motion * delta)
		var posAfterKnockback = parent.position;
		total_knockback_distance+= posBeforeCollision.distance_to(posAfterKnockback);
		if(total_knockback_distance > knockback_source.knockback_strength / 5):
			knockback_motion = Vector2.ZERO
			knockback_source = null;

func handleKnockback(knockback: Knockback):
	if(knockback_motion.length() != 0):
		return;
	total_knockback_distance = 0;
	if (!knockback.is_class("Knockback")):
		pass;
	knockback_motion = -(knockback.global_position - global_position).normalized() * knockback.knockback_strength
	knockback_source = knockback;


func _physics_process(delta):
	processKnockback(delta)
