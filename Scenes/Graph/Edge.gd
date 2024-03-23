class_name Edge
extends Node2D

@onready var tree = $"../../.."
@onready var line: Line2D = $Line
@onready var label: Label = $Line/Label

var inPath: NodePath;
var outPath: NodePath;
var first: CustomGraphNode;
var second: CustomGraphNode;
var key = "";

@export var activeColor: Color = Color.WHITE;
@export var hangingColor: Color = Color.DIM_GRAY;
@export var inaccesibleColor: Color = Color.BLACK;
@export var amountOfPoints = 50.0;

var reversed = false;;


func isActive() -> bool:
	return first.active && second.active
func isHanging() -> bool:
	return (!first.active && second.active) || (first.active && !second.active)
func getHanging() -> CustomGraphNode:
	if(!isHanging()): return;
	if(first.active): return second;
	return first;
func getSourceGradientIndex() -> int:
	return 0 if first.active else 1;
func getTargetGradientIndex() -> int:
	return 0 if second.active else 1;
func getReversed() -> bool:
	return getTargetGradientIndex() == 0;
func getTargetProgress() -> float:
	return first.activationProgress if !first.active else second.activationProgress
# Called when the node enters the scene tree for the first time.
func _ready():
	if(!get_node_or_null(inPath) || !get_node_or_null(outPath)): return;
	first = get_node(inPath);
	second = get_node(outPath)
	key = tree.generateEdgeKey(first, second);
	line.gradient = line.gradient.duplicate()
	line.clear_points();
	reversed = getReversed();
	var firstPointCoordinate = first.get_global_rect().position - global_position + Vector2(first.width, first.height)  / 2;
	var lastPointCoordinate = second.get_global_rect().position - global_position + Vector2(second.width, second.height)  / 2;
	line.gradient.set_color(0,  activeColor if first.active else inaccesibleColor);
	line.gradient.set_color(1, inaccesibleColor if !second.active else activeColor);
	label.position = (firstPointCoordinate + lastPointCoordinate) / 2 - Vector2(32, 0)
	for i in amountOfPoints + 1:
		line.add_point(firstPointCoordinate.lerp(lastPointCoordinate, min(i/amountOfPoints, 1.0)))
	
	
	pass # Replace with function body.

func animateFromFirst() -> void:
	label.text = 'F: ' + "%.1f" % second.activationProgress
	line.gradient.set_color(0,  activeColor if first.active else inaccesibleColor);
	line.gradient.set_color(1, inaccesibleColor if !second.active else activeColor);
	line.gradient.set_offset(0,  second.activationProgress)
func animateFromSecond() -> void:
	label.text = 'S: ' + "%.1f" % first.activationProgress
	line.gradient.set_color(1,  activeColor if second.active else inaccesibleColor);
	line.gradient.set_color(0, inaccesibleColor if !first.active else activeColor);
	line.gradient.set_offset(1,  1 - first.activationProgress)
	
func _process(delta):
	if(!first || !second || !line): return;
	if(first.activating || first.deactivating):
		animateFromSecond();
	if(second.activating || second.deactivating):
		animateFromFirst();
	pass
