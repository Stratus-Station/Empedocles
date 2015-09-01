///////////////////////////////////
// Antag Datum
///////////////////////////////////
var/list/possible_changeling_IDs = list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")

/antag_role/changeling
	name="Changeling"
	id="changeling"
	flags = ROLE_MIXABLE | ROLE_ADDITIVE
	special_role="Changeling"
	be_flag = BE_CHANGELING
	protected_jobs = SILICON_JOBS
	protected_antags = list("borer")

	min_players=1
	max_players=4

	// From /antag_role/changeling, which this replaces.
	var/list/absorbed_dna = list()
	var/absorbedcount = 0
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/honorific = "Broken"
	var/changeling_id = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 5
	var/purchasedpowers = list()
	var/mimicing = ""

/antag_role/changeling/New(var/datum/mind/M=null,var/antag_role/changeling/parent=null)
	..()
	if(config.protect_roles_from_antagonist)
		protected_jobs |= SECURITY_JOBS

/antag_role/changeling/calculateRoleNumbers()
	min_players=1 + round(ticker.mode.num_players() / 10)
	max_players=min_players+2
	return 1

/antag_role/changeling/OnPostSetup()
	if(!..()) return 0
	antag.current.make_changeling()
	antag.special_role = "Changeling"
	return 1

/antag_role/changeling/Drop()
	..()

	// Remove all the verbs we've added.
	antag.current.verbs += /antag_role/changeling/proc/EvolutionMenu

	for(var/datum/power/changeling/P in purchasedpowers)
		if(P.isVerb)
			antag.current.verbs -= P.verbpath

	antag << "<FONT color='red' size=3><B>You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!</B></FONT>"

/antag_role/changeling/proc/GetChangelingID()
	return "[honorific] [changeling_id]"

/antag_role/changeling/PreMindTransfer(var/datum/mind/M)
	M.current.verbs -= /antag_role/changeling/proc/EvolutionMenu
	M.current.remove_changeling_powers()

/antag_role/changeling/PostMindTransfer(var/datum/mind/M)
	antag.current.make_changeling()
	if(antag.current.gender == FEMALE)
		honorific = "Ms."
	else
		honorific = "Mr."

	// Only set ID once.
	if(!changeling_id)
		if(possible_changeling_IDs.len)
			changeling_id = pick(possible_changeling_IDs)
			possible_changeling_IDs -= changeling_id
		else
			changeling_id = rand(1,999)

/antag_role/changeling/ForgeObjectives()
	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/datum/objective/absorb/absorb_objective = AppendObjective(/datum/objective/absorb)
	absorb_objective.gen_amount_goal(2, 3)

	AppendObjective(/datum/objective/assassinate, duplicate=1)
	AppendObjective(/datum/objective/steal, duplicate=1)
	if(pick(80))
		AppendObjective(/datum/objective/escape)
	else
		AppendObjective(/datum/objective/survive)

/antag_role/changeling/Greet(var/you_are=1)
	if(you_are)
		antag.current << "<B>\red You are a changeling!</B>"
	antag.current << "<b>\red Use say \":g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them.</b>"
	antag.current << "<B>You must complete the following tasks:</B>"

	if (antag)
		if (antag.assigned_role == "Clown")
			antag.current << "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself."
			antag.current.dna.SetSEState(CLUMSYBLOCK,0)
			antag.current.mutations.Remove(M_CLUMSY)

/antag_role/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges+chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage-1)

/antag_role/changeling/proc/GetDNA(var/dna_owner)
	var/datum/dna/chosen_dna
	for(var/datum/dna/DNA in absorbed_dna)
		if(dna_owner == DNA.real_name)
			chosen_dna = DNA
			break
	return chosen_dna

/antag_role/changeling/DeclareAll()
	world << "<FONT size = 2><B>The changelings were:</B></FONT>"
	for(var/datum/mind/mind in minds)
		var/antag_role/R=mind.antag_roles[id]
		R.Declare()

/antag_role/changeling/Declare()
	var/changelingwin = 1

	var/text = "<br><br>[antag.key] was [antag.name] ("
	if(antag.current)
		if(antag.current.stat == DEAD)
			text += "died"
		else
			text += "survived"
		if(antag.current.real_name != antag.name)
			text += " as [antag.current.real_name]"
	else
		text += "body destroyed"
		changelingwin = 0
	text += ")"

	text += {"
<b>Changeling ID:</b> [GetChangelingID()].
<b>Genomes Absorbed:</b> [absorbedcount]"}

	if(antag.objectives.len)
		var/count = 1
		for(var/datum/objective/objective in antag.objectives)
			if(objective.check_completion())
				text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
				feedback_add_details("changeling_objective","[objective.type]|SUCCESS")
			else
				text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
				feedback_add_details("changeling_objective","[objective.type]|FAIL")
				changelingwin = 0
			count++

	if(changelingwin)
		text += "<br><font color='green'><B>The changeling was successful!</B></font>"
		feedback_add_details("changeling_success","SUCCESS")
	else
		text += "<br><font color='red'><B>The changeling has failed.</B></font>"
		feedback_add_details("changeling_success","FAIL")

	world << text

/antag_role/changeling/EditMemory(var/datum/mind/M)
	var/datum/role_controls/RC = ..(M)
	if (M.GetRole(id))
		if (objectives.len==0)
			RC.warnings += "Objectives are empty!</em> <a href='?src=\ref[src];mind=\ref[M];auto_objectives=[id]'>Randomize!</a>"
		var/antag_role/changeling/changeling=M.GetRole(id)
		if(changeling && changeling.absorbed_dna.len && (M.current.real_name != changeling.absorbed_dna[1]) )
			RC.controls["Appearance:"]="<a href='?src=\ref[src];mind=\ref[M];initialdna=1'>Transform to initial appearance.</a>"
	return RC

/antag_role/changeling/RoleTopic(href, href_list, var/datum/mind/M)
	if("initialdna" in href_list)
		var/antag_role/changeling/changeling = M.GetRole("changeling")
		if( !changeling || !changeling.absorbed_dna.len )
			usr << "\red Resetting DNA failed!"
		else
			M.current.dna = changeling.absorbed_dna[1]
			M.current.real_name = M.current.dna.real_name
			M.current.UpdateAppearance()
			domutcheck(M.current, null)