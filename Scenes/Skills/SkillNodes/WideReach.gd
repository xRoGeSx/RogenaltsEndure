extends Skill
func getName():
	return 'Wide Reach'
func modifyWeaponStats(weapon: WeaponStatblock) -> WeaponStatblock:
	var modifiedStatblock = super(weapon)
	modifiedStatblock.attack_arc += 20;
	return modifiedStatblock;
