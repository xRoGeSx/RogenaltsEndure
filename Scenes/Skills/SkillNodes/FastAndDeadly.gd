extends Skill
func getName():
	return 'Fast and Deadly'
func modifyDamagingStats(damaging: Damaging) -> Damaging:
	var newDamging = super(damaging)
	newDamging.damage += 1;
	return newDamging;
	
func modifyWeaponStats(weapon: WeaponStatblock) -> WeaponStatblock:
	var newStats = super(weapon)
	newStats.attackSpeedMultiplierModfier += 0.5;
	return newStats;
