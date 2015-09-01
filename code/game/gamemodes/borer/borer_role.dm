///////////////////////////////////
// Antag Datum
///////////////////////////////////
/antag_role/borer
	name="Cortical Borer"
	id="borer"
	flags = ROLE_MIXABLE | ROLE_NEED_HOST
	protected_jobs = SILICON_JOBS
	special_role = "Borer"
	disallow_job = 1
	be_flag = BE_ALIEN

	var/list/found_vents[0]

/antag_role/borer/New(var/datum/mind/M=null,var/antag_role/borer/parent=null)
	..()

	// Transfer "static" data from parent.
	if(parent)
		found_vents=parent.found_vents
	else
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in world)
			if(!v.welded && v.z == STATION_Z && v.canSpawnMice==1) // No more spawning in atmos.  Assuming the mappers did their jobs, anyway.
				found_vents.Add(v)

/antag_role/borer/calculateRoleNumbers()
	// for every 10 players, get 1 borer, and for each borer, get a host
	// also make sure that there's at least one borer and one host
	min_players = max(ticker.mode.num_players() / 20 * 2, 2)
	max_players = min_players

/antag_role/borer/CanBeAssigned(var/datum/mind/M)
	return ..()

/antag_role/borer/OnPostSetup()
	if(!host) return 0

	// Pick a backup location to spawn at if we can't infest.
	var/spawn_loc
	if(found_vents.len)
		var/vent = pick(found_vents)
		found_vents.Remove(vent)
		spawn_loc=get_turf(vent)
	else
		spawn_loc=pick(xeno_spawn)

	var/mob/living/simple_animal/borer/M = new(spawn_loc,1) // loc, by_gamemode=0
	var/mob/original = antag.current
	antag.transfer_to(M)
	//M.clearHUD()

	M.perform_infestation(host)
	antag=M

	del(original)

	return 1

/antag_role/borer/ForgeObjectives()
	AppendObjective(/datum/objective/survive)

/antag_role/borer/Greet(you_are=1)
	if(you_are)
		antag << "<B>\red You are a Cortical Borer!</B>"

	var/i=0
	for(var/datum/objective/objective in antag.objectives)
		antag << "<B>Objective #[i++]</B>: [objective.explanation_text]"


/antag_role/borer/Declare()
	var/borerwin = 1
	if((antag.current) && istype(antag.current,/mob/living/simple_animal/borer))
		world << "<B>The borer was [antag.current.key].</B>"
		world << "<B>The last host was [antag.current:host.key].</B>"

		var/count = 1
		for(var/datum/objective/objective in antag.objectives)
			if(objective.check_completion())
				world << "<B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
				feedback_add_details("borer_objective","[objective.type]|SUCCESS")
			else
				world << "<B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
				feedback_add_details("borer_objective","[objective.type]|FAIL")
				borerwin = 0
			count++

	else
		borerwin = 0

	if(borerwin)
		world << "<B>The borer was successful!<B>"
		feedback_add_details("borer_success","SUCCESS")
	else
		world << "<B>The borer has failed!<B>"
		feedback_add_details("borer_success","FAIL")