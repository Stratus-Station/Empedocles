//////////////////////////////////////////////////
// Sacrifice some dude.
//////////////////////////////////////////////////

/datum/group_objective/targetted/sacrifice/New(var/antag_role/owner)
	..(owner)
	load_targets()
	filter_by_antag_role("cultist",1)
	filter_convertable()
	if(pick_target())
		explanation_text="Sacrifice [target.name], the [target.assigned_role]."
	else
		explanation_text="Sacrifice a non-cultist."

// Don't target people we can convert, unless no one is left.
/datum/group_objective/targetted/sacrifice/proc/filter_convertable()
	var/list/new_target_pool=list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(ishuman(possible_target.current))
			if(is_convertable_to_cult(possible_target))
				new_target_pool+=possible_target

	// If we just eliminated our target pool, allow sacrificing convertables.
	if(target_pool.len > 0)
		target_pool=new_target_pool

/datum/group_objective/targetted/sacrifice/check_completion()
	var/antag_role/group/cultist/cult = ticker.antag_types["cultist"]
	if(target)
		return target in cult.sacrificed
	else
		// Well, did we sacrifice SOMEONE?
		return (cult.sacrificed.len > 0)

/datum/group_objective/targetted/sacrifice/declare()
	var/antag_role/group/cultist/cult = ticker.antag_types["cultist"]
	var/explanation
	if(target in cult.sacrificed)
		explanation = "[explanation_text] <font color='green'><B>Success!</B></font>"
		feedback_add_details("cult_objective","cult_sacrifice|SUCCESS")
	else if(target && target.current)
		explanation = "[explanation_text] <font color='red'>Fail.</font>"
		feedback_add_details("cult_objective","cult_sacrifice|FAIL")
	else
		explanation = "[explanation_text] <font color='red'>Fail (Body Destroyed).</font>"
		feedback_add_details("cult_objective","cult_sacrifice|FAIL|GIBBED")
	return explanation

//////////////////////////////////////////////////
// Get X cultists off the station.
//////////////////////////////////////////////////
/datum/group_objective/cult/survive
	var/acolytes_needed=0
	var/acolytes_survived=0
/datum/group_objective/cult/survive/New(var/antag_role/parent,var/min_acolytes, var/max_acolytes)
	..(parent)
	acolytes_needed = rand(min_acolytes,max_acolytes)
	explanation_text = "Our knowledge must live on. Make sure at least [acolytes_needed] acolytes escape on the shuttle to spread their work on an another station."

/datum/group_objective/cult/survive/check_completion()
	acolytes_survived = 0
	for(var/datum/mind/cult_mind in group.minds)
		if (cult_mind.current && cult_mind.current.stat!=DEAD)
			var/area/A = get_area(cult_mind.current )
			if ( is_type_in_list(A, centcom_areas))
				acolytes_survived++
	return acolytes_survived>=acolytes_needed

/datum/group_objective/cult/survive/declare()
	var/explanation
	if(!check_completion())
		explanation = "[explanation_text] <font color='green'><B>Success!</B></font>"
		feedback_add_details("cult_objective","cult_survive|SUCCESS|[acolytes_needed]")
	else
		explanation = "[explanation_text] <font color='red'>Fail.</font>"
		feedback_add_details("cult_objective","cult_survive|FAIL|[acolytes_needed]")

	return explanation

//////////////////////////////////////////////////
// NAR-SIE TIME
//////////////////////////////////////////////////

// Making this flexible, so we can have "fun" objectives.
/datum/group_objective/cult/summon
	var/god_name = "Nar-Sie"
	var/god_type = /obj/machinery/singularity/narsie/large

/datum/group_objective/cult/summon/New(var/antag_role/parent)
	..(parent)
	explanation_text = "Summon [god_name]."

/datum/group_objective/cult/summon/proc/complete(var/obj/effect/rune/R)
	completed = 1
	var/turf/T = get_turf(R)
	del(R)
	new god_type(T)

/datum/group_objective/cult/summon/declare()
	var/explanation = explanation_text
	if(!check_completion())
		explanation += " <font color='green'><B>Success!</B></font>"
		feedback_add_details("cult_objective","cult_narsie|SUCCESS|[god_type]")
	else
		explanation += " <font color='red'>Fail.</font>"
		feedback_add_details("cult_objective","cult_narsie|FAIL|[god_type]")

	return explanation

/datum/group_objective/cult/summon/mrclean
	god_name = "The Clean One"
	god_type = /obj/machinery/singularity/narsie/large/clean