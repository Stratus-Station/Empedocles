
	var/text = ""

	if (istype(current, /mob/living/carbon/human) || istype(current, /mob/living/carbon/monkey) || istype(current, /mob/living/simple_animal/construct))
		/mob/living/simple_animal/borer
		/** HAS BORER **/
		text = "Has Borer"
		text = "<i><b>[text]</b></i>: "
		var/mob/living/simple_animal/borer/B = current.has_brain_worms()
		if(B)
			text += "<span class='danger'>[formatPlayerPanel(B,B.ckey)]</span>"
		else
			text += "NO"
		sections["hasborer"] = text
		/** REVOLUTION ***/
		text = "revolution"
		if (ticker.mode.config_tag=="revolution")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (assigned_role in command_positions)
			text += "<b>HEAD</b>|officer|employee|headrev|rev"
		else if (assigned_role in list("Security Officer", "Detective", "Warden"))
			text += "head|<b>OFFICER</b>|employee|headre|rev"
		else if (src in ticker.mode.head_revolutionaries)

			// AUTOFIXED BY fix_string_idiocy.py
			// C:\Users\Rob\\documents\\\projects\vgstation13\code\\datums\\mind.dm:137: text = "head|officer|<a href='?src=\ref[src];revolution=clear'>employee</a>|<b>HEADREV</b>|<a href='?src=\ref[src];revolution=rev'>rev</a>"
			text = {"head|officer|<a href='?src=\ref[src];revolution=clear'>employee</a>|<b>HEADREV</b>|<a href='?src=\ref[src];revolution=rev'>rev</a>
				<br>Flash: <a href='?src=\ref[src];revolution=flash'>give</a>"}
			// END AUTOFIX
			var/list/L = current.get_contents()
			var/obj/item/device/flash/flash = locate() in L
			if (flash)
				if(!flash.broken)
					text += "|<a href='?src=\ref[src];revolution=takeflash'>take</a>."
				else
					text += "|<a href='?src=\ref[src];revolution=takeflash'>take</a>|<a href='?src=\ref[src];revolution=repairflash'>repair</a>."
			else
				text += "."

			text += " <a href='?src=\ref[src];revolution=reequip'>Reequip</a> (gives traitor uplink)."
			if (objectives.len==0)
				text += "<br>Objectives are empty! <a href='?src=\ref[src];revolution=autoobjectives'>Set to kill all heads</a>."
		else if (src in ticker.mode.revolutionaries)
			text += "head|officer|<a href='?src=\ref[src];revolution=clear'>employee</a>|<a href='?src=\ref[src];revolution=headrev'>headrev</a>|<b>REV</b>"
		else
			text += "head|officer|<b>EMPLOYEE</b>|<a href='?src=\ref[src];revolution=headrev'>headrev</a>|<a href='?src=\ref[src];revolution=rev'>rev</a>"
		sections["revolution"] = text

		/** CULT ***/
		text = "cult"
		if (ticker.mode.config_tag=="cult")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (assigned_role in command_positions)
			text += "<b>HEAD</b>|officer|employee|cultist"
		else if (assigned_role in list("Security Officer", "Detective", "Warden"))
			text += "head|<b>OFFICER</b>|employee|cultist"
		else if (src in ticker.mode.cult)

			// AUTOFIXED BY fix_string_idiocy.py
			// C:\Users\Rob\\documents\\\projects\vgstation13\code\\datums\\mind.dm:169: text += "head|officer|<a href='?src=\ref[src];cult=clear'>employee</a>|<b>CULTIST</b>"
			text += {"head|officer|<a href='?src=\ref[src];cult=clear'>employee</a>|<b>CULTIST</b>
				<br>Give <a href='?src=\ref[src];cult=tome'>tome</a>|<a href='?src=\ref[src];cult=amulet'>amulet</a>."}
			// END AUTOFIX
/*
			if (objectives.len==0)
				text += "<br>Objectives are empty! Set to sacrifice and <a href='?src=\ref[src];cult=escape'>escape</a> or <a href='?src=\ref[src];cult=summon'>summon</a>."
*/
		else
			text += "head|officer|<b>EMPLOYEE</b>|<a href='?src=\ref[src];cult=cultist'>cultist</a>"
		sections["cult"] = text

		/** WIZARD ***/
		text = "wizard"
		if (ticker.mode.config_tag=="wizard")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.wizards)

			// AUTOFIXED BY fix_string_idiocy.py
			// C:\Users\Rob\\documents\\\projects\vgstation13\code\\datums\\mind.dm:185: text += "<b>YES</b>|<a href='?src=\ref[src];wizard=clear'>no</a>"
			text += {"<b>YES</b>|<a href='?src=\ref[src];wizard=clear'>no</a>
				<br><a href='?src=\ref[src];wizard=lair'>To lair</a>, <a href='?src=\ref[src];common=undress'>undress</a>, <a href='?src=\ref[src];wizard=dressup'>dress up</a>, <a href='?src=\ref[src];wizard=name'>let choose name</a>."}
			// END AUTOFIX
			if (objectives.len==0)
				text += "<br>Objectives are empty! <a href='?src=\ref[src];wizard=autoobjectives'>Randomize!</a>"
		else
			text += "<a href='?src=\ref[src];wizard=wizard'>yes</a>|<b>NO</b>"
		sections["wizard"] = text

		/** CHANGELING ***/
		text = "changeling"
		if (ticker.mode.config_tag=="changeling" || ticker.mode.config_tag=="traitorchan")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.changelings)
			text += "<b>YES</b>|<a href='?src=\ref[src];changeling=clear'>no</a>"
			if (objectives.len==0)
				text += "<br>Objectives are empty! <a href='?src=\ref[src];changeling=autoobjectives'>Randomize!</a>"
			if( changeling && changeling.absorbed_dna.len && (current.real_name != changeling.absorbed_dna[1]) )
				text += "<br><a href='?src=\ref[src];changeling=initialdna'>Transform to initial appearance.</a>"
			if( changeling )
				text += "<br><a href='?src=\ref[src];changeling=set_genomes'>[changeling.geneticpoints] genomes</a>"
		else
			text += "<a href='?src=\ref[src];changeling=changeling'>yes</a>|<b>NO</b>"
//			var/datum/game_mode/changeling/changeling = ticker.mode
//			if (istype(changeling) && changeling.changelingdeath)
//				text += "<br>All the changelings are dead! Restart in [round((changeling.TIME_TO_GET_REVIVED-(world.time-changeling.changelingdeathtime))/10)] seconds."
		sections["changeling"] = text

		/** VAMPIRE ***/
		text = "vampire"
		if (ticker.mode.config_tag=="vampire")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.vampires)
			text += "<b>YES</b>|<a href='?src=\ref[src];vampire=clear'>no</a>"
			if (objectives.len==0)
				text += "<br>Objectives are empty! <a href='?src=\ref[src];vampire=autoobjectives'>Randomize!</a>"
		else
			text += "<a href='?src=\ref[src];vampire=vampire'>yes</a>|<b>NO</b>"
		/** ENTHRALLED ***/
		text += "<br><i><b>enthralled</b></i>: "
		if(src in ticker.mode.enthralled)
			text += "<b><font color='#FF0000'>YES</font></b>|no"
		else
			text += "yes|<b>NO</b>"
		sections["vampire"] = text

		/** NUCLEAR ***/
		text = "nuclear"
		if (ticker.mode.config_tag=="nuclear")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.syndicates)

			// AUTOFIXED BY fix_string_idiocy.py
			// C:\Users\Rob\\documents\\\projects\vgstation13\code\\datums\\mind.dm:217: text += "<b>OPERATIVE</b>|<a href='?src=\ref[src];nuclear=clear'>nanotrasen</a>"
			text += {"<b>OPERATIVE</b>|<a href='?src=\ref[src];nuclear=clear'>nanotrasen</a>
				<br><a href='?src=\ref[src];nuclear=lair'>To shuttle</a>, <a href='?src=\ref[src];common=undress'>undress</a>, <a href='?src=\ref[src];nuclear=dressup'>dress up</a>."}
			// END AUTOFIX
			var/code
			for (var/obj/machinery/nuclearbomb/bombue in machines)
				if (length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
					code = bombue.r_code
					break
			if (code)
				text += " Code is [code]. <a href='?src=\ref[src];nuclear=tellcode'>tell the code.</a>"
		else
			text += "<a href='?src=\ref[src];nuclear=nuclear'>operative</a>|<b>NANOTRASEN</b>"
		sections["nuclear"] = text

	/** TRAITOR ***/
	text = "traitor"
	if (ticker.mode.config_tag=="traitor" || ticker.mode.config_tag=="traitorchan")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if (src in ticker.mode.traitors)
		text += "<b>TRAITOR</b>|<a href='?src=\ref[src];traitor=clear'>loyal</a>"
		if (objectives.len==0)
			text += "<br>Objectives are empty! <a href='?src=\ref[src];traitor=autoobjectives'>Randomize</a>!"
	else
		text += "<a href='?src=\ref[src];traitor=traitor'>traitor</a>|<b>LOYAL</b>"
	sections["traitor"] = text

	/** MONKEY ***/
	if (istype(current, /mob/living/carbon))
		text = "monkey"
		if (ticker.mode.config_tag=="monkey")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (istype(current, /mob/living/carbon/human))
			text += "<a href='?src=\ref[src];monkey=healthy'>healthy</a>|<a href='?src=\ref[src];monkey=infected'>infected</a>|<b>HUMAN</b>|other"
		else if (istype(current, /mob/living/carbon/monkey))
			var/found = 0
			for(var/datum/disease/D in current.viruses)
				if(istype(D, /datum/disease/jungle_fever)) found = 1

			if(found)
				text += "<a href='?src=\ref[src];monkey=healthy'>healthy</a>|<b>INFECTED</b>|<a href='?src=\ref[src];monkey=human'>human</a>|other"
			else
				text += "<b>HEALTHY</b>|<a href='?src=\ref[src];monkey=infected'>infected</a>|<a href='?src=\ref[src];monkey=human'>human</a>|other"

		else
			text += "healthy|infected|human|<b>OTHER</b>"
		sections["monkey"] = text


	/** SILICON ***/

	if (istype(current, /mob/living/silicon))
		text = "silicon"
		if (ticker.mode.config_tag=="malfunction")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if (istype(current, /mob/living/silicon/ai))
			if (src in ticker.mode.malf_ai)
				text += "<b>MALF</b>|<a href='?src=\ref[src];silicon=unmalf'>not malf</a>"
			else
				text += "<a href='?src=\ref[src];silicon=malf'>malf</a>|<b>NOT MALF</b>"
		var/mob/living/silicon/robot/robot = current
		if (istype(robot) && robot.emagged)
			text += "<br>Cyborg: Is emagged! <a href='?src=\ref[src];silicon=unemag'>Unemag!</a><br>0th law: [robot.laws.zeroth]"
		var/mob/living/silicon/ai/ai = current
		if (istype(ai) && ai.connected_robots.len)
			var/n_e_robots = 0
			for (var/mob/living/silicon/robot/R in ai.connected_robots)
				if (R.emagged)
					n_e_robots++
			text += "<br>[n_e_robots] of [ai.connected_robots.len] slaved cyborgs are emagged. <a href='?src=\ref[src];silicon=unemagcyborgs'>Unemag</a>"
		sections["malfunction"] = text

	if (ticker.mode.config_tag == "traitorchan")
		if (sections["traitor"])
			out += sections["traitor"]+"<br>"
		if (sections["changeling"])
			out += sections["changeling"]+"<br>"
		sections -= "traitor"
		sections -= "changeling"
	else
		if (sections[ticker.mode.config_tag])
			out += sections[ticker.mode.config_tag]+"<br>"
		sections -= ticker.mode.config_tag
	for (var/i in sections)
		if (sections[i])
			out += sections[i]+"<br>"


	if (((src in ticker.mode.head_revolutionaries) || \
		(src in ticker.mode.traitors)              || \
		(src in ticker.mode.syndicates))           && \
		istype(current,/mob/living/carbon/human)      )

		text = "Uplink: <a href='?src=\ref[src];common=uplink'>give</a>"
		var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
		var/crystals
		if (suplink)
			crystals = suplink.uses
		if (suplink)
			text += "|<a href='?src=\ref[src];common=takeuplink'>take</a>"
			if (usr.client.holder.rights & R_FUN)
				text += ", <a href='?src=\ref[src];common=crystals'>[crystals]</a> crystals"
			else
				text += ", [crystals] crystals"
		text += "." //hiel grammar
		out += text

	/** ERT ***/
	if (istype(current, /mob/living/carbon))
		text = "Emergency Response Team"
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.ert)
			text += "<b>YES</b>|<a href='?src=\ref[src];resteam=clear'>no</a>"
		else
			text += "<a href='?src=\ref[src];resteam=resteam'>yes</a>|<b>NO</b>"
		sections["resteam"] = text

	/** DEATHSQUAD ***/
	if (istype(current, /mob/living/carbon))
		text = "Death Squad"
		text = "<i><b>[text]</b></i>: "
		if (src in ticker.mode.deathsquad)
			text += "<b>YES</b>|<a href='?src=\ref[src];dsquad=clear'>no</a>"
		else
			text += "<a href='?src=\ref[src];dsquad=dsquad'>yes</a>|<b>NO</b>"
		sections["dsquad"] = text

	out += {"<br>
		<b>Strike Teams:</b><br>
		[sections["resteam"]]<br>
		[sections["dsquad"]]<br>
		<br>"}

	out += {"<br>
		<b>Memory:</b>
		<br>[memory]
		<br><a href='?src=\ref[src];memory_edit=1'>Edit memory</a>
		<br>Objectives:<br>"}

	if (objectives.len == 0)
		out += "EMPTY<br>"
	else
		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			out += "<B>[obj_count]</B>: [objective.explanation_text] <a href='?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='?src=\ref[src];obj_delete=\ref[objective]'>Delete</a> <a href='?src=\ref[src];obj_completed=\ref[objective]'><font color=[objective.completed ? "green" : "red"]>Toggle Completion</font></a><br>"
			obj_count++