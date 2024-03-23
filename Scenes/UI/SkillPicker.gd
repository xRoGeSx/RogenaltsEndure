extends Container
@onready var graph: Graph = $Graph

var min_scale = 1;
var initalPosition: Vector2;
var initalGraph: Vector2;

var dragging: bool = false;
var startedDraggingAt: Vector2 = Vector2.ZERO;
var positionWhenStartedDragging: Vector2 = Vector2.ZERO;
var projectResolution: Vector2 = Vector2.ZERO;

@export var zoom_speed = Vector2(0.05, 0.05)
@export var dragSpeed = 150;

var is_viewing_skilltree = false: set = setViewingSkiltree

func actualSize() -> Vector2:
	return size * scale;
	
func maxTranslation() -> Vector2: 
	var x = ((actualSize().x / projectResolution.x) - 1) *  projectResolution.x;
	var y = ((actualSize().y / projectResolution.y) - 1) * projectResolution.y;
	return Vector2(-x,-y);
func isWithinScreen(position: Vector2) -> bool:
	return position.x < 0 && abs(position.x) < (actualSize().x - projectResolution.x) && position.y < 0 && abs(position.y) < (actualSize().y - projectResolution.y)
func fitsScreen(dimensions :Vector2) -> bool:
	return dimensions.y >projectResolution.y && dimensions.x > projectResolution.x 

func _ready():
	initalPosition = position;
	initalGraph = graph.position;
	projectResolution=Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
	min_scale=projectResolution / size;
	print(maxTranslation())
	
func _unhandled_input(event):
	if(event.is_action_pressed("SkillTreeOpen")):
		is_viewing_skilltree = !is_viewing_skilltree
		
func setViewingSkiltree(state: bool):
	is_viewing_skilltree =state;
	get_tree().paused = state;
	visible = state;
func _physics_process(delta):
	if(!is_viewing_skilltree): return;	
	if(dragging):
		var direction = get_global_mouse_position() - startedDraggingAt
		var target = positionWhenStartedDragging + direction;
		var movement = lerp(positionWhenStartedDragging, target, delta * dragSpeed)
		position = movement.clamp(maxTranslation(), Vector2.ZERO);
func _input(event: InputEvent):
	if(!is_viewing_skilltree): return;
	if event is InputEventMouseButton: 
		if(!event.is_pressed()): 
			dragging = false;
		else: 
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					startedDraggingAt = get_global_mouse_position()
					positionWhenStartedDragging = position;
					dragging = true;
				MOUSE_BUTTON_WHEEL_UP:
					var new_scale= scale + zoom_speed;
					if(!fitsScreen(size * new_scale)): return;
					scale += zoom_speed;
					position -= Vector2(250.0, 250.0);
					position = position.clamp(maxTranslation(), Vector2.ZERO)
					pass;
				MOUSE_BUTTON_WHEEL_DOWN:
					var new_scale= scale - zoom_speed;
					if(!fitsScreen(size * new_scale)): return;
					scale -= zoom_speed;
					position += Vector2(250.0, 250.0);
					position = position.clamp(maxTranslation(), Vector2.ZERO)
					pass;
					#var new_scale = scale-zoom_speed;
					#graph.scale = new_scale;


