/faction/vox_raiders
	name = "Vox Raiders"
	desc = {"<b>Vox Raiders</b> are a relatively new player on the galactic threat map.  Although many have shown up to work for NanoTrasen, other have taken up the old
		flag of piracy in order to get the things they desire."}

	var/list/spawnpoints=list()

/faction/vox_raiders/proc/GetNumAlive()
	var/num_alive=0
	var/check_return = 0
	if(ticker && istype(ticker.mode,/datum/game_mode/heist))
		check_return = 1
	for(var/datum/mind/vox in minds)
		var/antag_role/group/vox_raider/raider=vox.GetRole("raider")
		if(!vox.current)
			continue
		if(vox.current.stat == DEAD)
			continue
		if(check_return)
			if(get_area(raider.cortical_stack) != locate(/area/shuttle/vox/station))
				continue
		num_alive++
	return num_alive

/faction/vox_raiders/proc/GetNumLeftBehind()
	var/count=0
	for(var/datum/mind/vox in minds)
		var/antag_role/group/vox_raider/raider=vox.GetRole("raider")
		if(get_area(raider.cortical_stack) != locate(/area/shuttle/vox/station))
			count++
	return count

/faction/vox_raiders/ForgeObjectives()
	//Build a list of spawn points.
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "voxstart")
			spawnpoints += get_turf(L)
			del(L)
			continue

	//Commented out for testing.
	/* var/i = 1
	var/max_objectives = pick(2,2,2,3,3)
	var/list/objs = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		objs += O

		i++

	//-All- vox raids have these two objectives. Failing them loses the game.
	objs += new /datum/objective/heist/inviolate_crew
	objs += new /datum/objective/heist/inviolate_death */

	if(prob(25))
		objectives += new /datum/group_objective/targetted/heist/kidnap(src)
	objectives += new /datum/group_objective/heist/loot(src)
	objectives += new /datum/group_objective/heist/salvage(src)
	objectives += new /datum/group_objective/heist/inviolate_crew(src)
	objectives += new /datum/group_objective/heist/inviolate_death(src)