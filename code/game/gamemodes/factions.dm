/**
* Factions
*
* N3X15 HERE, ACTUALLY MAKING USE OF THIS SHIT NOW
*
*/

/faction
	var/name		// the name of the faction
	var/desc		// small paragraph explaining the traitor faction

	var/list/restricted_species = list() // only members of these species can be recruited.
	var/list/minds = list() 	// a list of mind datums that belong to this faction
	var/max_op = 0		// the maximum number of members a faction can have (0 for no max)

	var/list/items_wanted=list()

	// Used for group objectives (e.g. cults)
	var/list/objectives=list()

// Return 1 on success, 0 on failure.
/faction/proc/OnPostSetup()
	return 1

// Create objectives here.
/faction/proc/ForgeObjectives()
	return

// Utility that does all the common stuff.
/faction/proc/AppendObjective(var/objective_type,var/duplicates=0,var/text=null)
	if(!duplicates && locate(objective_type) in objectives)
		return
	var/datum/objective/O
	if(text)
		O = new objective_type(src,text)
	else
		O = new objective_type(src)
	if(O.PostAppend())
		objectives += O
		//antag.objectives += O
		return 1
	return 0

/* ----- Begin defining miscellaneous factions ------ */

/faction/Wizard
	name = "Wizards Federation"
	desc = "The <b>Wizards Federation</b> is a mysterious organization of magically-talented individuals who act as an equal collective, and have no heirarchy. It is unknown how the wizards \
			are even able to communicate; some suggest a form of telepathic hive-mind. Not much is known about the wizards or their philosphies and motives. They appear to attack random \
			civilian, corporate, planetary, orbital, pretty much any sort of organized facility they come across. Members of the Wizards Federation are considered amongst the most dangerous \
			individuals in the known universe, and have been labeled threats to humanity by most governments. As such, they are enemies of both Nanotrasen and the Syndicate."

/faction/cult
	name = "The Cult of the Elder Gods"
	desc = "<b>The Cult of the Elder Gods</b> is highly untrusted but otherwise elusive religious organization bent on the revival of the so-called \"Elder Gods\" into the mortal realm. Despite their obvious dangeorus practices, \
			no confirmed reports of violence by members of the Cult have been reported, only rumor and unproven claims. Their nature is unknown, but recent discoveries have hinted to the possibility \
			of being able to de-convert members of this cult through what has been dubbed \"religious warfare\"."


// These can maybe be added into a game mode or a mob?

/faction/exolitics
	name = "Exolitics United"
	desc = "The <b>Exolitics</b> are an ancient alien race with an energy-based anatomy. Their culture, communication, morales and knowledge is unknown. They are so radically different to humans that their \
			attempts of communication with other life forms is completely incomprehensible. Members of this alien race are capable of broadcasting subspace transmissions from their bodies. \
			The religious leaders of the Tiger Cooperative claim to have the technology to decypher and interpret their messages, which have been confirmed as religious propaganda. Their motives are unknown \
			but they are otherwise not considered much of a threat to anyone. They are virtually indestructable because of their nonphysical composition, and have the frighetning ability to make anything stop existing in a second."
