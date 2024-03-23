extends Skill
func getName():
	return 'Swift Hands'
func modifyWeaponStats(weapon: WeaponStatblock) -> WeaponStatblock:
	var modifiedStatblock = super(weapon)
	modifiedStatblock.attackSpeedBaseModifier += 5;
	return modifiedStatblock;
