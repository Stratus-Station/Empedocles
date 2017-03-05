/**
 * GROUP OBJECTIVES
 *
 * Primarily to clean up Cult's awful fucking objectives.
 */

/datum/group_objective
	var/explanation_text = "Nothing"	//What that group is supposed to do.
	var/completed = 0					//currently only used for custom objectives.
	var/faction/group

	New(var/antag_role/owner)
		group = owner

	proc/check_completion()
		return completed

	proc/declare()
		var/text = explanation_text
		if(check_completion())
			text += " <span style=\"font-weight:bold;color:green\">Success!</span>"
		else
			text += " <span style=\"font-weight:bold;color:red\">Failed</span>"
		return text

// For filter_by_role()'s role_type.
#define ASSIGNED_ROLE 0
#define SPECIAL_ROLE  1

/datum/group_objective/targetted
	var/datum/mind/target = null		//If they are focused on a particular person.

	var/list/target_pool = list()

	// Seed the target pool for later filtering.
	proc/load_targets()
		for(var/datum/mind/possible_target in ticker.minds)
			if(possible_target && ishuman(possible_target.current) && possible_target.current.stat != DEAD)
				target_pool += possible_target

	// Pick target, empty pool.
	proc/pick_target()
		if(target_pool.len > 0)
			target = pick(target_pool)
			return 1
			target_pool.Cut()
		else
			return 0

	// Select targets with(out) this (assigned, special) role
	proc/filter_by_role(role, role_type=ASSIGNED_ROLE, invert=0)
		var/list/new_target_pool=new()
		for(var/datum/mind/possible_target in target_pool)
			if(ishuman(possible_target.current))
				var/matches = (role_type ? possible_target.special_role : possible_target.assigned_role) == role
				if(!invert)
					matches=!matches
				if(matches)
					new_target_pool+=possible_target
		target_pool=new_target_pool

	/*
	.. function:: filter_by_antag_role(role_id=null, invert=0)
		:param string role_id:
			The ID of the antag_role to select, or null to find minds with ANY antag_role set.
		:param int invert:
			Instead of finding those with the given role_id, we find those WITHOUT the role_id.
	*/
	proc/filter_by_antag_role(role_id=null, invert=0)
		var/list/new_target_pool = list()
		for(var/datum/mind/possible_target in target_pool)
			if(ishuman(possible_target.current))
				var/matches = (possible_target.antag_roles.len>0 && (role_id == null || role_id in possible_target.antag_roles))
				if(invert)
					matches=!matches
				if(matches)
					new_target_pool+=possible_target
		target_pool=new_target_pool

