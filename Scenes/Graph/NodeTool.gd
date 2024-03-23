class_name CustomGraphNode
extends Button

@export var nodeName: String = "SkillNode"
@export var nodeIcon: Texture2D;
@export var active = false: set = setActive;
@export var activationTime: float = 0.5;
@export var connections: Array[NodePath] = [];

@onready var labelR = preload("res://Scenes/Graph/NodeLabel.tscn");
@onready var tree = $"../../.."

var activating = false;
var deactivating = false;

var activationProgress: float = 0: set = setActivationProgress;
func setActivationProgress(progress: float):
	activationProgress = progress;
var key: String = "";
var label: Label;


func pathToConnection(nodePath: NodePath) -> CustomGraphNode:
	return get_node(nodePath)
func getConnections():
	return connections.map(pathToConnection)
func hasActiveConnection() -> bool:
	return getConnections().any(func(node): return node.active)
func getNeighbourConnections():
	return  tree.edgePointingToNode(get_path());
	
signal activeStateChanged(state: bool);

func setActive(state: bool):
	active = state;
	EventBus.emit_signal("activeStateChanged", state, self)
	emit_signal("activeStateChanged", state)

var width: int = 0;
var height: int = 0;

func removeChildren():
	get_children().all(remove_child)
func isInteractivle():
	return !(!active && !isObtainable() || (active && !isRemovable()))
func isObtainable(): 
	return hasActiveConnection();
func isRemovable():
	var conns= getNeighbourConnections();
	if(!conns.size()): return true;
	var removable = getNeighbourConnections().all(func(edge: Edge): return !edge.second.active)
	return removable;
# Called when the node enters the scene tree for the first time.
func setupLabel():
	label = labelR.instantiate();
	add_child(label)
	label.size.x = width;
	label.size.y = height;
	for char in nodeName:
		if(char == char.to_upper()):
			label.text += char;

func _ready():
	key = name;
	activationProgress = 1.0 if active else 0.0;
	if(nodeIcon):
		icon = nodeIcon;
	width = icon.get_width();
	height = icon.get_height();
	setupLabel()

func deactivationProcess(delta):
	if(activationProgress == 0.0): 
		deactivating = false;
		activating = false;
		return;
	activationProgress -= delta / activationTime;
	activationProgress = max(activationProgress, 0.0)

func activationProcess(delta):
	if(active): return;
	if(activationProgress == 1.0): 
		active = true;
		activationProgress = 0;
		return;
	activationProgress += delta / activationTime;
	activationProgress = min(activationProgress, 1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func handleOpacity(opacity: float):
	modulate = Color(1,1,1, opacity)
func handleAnimation(progress: float, firstProgress: float, secondProgress: float):
	var firstScale = lerp(1.0, 1.2, firstProgress);
	var secondScale = lerp(1.2, 1.0, secondProgress);
	var combinedScale = lerp(firstScale, secondScale, progress)
	scale = Vector2(combinedScale, combinedScale);

func animateNode(delta):
	if(active):
		scale = Vector2(1.0, 1.0);
		handleOpacity(1)
		activationProgress = 0;
		return;
	var firstAnimationPart = min(activationProgress * 1.1, 1.0);
	var secondAnimationPart = max(min(activationProgress * 2 - firstAnimationPart, 0.0), 1.0)
	handleAnimation(activationProgress, firstAnimationPart, secondAnimationPart);
	handleOpacity(lerp(0.3, 1.0, firstAnimationPart))
	pass;
	
	
func _process(delta):
	if(deactivating):
		deactivationProcess(delta)
	elif(activating):
		activationProcess(delta) 
	animateNode(delta)
	pass


	
func setActivating() -> void:
	if(!isInteractivle()): return;
	if(active): return;
	deactivating = false;
	activating = true;

func _on_button_down():
	setActivating()
	pass # Replace with function body.

func _on_button_up():
	if(!isInteractivle()): return;
	deactivating = true;
	pass # Replace with function body.
