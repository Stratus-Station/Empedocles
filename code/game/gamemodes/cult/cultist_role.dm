///////////////////////////////////
// Antag Datum
///////////////////////////////////
/antag_role/group/cultist
	name="Cultist"
	id="cultist"
	flags = 0
	protected_jobs = list("Chaplain","AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Internal Affairs Agent", "Mobile MMI")
	special_role="Cultist"
	be_flag = BE_CULTIST

	min_players = 4 // 3
	max_players = 4

	// Minds sacrificed.
	var/list/sacrificed=list()

	available_factions = list("The Cult of the Elder Gods","The Church of the Cleansed")

/antag_role/group/cultist/calculateRoleNumbers()
	return

/antag_role/group/cultist/OnPostSetup()
	Equip()
	GrantRune()
	update_cult_icons_added(antag)
	return 1

/antag_role/group/cultist/proc/GrantRune()
	ticker.mode.grant_runeword(antag.current)

/antag_role/group/cultist/Drop()
	..()
	var/faction/cult/cult = faction
	antag.current << cult.deconvert_msg
	antag.memory = ""
	update_cult_icons_removed(antag)
	log_admin("[antag.current] ([ckey(antag.current.key)] has been deconverted from the cult")

/antag_role/group/cultist/proc/MemorizeCultObjectives()
	var/text=""
	for(var/obj_count = 1,obj_count <= faction.objectives.len,obj_count++)
		var/datum/group_objective/O = faction.objectives[obj_count]
		text +=  "<B>Objective #[obj_count]</B>: [O.explanation_text]"
	text += "The convert rune is join blood self."
	antag.current << text
	antag.memory += "[text]<BR>"


/antag_role/group/cultist/proc/Equip()
	if (antag)
		if (antag.assigned_role == "Clown")
			antag.current << "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself."
			antag.current.mutations.Remove(M_CLUMSY)
			antag.current.dna.SetSEState(CLUMSYBLOCK,0)

	var/obj/item/weapon/paper/talisman/supply/T = new(antag.current)
	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	var/where = antag.current:equip_in_one_of_slots(T, slots, EQUIP_FAILACTION_DROP)
	if (!where)
		antag.current << "Unfortunately, you weren't able to get a talisman. This is very bad and you should adminhelp immediately."
	else
		antag.current << "You have a talisman in your [where], one that will help you start the cult on this station. Use it well and remember - there are others."
		antag.current.update_icons()
		return 1

/antag_role/group/cultist/Greet(you_are=1)
	var/faction/cult/cult=faction
	cult.Greet(antag.current)

	MemorizeCultObjectives()


/antag_role/group/cultist/DeclareAll()
	var/text = ""
	if(objectives.len)
		text += "<br /><b>The cultists' objectives were:</b>"
		for(var/obj_count=1, obj_count <= faction.objectives.len, obj_count++)
			var/datum/group_objective/objective = faction.objectives[obj_count]
			text += "<br />&nbsp;&nbsp;<b>Objective #[obj_count]:</b> [objective.declare()]"

	world << text + "<br /><B>The cultists were:</B>"
	for(var/datum/mind/mind in minds)
		var/antag_role/R=mind.antag_roles[id]
		R.Declare()

/antag_role/group/cultist/Declare()
	var/text= "<br>[antag.key] was [antag.name] ("
	if(antag.current)
		if(antag.current.stat == DEAD)
			text += "died"
		else
			text += "survived"
		if(antag.current.real_name != antag.name)
			text += " as [antag.current.real_name]"
	else
		text += "body destroyed"
	text += ")"

	world << text

/antag_role/group/cultist/EditMemory(var/datum/mind/M)
	var/datum/role_controls/RC = ..(M)
	var/antag_role/group/cultist/C = M.GetRole(id)
	RC.controls = list()
	if (C)
		if (C.objectives.len==0)
			RC.warnings += "Objectives are empty!</em> <a href='?src=\ref[src];mind=\ref[M];auto_objectives=[id]'>Randomize!</a>"
		RC.controls["Role:"] = "<a href='?src=\ref[M];remove_role=[id]'>Cultist</a>"
		if (M.assigned_role in command_positions)
			RC.controls["Role:"]="<b>HEAD</b> (Cannot remove role)"
		RC.controls["Equipment:"]={"<ul>
			<li>Give <a href='?src=\ref[src];mind=\ref[M];give=tome'>tome</a></li>
			<li>Give <a href='?src=\ref[src];mind=\ref[M];give=amulet'>amulet</a></li>
		</ul>"}
	else
		RC.controls["Role:"] = "<a href='?src=\ref[M];assign_role=[id]'>Employee</a>"
		if (M.assigned_role in SECURITY_JOBS)
			RC.controls["Role:"]="<b>OFFICER</b> (Cannot assign role)"
	return RC

/antag_role/group/cultist/RoleTopic(href, href_list, var/datum/mind/M)
	if("give" in href_list)
		switch(href_list["give"])
			if("tome")
				var/mob/living/carbon/human/H = M.current
				if (istype(H))
					var/obj/item/weapon/tome/T = new(H)

					var/list/slots = list (
						"backpack" = slot_in_backpack,
						"left pocket" = slot_l_store,
						"right pocket" = slot_r_store,
						"left hand" = slot_l_hand,
						"right hand" = slot_r_hand,
					)
					var/where = H.equip_in_one_of_slots(T, slots)
					if (!where)
						usr << "\red Spawning tome failed!"
					else
						H << "A tome, a message from your new master, appears in your [where]."

			if("amulet")
				var/antag_role/group/cultist/cultist = M.GetRole("cultist")
				if (!cultist.Equip())
					usr << "\red Spawning amulet failed!"