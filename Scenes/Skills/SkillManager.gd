extends Node

enum SkillName {
	FastAndDeadly,
	SwiftHands,
	WideReach
}

var skills = {
	SkillName.FastAndDeadly: preload("res://Scenes/Skills/SkillNodes/FastAndDeadly.gd").new(),
	SkillName.SwiftHands: preload("res://Scenes/Skills/SkillNodes/SwiftHands.gd").new(),
	SkillName.WideReach: preload("res://Scenes/Skills/SkillNodes/WideReach.gd").new()
}

var aquiredSkills: Array[SkillName] = [];

var counter = 0;

func getSkill(skillName: SkillName) -> Skill:
	return skills[skillName] as Skill
