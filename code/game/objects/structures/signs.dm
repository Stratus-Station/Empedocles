/*//////////////////////////////////////////
//			WARNING! ACHTUNG!			  //
//		WHEN YOU'RE MAKING A SIGN:		  //
//		REMEMBER TO USE \improper		  //
//	ONLY IF NAME IS CAPITALIZED AND 	  //
//ACTUALLY NOT PROPER; FAILURE TO DO THIS //
// WILL RESULT IN MESSAGES LIKE "The The  //
//	Periodic Table has been hit..."		  //
//	PLEASE REMEMBER THAT AND THANKS.	  //
//			HAVE A NICE DAY!			  //
*///////////////////////////////////////////

/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = ABOVE_WINDOW_LAYER


/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/sign/blob_act()
	qdel(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(isscrewdriver(tool) && !istype(src, /obj/structure/sign/double))
		to_chat(user, "You unfasten the sign with your [tool].")
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
		return
	else
		..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = W_CLASS_MEDIUM		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(isscrewdriver(tool) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel" || src.loc == null)
			return // We can get qdel'd if someone spams screwdrivers on signs before responding to the prompt.
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = WORLD_ICON_SIZE
			if("East")
				S.pixel_x = WORLD_ICON_SIZE
			if("South")
				S.pixel_y = -WORLD_ICON_SIZE
			if("West")
				S.pixel_x = -WORLD_ICON_SIZE
			else
				return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		to_chat(user, "You fasten \the [S] with your [tool].")
		qdel(src)
		return
	else
		..()

/obj/structure/sign/kick_act(mob/living/carbon/human/H)
	H.visible_message("<span class='danger'>[H] kicks \the [src]!</span>", "<span class='danger'>You kick \the [src]!</span>")

	if(prob(70))
		to_chat(H, "<span class='userdanger'>Ouch! That hurts!</span>")

		H.apply_damage(rand(5,7), BRUTE, pick(LIMB_RIGHT_LEG, LIMB_LEFT_LEG, LIMB_RIGHT_FOOT, LIMB_LEFT_FOOT))

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

//For efficiency station
/obj/structure/sign/map/efficiency
	name = "station map"
	desc = "A framed picture of the station."
	icon_state = "map_efficiency"

/obj/structure/sign/map/meta/left
	name = "station map"
	desc = "A framed picture of the station."
	icon_state = "map-left-MS"

/obj/structure/sign/map/meta/right
	name = "station map"
	desc = "A framed picture of the station."
	icon_state = "map-right-MS"

/obj/structure/sign/securearea
	name = "SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "\"To be robust is not an action or a way of life, but a mental state. Only those with the force of will strong enough to act during a crisis, saving friend from foe, acting when everyone else may think and act against you, are truly robust. Stay robust, my friends.\""
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developer's plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\"."
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/chemtable
	name = "The Periodic Table"
	desc = "A very colorful and detailed table of all the chemical elements you could blow up or burn down a chemistry laboratory with, titled 'The Space Periodic Table - To be continued'. Just the mere sight of it makes you feel smarter."
	icon_state = "periodic"

/obj/structure/sign/botany
	name = "HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "Science department"
	desc = "A direction sign, pointing out which way Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "Engineering department"
	desc = "A direction sign, pointing out which way Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "Security department"
	desc = "A direction sign, pointing out which way Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "Medical Bay"
	desc = "A direction sign, pointing out the direction of the medical bay."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "Escape Arm"
	desc = "A direction sign, pointing out which way escape shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/crime
	name = "CRIME DOES NOT PAY"
	desc = "A warning sign which suggests that you reconsider your poor life choices."
	icon_state = "crime"

/obj/structure/sign/chinese
	name = "incomprehensible sign"
	desc = "A sign written using traditional chinese characters. A native Sol Common speaker might understand it."

/obj/structure/sign/chinese/restricted_area
	icon_state = "CH_restricted_area"

/obj/structure/sign/chinese/caution
	icon_state = "CH_caution"

/obj/structure/sign/chinese/danger
	icon_state = "CH_danger"

/obj/structure/sign/chinese/electrical_equipment
	icon_state = "CH_electrical_equipment"

/obj/structure/sign/chinese/access_restricted
	icon_state = "CH_access_restricted"

/obj/structure/sign/chinese/notice
	icon_state = "CH_notice"

/obj/structure/sign/chinese/security
	icon_state = "CH_security"

/obj/structure/sign/chinese/engineering
	icon_state = "CH_engineering"

/obj/structure/sign/chinese/science
	icon_state = "CH_science"

/obj/structure/sign/chinese/medbay
	icon_state = "CH_medbay"

/obj/structure/sign/chinese/evacuation
	icon_state = "CH_evacuation"

/obj/structure/sign/russian
	name = "incomprehensible sign"
	desc = "A sign written in russian."

/obj/structure/sign/russian/electrical_danger
	icon_state = "RU_electrical_danger"

/obj/structure/sign/russian/caution
	icon_state = "RU_caution"

/obj/structure/sign/russian/staff_only
	icon_state = "RU_staff_only"

/obj/structure/sign/radiationsignyellow
	name = "RADATION WARNING!"
	desc = "A warning sign advising you of a radioactive area."
	icon_state = "radiationsign"

/obj/structure/sign/secureareasign
	name = "SECURE AREA"
	desc = "A warning sign against tresspassing."
	icon_state = "securesign"

/obj/structure/sign/electricalsign
	name = "DANGER HIGH-VOLTAGE!"
	desc = "A warning sign that displays a large bolt. Underneath you can read 'BEWARE OF ELECTRIC SHOCK'."
	icon_state = "electricalsign"

/obj/structure/sign/cyrogenicsign
	name = "WARNING COLD TEMPERATURES."
	desc = "A warning sign which suggests this environment may contain sub-zero elements."
	icon_state = "cyrogenicsign"

/obj/structure/sign/containernotice
	name = "USE SAFETY CONTAINERS"
	desc = "A sign that advises the use of safety containers such as beakers."
	icon_state = "containersign"

/obj/structure/sign/highflame
	name = "CAUTION HIGHLY FLAMMABLE!"
	desc = "A warning sign that suggests this area contains highly flammable materials."
	icon_state = "oxidizersign"

/obj/structure/sign/veryconfused
	name = "???"
	desc = "A sign that doesn't make much sense at all."
	icon_state = "confusingsign"

/obj/structure/sign/biohazardous
	name = "DANGER BIOHAZARDOUS MATERIALS."
	desc = "A warning sign that tells you this area contains biohazardous materials. It advises wearing internals."
	icon_state = "biohazardous"

/obj/structure/sign/commonsenseplease
	name = "USE COMMON SENSE."
	desc = "A stark-yellow sign showing a brain. Underneath it states to use common sense, who would do that?"
	icon_state = "commonsense"

/obj/structure/sign/spacebearwarningsign
	name = "BEWARE OF SPACE BEARS."
	desc = "A sign that warns you of the danger of Space Bears. Drawing an anti-space bear circle on the ground is stated to prevent them."
	icon_state = "spacebearwarning"

/obj/structure/sign/biohazardsigns
	name = "BIOHAZARD PRESENT!"
	desc = "A sign which warns you that biohazardous material may be in use."
	icon_state = "biohazardsign"

/obj/structure/sign/dangercorrosive
	name = "CORROSIVE MATERIALS PRESENT!"
	desc = "A sign warning that corrosive reagents may be present. It advises wearing gloves to prevent chemical burns."
	icon_state = "corrosivematerial"

/obj/structure/sign/explosivematsign
	name = "DANGER! EXPLOSIVE MATERIAL!"
	desc = "A sign warning that highly explosive material may be used."
	icon_state = "explosives"

/obj/structure/sign/fireflamsign
	name = "FLAMMABLE MATERIALS."
	desc = "A warning sign which warns you of flammable materials."
	icon_state = "firesign"

/obj/structure/sign/alertlasersign
	name = "WEAR EYE-PROTECTION, LASERS IN USE."
	desc = "A warning sign advising you to wear eye protection."
	icon_state = "laserssign"

/obj/structure/sign/poisonsign
	name = "RESPIRATOR REQUIRED BEFORE ENTRY."
	desc = "A warning sign stating that respirators are needed due to poisonous materials being handled."
	icon_state = "poisonous"

/obj/structure/sign/magneticsign
	name = "MAGNETIC MATERIALS PRESENT."
	desc = "A warning sign which reads 'MAGNETIC MATERIALS PRESENT'."
	icon_state = "magnetic"

/obj/structure/sign/opticssign
	name = "WEAR EYE-PROTECTION BEFORE ENTRY"
	desc = "A warning sign which advises wearing equipment to prevent eye damage."
	icon_state = "optics"

/obj/structure/sign/vigilsign
	name = "REMAIN VIGILANT."
	desc = "A sign that advises you to remain vigilant to your surrondings. Someone has scratched out 'Trust No-one' at the bottom of the sign."
	icon_state = "awaresign"

/obj/structure/sign/ssdhelpsign
	name = "SECURE SLEEPING CREW."
	desc = "A sign advising you to return crew suffering from Sleep Sickness Disorder (SSD) to the Cyrogenics or Dorm area."
	icon_state = "ssdsign"

/obj/structure/sign/whitedragon
	name = "Eat at White Dragon!"
	desc = "A sign advertising White Dragon, a noodle bar. It's in some sort of ancient language you can't decipher..."
	icon_state = "neonsign"
