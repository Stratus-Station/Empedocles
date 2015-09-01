
/faction/cult
	var/deconvert_msg = "Deconvert message here."
	var/summon_objective = null
	var/godname = "God Name"

/faction/cult/ForgeObjectives()
	if(summon_objective && prob(50))
		objectives += new summon_objective(src)
	else
		objectives += new /datum/group_objective/cult/survive(src,5,7)
	objectives += new /datum/group_objective/targetted/sacrifice(src)

/faction/cult/proc/Greet(var/mob/M)
	// Cult greetings go here.
	return

/faction/cult/narsie
	name = "The Cult of the Elder Gods"
	desc = "<b>The Cult of the Elder Gods</b> is highly untrusted but otherwise elusive religious organization bent on the revival of the so-called \"Elder Gods\" into the mortal realm. Despite their obvious dangeorus practices, \
			no confirmed reports of violence by members of the Cult have been reported, only rumor and unproven claims. Their nature is unknown, but recent discoveries have hinted to the possibility \
			of being able to de-convert members of this cult through what has been dubbed \"religious warfare\"."
	deconvert_msg = "\red <FONT size = 3><B>An unfamiliar white light flashes through your mind, cleansing the taint of the dark one and the memories of your time as his servant with it.</B></FONT>"
	godname = "Dark One"
	summon_objective = /datum/group_objective/cult/summon

/faction/cult/narsie/Greet(var/mob/M)
	M << "<span class='sinister'>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</span>"
	M << "<span class='sinister'>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</span>"

///////////////////////////////////////////
// CULT OF THE CLEAN
/faction/cult/mrclean
	name = "The Church of the Cleansed"
	desc = {"<b>The Church of the Cleansed</b> is a new cult, having its origins in an ancient guild of janitors looking for easier ways to clean things.  Not much is known about them, but
			reports suggest they are just as dangerous and fanatical as The Cult of the Elder Gods."}
	deconvert_msg = "\red <FONT size = 3><B>An uneasy filthiness washes over you, cleansing the taint of the Clean One and the memories of your time as his servant with it.</B></FONT>"
	godname = "Clean One"
	summon_objective = /datum/group_objective/cult/summon/mrclean

/faction/cult/narsie/Greet(var/mob/M)
	M << "<span class='sinister'>You feel yourself cleansed of the corrupting thoughts of the Materium, yet sense more must be cleansed.</span>"
	M << "<span class='sinister'>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Clean One above all else.</span>"