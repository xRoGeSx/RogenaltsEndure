class_name Graph
extends Control
var edgeRescrourse  = preload("res://Scenes/Graph/Edge.tscn");
var Edges: Array[Edge]= [];

@onready var root = $Content/Nodes/Node
@onready var edges = $Content/Edges
@onready var nodes = $Content/Nodes
@onready var content: Node2D = $Content

var itemListIdToNodeMap = {};

func generateEdgeKey(first: CustomGraphNode, second: CustomGraphNode) -> String:
	var keyArr = [first.key, second.key];
	keyArr.sort();
	return "".join(keyArr);

func edgePointingToNode(node: NodePath) -> Array[Edge]:
	return Edges.filter(func(edge: Edge): return edge.inPath == node)


func shouldCreateEdge(key: String) -> bool:
	var existKeys = Edges.map(func(edge: Edge) -> String: return edge.key)
	return !existKeys.has(key)

func createEdge(first: CustomGraphNode, second: CustomGraphNode) -> void:
	if(!shouldCreateEdge(generateEdgeKey(first, second))): return;
	var edge: Edge = edgeRescrourse.instantiate()
	edge.inPath = first.get_path();
	edge.outPath = second.get_path();
	edges.add_child(edge)
	Edges.append(edge)
	
func getHangingEdges():
	return Edges.filter(func(edge: Edge): return edge.isHanging()).map(func(edge: Edge): return edge.getHanging())

func handleConnection(connection: CustomGraphNode, currentNode: CustomGraphNode):
	createEdge(connection,currentNode)
	return true;

func pathToConnection(nodePath: NodePath) -> CustomGraphNode:
	var node = root.get_node(nodePath)
	return root.get_node(nodePath)

func handleNodeChildren(node: CustomGraphNode):
	node.connections.map(pathToConnection).all(func(cnode): return handleConnection(node, cnode))
	return true;
	
func updateListWithHangingNodes() -> void: 
	itemListIdToNodeMap.clear();
	getHangingEdges().all(func(node): 
		return true;)

func _ready():
	var nodesC: Array[Node] = nodes.get_children();
	nodesC.all(handleNodeChildren)
	EventBus.connect("activeStateChanged", _on_node_active_state_changed)
	updateListWithHangingNodes()
	pass # Replace with function body.


func _on_node_active_state_changed(state:bool, node: CustomGraphNode):
	updateListWithHangingNodes()
	pass # Replace with function body.


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	var node: CustomGraphNode = itemListIdToNodeMap[index];
	node.setActivating();
	pass # Replace with function body.


	
