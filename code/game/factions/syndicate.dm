// Factions, members of the syndicate coalition:

/faction/syndicate

	var/list/alliances = list() // these alliances work together
	var/list/equipment = list() // associative list of equipment available for this faction and its prices
	var/friendly_identification	// 0 to 2, the level of identification of fellow operatives or allied factions
								// 0 - no identification clues
								// 1 - faction gives key words and phrases
								// 2 - faction reveals complete identity/job of other agents
	var/operative_notes // some notes to pass onto each operative

	var/uplink_contents			// the contents of the uplink


/* ----- Begin defining syndicate factions ------ */

/faction/syndicate/Cybersun_Industries
	name = "Cybersun Industries"
	desc = "<b>Cybersun Industries</b> is a well-known organization that bases its business model primarily on the research and development of human-enhancing computer \
			and mechanical technology. They are notorious for their aggressive corporate tactics, and have been known to subsidize the Gorlex Marauder warlords as a form of paid terrorism. \
			Their competent coverups and unchallenged mind-manipulation and augmentation technology makes them a large threat to Nanotrasen. In the recent years of \
			the syndicate coalition, Cybersun Industries have established themselves as the leaders of the coalition, succeededing the founding group, the Gorlex Marauders."

	alliances = list("MI13")
	friendly_identification = 1
	max_op = 3

	// Friendly to everyone. (with Tiger Cooperative too, only because they are a member of the coalition. This is the only reason why the Tiger Cooperative are even allowed in the coalition)

/faction/syndicate/Donk
	name = "Donk Corporation"
	desc = "<b>Donk.co</b> is led by a group of ex-pirates, who used to be at a state of all-out war against Waffle.co because of an obscure political scandal, but have recently come to a war limitation. \
			They now consist of a series of colonial governments and companies. They were the first to officially begin confrontations against Nanotrasen because of an incident where \
			Nanotrasen purposely swindled them out of a fortune, sending their controlled colonies into a terrible poverty. Their missions against Nanotrasen \
			revolve around stealing valuables and kidnapping and executing key personnel, ransoming their lives for money. They merged with a splinter-cell of Waffle.co who wanted to end \
			hostilities and formed the Gorlex Marauders."

	alliances = list("Gorlex Marauders")
	friendly_identification = 2
	operative_notes = "Most other syndicate operatives are not to be trusted, except fellow Donk members and members of the Gorlex Marauders. We do not approve of mindless killing of innocent workers; \"get in, get done, get out\" is our motto. Members of Waffle.co are to be killed on sight; they are not allowed to be on the station while we're around."

	// Neutral to everyone, friendly to Marauders

/faction/syndicate/Waffle
	name = "Waffle Corporation"
	desc = "<b>Waffle.co</b> is an interstellar company that produces the best waffles in the galaxy. Their waffles have been rumored to be dipped in the most exotic and addictive \
			drug known to man. They were involved in a political scandal with Donk.co, and have since been in constant war with them. Because of their constant exploits of the galactic \
			economy and stock market, they have been able to bribe their way into amassing a large arsenal of weapons of mass destruction. They target Nanotrasen because of their communistic \
			threat, and their economic threat. Their leaders often have a twisted sense of humor, often misleading and intentionally putting their operatives into harm for laughs.\
			A splinter-cell of Waffle.co merged with Donk.co and formed the Gorlex Marauders and have been a constant ally since. The Waffle.co has lost an overwhelming majority of its military to the Gorlex Marauders."

	alliances = list("Gorlex Marauders")
	friendly_identification = 2
	operative_notes = "Most other syndicate operatives are not to be trusted, except for members of the Gorlex Marauders. Do not trust fellow members of the Waffle.co (but try not to rat them out), as they might have been assigned opposing objectives. We encourage humorous terrorism against Nanotrasen; we like to see our operatives creatively kill people while getting the job done."

	// Neutral to everyone, friendly to Marauders