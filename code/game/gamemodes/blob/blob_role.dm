///////////////////////////////////
// Antag Datum
///////////////////////////////////
/antag_role/blob
	name="Blob"
	id="blob"
	flags = 0
	protected_jobs = SILICON_JOBS
	special_role="Blob"
	be_flag = BE_ALIEN

	var/const/cores_to_spawn = 1
	var/const/players_per_core = 30
	var/const/blob_point_rate = 3

	var/stage=0
	var/next_stage=-1

/antag_role/blob/calculateRoleNumbers()
	min_players = max(round(ticker.mode.num_players()/players_per_core, 1), 1)
	max_players = min_players

/antag_role/blob/OnPostSetup()
	log_game("[antag.key] (ckey) has been selected as a Blob")
	return 1

/antag_role/blob/ForgeObjectives()
	AppendObjective(/datum/objective/survive)

/antag_role/blob/proc/Pop()
	var/turf/location = null

	if(iscarbon(antag.current))
		location = get_turf(antag.current)
		if(location.z != 1 || istype(location, /turf/space))
			location = null
		antag.current.gib()


	if(antag && location)
		var/obj/effect/blob/core/core = new(location, 200, antag, blob_point_rate)
		if(core.overmind && core.overmind.mind)
			core.overmind.mind.name = antag.current.name

/antag_role/blob/process()
	if(next_stage > 0 && world.time > next_stage)
		stage++

		switch(stage)
			if(1)
				antag.current << "<span class='alert'>You feel tired and bloated.</span>"
				next_stage=world.time + rand(3000,6000) // 5-10 minutes to stage 1
			if(2)
				antag.current << "<span class='alert'>You feel like you are about to burst.  One minute left.</span>"
				next_stage=world.time + 600 // EXACTLY 1 minute to pop (stage 3)
			if(3)
				Pop()
				next_stage=-1 // Don't fuck with stages.
		if(ticker.mode.config_tag=="blob")
			ticker.mode:send_alert(stage)

	switch(stage)
		if(0)
			if(ticker.mode.intercept_sent)
				next_stage=world.time + rand(600,1200) // 1-2 minutes to stage 1.
		if(2 to 3)
			antag.current:overeatduration=600
			antag.current.mutations |= M_FAT
			antag.current.update_icons()

/antag_role/blob/Greet(you_are=1)
	antag.current << {"<B>\red You are infected by the Blob!</B>
<b>Your body is ready to give spawn to a new blob core which will eat this station.</b>
<b>Find a good location to spawn the core and then take control and overwhelm the station!</b>
<b>When you have found a location, wait until you spawn; this will happen automatically and you cannot speed up the process.</b>
<b>If you go outside of the station level, or in space, then you will die; make sure your location has lots of ground to cover.</b>"}

	stage=0

	log_admin("[antag.current.name] is infected with a blob.")


/antag_role/blob/DeclareAll()
	var/text = "<FONT size = 2><B>The blob[(minds.len > 1 ? "s were" : " was")]:</B></FONT>"
	for(var/datum/mind/mind in minds)
		var/antag_role/R=mind.GetRole(id)
		text += R.Declare()
	world << text

/antag_role/blob/Declare()
	var/win = 1
	var/text=""
	text += "<br /><B>[antag.current.key] was [antag.current.name].</B>"
	if(antag.current)
		text += "(Survived)"
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				text += "<br /><B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
				feedback_add_details("blob_objective","[objective.type]|SUCCESS")
			else
				text += "<br /><B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
				feedback_add_details("blob_objective","[objective.type]|FAIL")
				win = 0
			count++

	else
		text += "(Dead)"
		win = 0

	if(win)
		text += "<B>The blob was successful!<B>"
		feedback_add_details("blob_success","SUCCESS")
	else
		text += "<B>The blob has failed!<B>"
		feedback_add_details("blob_success","FAIL")