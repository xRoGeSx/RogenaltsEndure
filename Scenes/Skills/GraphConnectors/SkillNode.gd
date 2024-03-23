class_name SkillNode;
extends CustomGraphNode

@onready var skill_node = $"."

@export var skillName: SkillManager.SkillName;
var skill: Skill;

# Called when the node enters the scene tree for the first time.
func _ready():
	var m = preload("res://Scenes/Skills/GraphConnectors/SkillNodeMaterial.tres").duplicate();
	skill_node.material = m;
	if(skillName != null):
		skill = SkillManager.skills[skillName] 
		nodeName = skill.name;
	super()

func _process(delta):
	super(delta);
	pass

func handleOpacity(opacity: float):
	material.set_shader_parameter("opacity", opacity)
	pass;
func handleAnimation(total, first, second):
	material.set_shader_parameter("animation", lerp(0.5, 1.0, total))
	pass;

func _on_button_down():
	super()

func _on_button_up():
	super()


func _on_active_state_changed(state):
	if(state == true):
		SkillManager.aquiredSkills.append(skillName)
		print(SkillManager.aquiredSkills)
	pass # Replace with function body.
