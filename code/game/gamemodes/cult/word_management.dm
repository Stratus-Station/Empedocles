// N3X: Separated this out so child gamemodes can change the text or just the behavior.
/datum/game_mode/proc/teach_word_to(var/mob/cult_mob,word)
	var/wordexp = "[cultwords[word]] is [word]..."
	cult_mob << "\red You remember one thing from the dark teachings of your master... [wordexp]"
	cult_mob.mind.store_memory("<B>You remember that</B> [wordexp]", 0, 0)

/datum/game_mode/proc/grant_runeword(var/mob/cult_mob, var/word)
	if(!cultwords["travel"])
		runerandom()
	if (!word)
		word=pick(allwords)
	teach_word_to(cult_mob, word)

/datum/game_mode/cult/grant_runeword(var/mob/cult_mob, var/word)
	if (!word)
		if(startwords.len > 0)
			word=pick(startwords)
			startwords -= word
	..(cult_mob,word)
