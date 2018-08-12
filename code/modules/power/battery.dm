// Generic battery machine
// stores power

#define SMESLEVELCHARGE		1
#define SMESLEVELCHARGING	2
#define SMESLEVELONLINE		3

#define BATTERY_NO_CHARGE		0
#define BATTERY_MANUAL_CHARGE	1
#define BATTERY_AUTO_CHARGE		2

var/global/list/battery_charge = 	list(
										image('icons/obj/power.dmi', "smes-og1"),
										image('icons/obj/power.dmi', "smes-og2"),
										image('icons/obj/power.dmi', "smes-og3"),
										image('icons/obj/power.dmi', "smes-og4"),
										image('icons/obj/power.dmi', "smes-og5")
										)

var/global/list/battery_charging =	list(
										image('icons/obj/power.dmi', "smes-oc0"),
										image('icons/obj/power.dmi', "smes-oc1")
										)
var/global/list/battery_online =	list(
										image('icons/obj/power.dmi', "smes-op0"),
										image('icons/obj/power.dmi', "smes-op1")
										)

/obj/machinery/power/battery/update_icon()
	overlays.len = 0
	if(stat & (BROKEN | FORCEDISABLE | EMPED))
		return

	overlays += battery_online[online + 1]

	if(charging)
		overlays += battery_charging[2]
	else if(chargemode)
		overlays += battery_charging[1]

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += battery_charge[clevel]
	return

#define SMESRATE 0.05 				// rate of internal charge to external power

/obj/machinery/power/battery
	name = "power storage unit"
	desc = "A placeholder power storage unit. If found, please return to CentCom."
	icon_state = "smes"
	density = 1
	anchored = 1
	use_power = 0

	var/output = 50000
	var/lastout = 0
	var/loadcharge = 0
	var/loaddemand = 0
	var/capacity = 5e6 //Max stored charge
	var/charge = 1e6 //Stored charge
	var/charging = FALSE //Are we currently taking charge in?
	var/chargemode = BATTERY_NO_CHARGE //Are we set to charge or not? Not the same as charging
	var/chargecount = 0 //How long we've spent since not charging
	var/chargelevel = 50000
	var/online = 1
	var/max_input = 200000
	var/max_output = 200000

	var/name_tag = ""

	var/infinite_power = 0 //makes the machine just generate power itself

	//Holders for powerout event.
	var/last_output = 0
	var/last_charge = 0
	var/last_online = 0

	machine_flags = SCREWTOGGLE | CROWDESTROY

/obj/machinery/power/battery/RefreshParts()
	var/capcount = 0
	var/lasercount = 0
	for(var/obj/item/weapon/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/weapon/stock_parts/capacitor))
			capcount += SP.rating-1
		if(istype(SP, /obj/item/weapon/stock_parts/micro_laser))
			lasercount += SP.rating-1
	capacity = initial(capacity) + capcount*125e4
	max_input = initial(max_input) + lasercount*50000
	max_output = initial(max_output) + lasercount*50000

/obj/machinery/power/battery/process()
	if(stat & (BROKEN | FORCEDISABLE | EMPED))
		last_charge = 0
		return

	if(infinite_power) //Only used for magical machines - BEWARE
		capacity = INFINITY
		charge = INFINITY

	var/_charging = charging
	var/_online = online
	var/_chargedisplay = chargedisplay()

	// Input
	var/excess = surplus()

	if (charging)
		// Manual charge mode is the 'old' mode, when batteries only charge when available power is higher than set charge level
		// Auto charge mode lets batteries take any amount of available power, limited by charge level
		if((chargemode == BATTERY_MANUAL_CHARGE && excess >= chargelevel)||(chargemode == BATTERY_AUTO_CHARGE && excess > 0)) // If there's power available, try to charge
			loadcharge = min((capacity - charge) / SMESRATE, excess, chargelevel) // Charge at set rate, limited to spare capacity
			charge += loadcharge * SMESRATE // Increase the charge
			add_load(loadcharge) // Add the load to the terminal side network

		else
			charging = FALSE
			chargecount = 0

	else
		if (chargemode)
			if (chargecount > rand(3, 6))
				charging = TRUE
				chargecount = 0

			if ((chargemode == BATTERY_MANUAL_CHARGE && excess >= chargelevel) || (chargemode == BATTERY_AUTO_CHARGE && excess > 0))
				chargecount++
			else
				chargecount = 0
		else
			chargecount = 0

	// Output
	if (online && get_powernet()) // how can discharge be real if our powernet isn't real
		lastout = min(charge / SMESRATE, output) // Limit output to that stored

		charge -= lastout * SMESRATE // Reduce the storage (may be recovered in /restore() if excessive)

		add_avail(lastout) // Add output to powernet (smes side)

		if (charge < 0.0001)
			online = FALSE
			lastout = 0

	// Only update icon if state changed
	if(_charging != charging || _online != online || _chargedisplay != chargedisplay())
		update_icon()

/obj/machinery/power/battery/proc/chargedisplay()
	return Clamp(round(5.5*charge/(capacity ? capacity : 5e6)), 0, battery_charge.len)

/*
 * Called after all power processes are finished
 * Restores charge level to smes if there was excess this ptick
 */
/obj/machinery/power/battery/proc/restore()
	if (stat & BROKEN)
		return

	var/_chargedisplay = chargedisplay()

	var/excess = powernet.netexcess // This was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(lastout, excess) // Clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity - charge) / SMESRATE, excess) // For safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// Now recharge this amount

	charge += excess * SMESRATE // Restore unused power

	powernet.netexcess -= excess // Remove the excess from the powernet, so later SMESes don't try to use it

	loaddemand = lastout - excess

	if(_chargedisplay != chargedisplay()) // If needed updates the icons overlay
		update_icon()

/obj/machinery/power/battery/attack_ai(mob/user)
	src.add_hiddenprint(user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/power/battery/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/power/battery/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open=NANOUI_FOCUS)

	if(stat & BROKEN)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["nameTag"] = name_tag
	data["storedCapacity"] = round(100.0*charge/capacity, 0.1)
	data["charging"] = charging
	data["chargeMode"] = chargemode
	data["chargeLoad"] = round(loadcharge)
	data["chargeLevel"] = chargelevel
	data["chargeMax"] = max_input
	data["outputOnline"] = online
	data["outputLevel"] = output
	data["outputMax"] = max_output
	data["outputLoad"] = round(loaddemand)
	data["hasInput"] = get_terminal() ? 1 : 0;
	data["hasOutput"] = powernet ? 1 : 0;

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "smes.tmpl", "The SMES Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/battery/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["close"])
		if(usr.machine == src)
			usr.unset_machine()
		return 1
	if (!isAdminGhost(usr) && (usr.stat || usr.restrained()))
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/living/silicon/ai) && !isAdminGhost(usr))
			to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
			return

//to_chat(world, "[href] ; [href_list[href]]")

	if (!isturf(src.loc) && !istype(usr, /mob/living/silicon/) && !isAdminGhost(usr))
		return 0 // Do not update ui

	if( href_list["cmode"] )
		switch( href_list["cmode"])
			if("auto")
				chargemode = BATTERY_AUTO_CHARGE
			if("manual")
				chargemode = BATTERY_MANUAL_CHARGE
			if("off")
				chargemode = BATTERY_NO_CHARGE
				charging = 0
		update_icon()

	else if( href_list["online"] )
		online = !online
		update_icon()
	else if( href_list["input"] )
		switch( href_list["input"] )
			if("min")
				chargelevel = 0
			if("max")
				chargelevel = max_input		//30000
			if("set")
				chargelevel = input(usr, "Enter new input level (0-[max_input])", "SMES Input Power Control", chargelevel) as num
		chargelevel = max(0, min(max_input, chargelevel))	// clamp to range

	else if( href_list["output"] )
		switch( href_list["output"] )
			if("min")
				output = 0
			if("max")
				output = max_output		//30000
			if("set")
				output = input(usr, "Enter new output level (0-[max_output])", "SMES Output Power Control", output) as num
		output = max(0, min(max_output, output))	// clamp to range

	investigation_log(I_SINGULO,"input/output; [chargelevel>output?"<font color='green'>":"<font color='red'>"][chargelevel]/[output]</font> | Output-mode: [online?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [chargemode?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]")

	return 1

/obj/machinery/power/battery/proc/ion_act()
	if(src.z == map.zMainStation)
		if(prob(1)) //explosion
			message_admins("<span class='warning'>SMES explosion in [get_area(src)]</span>")
			src.visible_message("<span class='warning'>\The [src] is making strange noises!</span>",
								"<span class='warning'>You hear sizzling electronics.</span>")

			sleep(10*pick(4,5,6,7,10,14))

			var/datum/effect/effect/system/smoke_spread/smoke = new()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()
			explosion(src.loc, -1, 0, 1, 3, 0)
			qdel(src)
			return
		else if(prob(15)) //Power drain
			message_admins("<span class='warning'>SMES power drain in [get_area(src)]</span>")
			spark(src)
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)
		else if(prob(5)) //smoke only
			message_admins("<span class='warning'>SMES smoke in [get_area(src)]</span>")
			var/datum/effect/effect/system/smoke_spread/smoke = new()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()


/obj/machinery/power/battery/emp_act(severity)
	charge = max(0, charge - 1e6/severity)
	stat |= EMPED
	spawn(100)
		stat &= ~EMPED
	..()

/obj/machinery/power/battery/npc_tamper_act(mob/living/L)
	if(prob(50)) //Toggle on/off
		online = !online
		update_icon()
	else //Screw up power input/output
		chargelevel = rand(0, max_input)
		output = rand(0, max_output)

/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null)
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit)
		return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate

/obj/machinery/power/battery/proc/get_terminal()
	return terminal
