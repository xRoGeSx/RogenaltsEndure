class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0;
var animationPlayer: AnimationPlayer = null;
@export
var Hitbox: CollisionShape2D = null;

var Sprites = {};
var mousePosition = null;

const SpriteNames = {
	Run = "Run",
	Idle = "Idle",
	Fly = "Fly"
}

var activePlayerSprite = SpriteNames.Idle;

func normalizeSprite(sprite: Sprite2D):
	sprite.hide();
	sprite.position = Hitbox.position;
	sprite.position.x += sprite.texture.get_width() / sprite.hframes/ 2
	return true;
	
func createSpriteMap(sprite: Sprite2D): 
	Sprites[sprite.name] = sprite;
	normalizeSprite(sprite)
	return true;

func _ready():
	animationPlayer = $AnimationPlayer;
	Hitbox = $Hitbox;
	$Sprites.get_children().all(createSpriteMap)
	
func handleActiveSprite(direction: int): 
	var sprite = Sprites[activePlayerSprite];
	if(!sprite): return;
	animationPlayer.play(activePlayerSprite);
	sprite.show();
	sprite.set_flip_h( direction < 0)
		
	Sprites.values().all(func(sprite): 
		if(sprite.name == activePlayerSprite): return true;
		sprite.hide();
		return true;
		)

	

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionHorizontal = Input.get_axis("ui_left", "ui_right");
	var directionVeritcal = Input.get_axis('ui_down', 'ui_up');
	if directionHorizontal || directionVeritcal:
		if directionHorizontal: 
			velocity.x = directionHorizontal * SPEED
			activePlayerSprite = SpriteNames.Run;
		else: 
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if directionVeritcal: 
			velocity.y = -directionVeritcal * SPEED
			activePlayerSprite= SpriteNames.Fly
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED);
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED);
		activePlayerSprite = SpriteNames.Idle;
	handleActiveSprite(directionHorizontal);
	move_and_collide(velocity * delta)
	#queue_redraw()



