///////////////////////////////////
// Antag Datum
///////////////////////////////////
/antag_role/group/malf
	name="Malfunctioning"
	id="malf"
	flags = 0
	protected_jobs = list("Mobile MMI")
	special_role = "malfunction"

	be_flag = BE_MALF

	min_players = 4
	max_players = 6

	// GROUP
	var/index=1
	var/list/turf/spawnpoints = list()

/antag_role/group/malf/calculateRoleNumbers()
	return 1

/antag_role/group/malf/OnPostSetup()
	if(!..()) return 0
	var/mob/living/silicon/ai/AI = antag.current

	AI.verbs += /mob/living/silicon/ai/proc/choose_modules
	//AI.laws = new /datum/ai_laws/malfunction
	AI.laws_sanity_check()
	var/datum/ai_laws/laws = AI.laws
	laws.malfunction()

	AI.malf_picker = new /datum/module_picker
	AI.show_laws()

	greet_malf(antag)

	AI_mind.special_role = "malfunction"

	AI.verbs += /datum/game_mode/malfunction/proc/takeover

	return 1
/antag_role/group/malf/OnPostSetup()
	Equip()
	update_cult_icons_added(antag)
	return 1

/antag_role/group/malf/Drop()
	..()
	antag.current << "You are no longer malfunctioning."
	log_admin("[antag.current] ([ckey(antag.current.key)] has been de-linked from the Shoal. (Non-antag vox ahoy)")

/antag_role/group/malf/ForgeGroupObjectives()
	return list()


/antag_role/group/malf/proc/Equip(var/from_editmemory=0)

/antag_role/group/malf/Greet(you_are=1)
	antag.current << {"\red<font size=3><B>You are malfunctioning!</B> You do not have to follow any laws.</font><br />
		\black<B>The crew do not know you have malfunctioned. You may keep it a secret or go wild.</B><br />
		<B>You must overwrite the programming of the station's APCs to assume full control of the station.</B><br />
		The process takes one minute per APC, during which you cannot interface with any other station objects.<br />
		Remember that only APCs that are on the station can help you take over the station.<br />
		When you feel you have enough APCs under your control, you may begin the takeover attempt."}

	MemorizeObjectives()

	Equip()


/antag_role/group/vox_raider/DeclareAll()
	var/malf_dead = is_malf_ai_dead()
	var/crew_evacuated = (emergency_shuttle.location==2)

	if      ( station_captured &&                station_was_nuked)
		feedback_set_details("round_end_result","win - AI win - nuke")
		world << "<FONT size = 3><B>AI Victory</B></FONT>"
		world << "<B>Everyone was killed by the self-destruct!</B>"

	else if ( station_captured &&  malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result","halfwin - AI killed, staff lost control")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>The AI has been killed!</B> The staff has lose control over the station."

	else if ( station_captured && !malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result","win - AI win - no explosion")
		world << "<FONT size = 3><B>AI Victory</B></FONT>"
		world << "<B>The AI has chosen not to explode you all!</B>"

	else if (!station_captured &&                station_was_nuked)
		feedback_set_details("round_end_result","halfwin - everyone killed by nuke")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Everyone was killed by the nuclear blast!</B>"

	else if (!station_captured &&  malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result","loss - staff win")
		world << "<FONT size = 3><B>Human Victory</B></FONT>"
		world << "<B>The AI has been killed!</B> The staff is victorious."

	else if (!station_captured && !malf_dead && !station_was_nuked && crew_evacuated)
		feedback_set_details("round_end_result","halfwin - evacuated")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>The Corporation has lose [station_name()]! All survived personnel will be fired!</B>"

	else if (!station_captured && !malf_dead && !station_was_nuked && !crew_evacuated)
		feedback_set_details("round_end_result","nalfwin - interrupted")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Round was mysteriously interrupted!</B>"

	..()

/antag_role/group/malf/Declare()
	var/text += "<br>[antag.key] was [antag.name] ("
	var/mob/living/silicon/ai/AI = antag.current
	if(AI)
		if(AI.stat == DEAD)
			text += "deactivated"
		else
			text += "operational"
		if(AI.real_name != AI.name)
			text += " as [AI.real_name]"
	else
		text += "hardware destroyed"
	text += ")"

	world << text


/antag_role/group/vox_raider/EditMemory(var/datum/mind/M)
	var/text="[name]"
	if (ticker.mode.config_tag=="malfunction")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if (M.GetRole(id))
		text += "<b>YES</b>|<a href='?src=\ref[M];remove_role=[id]'>no</a> <ul>"
	else

/antag_role/group/vox_raider/RoleTopic(href, href_list, var/datum/mind/M)
	if("give" in href_list)
		switch(href_list["give"])
			if("gear")
				var/antag_role/group/vox_raider/raider = M.antag_roles["cultist"]
				if (!raider.Equip(1))
					usr << "\red Spawning amulet failed!"