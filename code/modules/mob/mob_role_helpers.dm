/mob/proc/GetRole(var/role_id)
	if(!mind)
		return null
	return mind.GetRole(role_id)