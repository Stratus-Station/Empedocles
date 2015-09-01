///////////////////////////////////
// Antag Datum
///////////////////////////////////
/antag_role/group/vox_raider
	name="Vox Raider"
	id="raider"
	flags = 0
	disallow_job = 1
	special_role = "Vox Raider"

	be_flag = BE_RAIDER

	min_players = 4
	max_players = 6

	// GROUP
	var/index=1
	var/list/turf/spawnpoints = list()

	var/obj/item/weapon/implant/cortical/cortical_stack

/antag_role/group/vox_raider/calculateRoleNumbers()
	return

/antag_role/group/vox_raider/OnPostSetup()
	Equip()
	update_cult_icons_added(antag)
	return 1

/antag_role/group/vox_raider/Drop()
	..()
	antag.current << "Your link to the Shoal has been severed."
	log_admin("[antag.current] ([ckey(antag.current.key)] has been de-linked from the Shoal. (Non-antag vox ahoy)")

/antag_role/group/vox_raider/proc/Equip(var/from_editmemory=0)

	var/mob/living/carbon/human/vox = antag.current
	if(!from_editmemory)
		antag.current.loc = pick(faction:spawnpoints)

		var/sounds = rand(2,8)
		var/i = 0
		var/newname = ""

		while(i<=sounds)
			i++
			newname += pick(list("ti","hi","ki","ya","ta","ha","ka","ya","chi","cha","kah"))

		vox.real_name = capitalize(newname)
		vox.name = vox.real_name
		antag.name = vox.name
	vox.age = rand(12,20)
	vox.dna.mutantrace = "vox"
	vox.set_species("Vox")
	vox.languages = list() // Removing language from chargen.
	vox.flavor_text = ""
	vox.add_language("Vox-pidgin")
	vox.h_style = "Short Vox Quills"
	vox.f_style = "Shaved"
	for(var/datum/organ/external/limb in vox.organs)
		limb.status &= ~(ORGAN_DESTROYED | ORGAN_ROBOT)
	vox.equip_vox_raider()

	cortical_stack = new(vox)
	cortical_stack.imp_in = src
	cortical_stack.implanted = 1
	var/datum/organ/external/affected = vox.get_organ("head")
	affected.implants += cortical_stack

	vox.regenerate_icons()

/antag_role/group/vox_raider/Greet(you_are=1)
	antag.current << {"\blue <B>You are a Vox Raider, fresh from the Shoal!</b>
The Vox are a race of cunning, sharp-eyed nomadic raiders and traders endemic to Tau Ceti and much of the unexplored galaxy. You and the crew have come to the Exodus for plunder, trade or both.
Vox are cowardly and will flee from larger groups, but corner one or find them en masse and they are vicious.
Use :V to voxtalk, :H to talk on your encrypted channel, and <b>don't forget to turn on your nitrogen internals!</b>"}

	MemorizeObjectives()

	Equip()


/antag_role/group/vox_raider/DeclareAll()
	var/text = ""
	if(objectives.len)
		text += "<br /><b>The vox raiders' objectives were:</b>"
		for(var/obj_count=1, obj_count <= faction.objectives.len, obj_count++)
			var/datum/group_objective/objective = faction.objectives[obj_count]
			text += "<br />&nbsp;&nbsp;<b>Objective #[obj_count]:</b> [objective.declare()]"

	text += "<br /><FONT size = 2><B>The raiders were:</B></FONT>"
	world << text
	for(var/datum/mind/mind in minds)
		var/antag_role/R=mind.antag_roles[id]
		R.Declare()

/antag_role/group/vox_raider/Declare()
	var/text= "<br>[antag.key] was [antag.name] ("
	if(antag.current)
		if (get_area(cortical_stack) != locate(/area/shuttle/vox/station))
			text += "left behind"
		else if(antag.current.stat == DEAD)
			text += "died"
		else
			text += "survived"
		if(antag.current.real_name != antag.name)
			text += " as [antag.current.real_name]"
	else
		text += "body destroyed"
	text += ")"

	world << text

/antag_role/group/vox_raider/RoleTopic(href, href_list, var/datum/mind/M)
	if("give" in href_list)
		switch(href_list["give"])
			if("gear")
				var/antag_role/group/vox_raider/raider = M.antag_roles[id]
				if (!raider.Equip(1))
					usr << "\red Spawning gear failed!"