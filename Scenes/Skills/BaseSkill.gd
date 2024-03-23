class_name Skill
extends Object
const className = "BaseSkill"

func get_class() -> String:
	return className;
func is_class(name: String) -> bool:
	return  name == className || super(name)
var name: String = "Base skill": get = getName
func getName() -> String:
	return "Base Skill"
var id: int;
var aquired: bool = false;



static func handleWeaponSkillModification(currentStats: WeaponStatblock, skill: Skill) -> WeaponStatblock:
	return skill.modifyWeaponStats(currentStats);
static func handleDamagingSkillModification(currentStats: Damaging, skill: Skill) -> Damaging:
	return skill.modifyDamagingStats(currentStats);
func modifyWeaponStats(weapon: WeaponStatblock) -> WeaponStatblock:
	return (dict_to_inst( inst_to_dict(weapon))) as WeaponStatblock;
func modifyDamagingStats(damaging: Damaging) -> Damaging:
	return (dict_to_inst( inst_to_dict(damaging))) as Damaging;
func modifyPlayerStats(weapon: Player) -> void:
	pass;
