/var/security_level = 0
//0 = daybreak protocol
//1 = sunset protocol
//2 = nightfall protocol
//3 = supernova protocol

//config.alert_desc_blue_downto

/proc/set_security_level(var/level)
	switch(level)
		if("daybreak")
			level = SEC_LEVEL_DAYBREAK
		if("sunset")
			level = SEC_LEVEL_SUNSET
		if("nightfall")
			level = SEC_LEVEL_NIGHTFALL
		if("supernova")
			level = SEC_LEVEL_SUPERNOVA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_DAYBREAK && level <= SEC_LEVEL_SUPERNOVA && level != security_level)
		switch(level)
			if(SEC_LEVEL_DAYBREAK)
				world << sound('sound/misc/notice2.ogg')
				to_chat(world, "<font size=4 color='red'>Attention! Sunset Protocol has been lowered to Daybreak.</font>")
				to_chat(world, "<font color='red'>[config.alert_desc_green]</font>")
				security_level = SEC_LEVEL_DAYBREAK
			if(SEC_LEVEL_SUNSET)
				if(security_level < SEC_LEVEL_SUNSET)
					world << sound('sound/misc/notice1.ogg')
					to_chat(world, "<font size=4 color='red'>Attention! Daybreak Protocol has been elevated to Sunset!</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_blue_upto]</font>")
				else
					world << sound('sound/misc/notice2.ogg')
					to_chat(world, "<font size=4 color='red'>Attention! Nightfall Protocol has been lowered to Sunset.</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_blue_downto]</font>")
				security_level = SEC_LEVEL_SUNSET

			if(SEC_LEVEL_NIGHTFALL)
				if(security_level < SEC_LEVEL_NIGHTFALL)
					world << sound('sound/misc/redalert1.ogg')
					to_chat(world, "<font size=4 color='red'>Attention! Nightfall Protocol Initiated!</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_red_upto]</font>")
				else
					world << sound('sound/misc/notice2.ogg')
					to_chat(world, "<font size=4 color='red'>Attention! Nightfall Protocol Initiated!</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_red_downto]</font>")
				security_level = SEC_LEVEL_NIGHTFALL

				/*	- At the time of commit, setting status displays didn't work properly
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "redalert")*/

			if(SEC_LEVEL_SUPERNOVA)
				to_chat(world, "<font size=4 color='red'>Warning! Supernova Protocol engaged!</font>")
				to_chat(world, "<font color='red'>[config.alert_desc_delta]</font>")
				security_level = SEC_LEVEL_SUPERNOVA

		for(var/obj/machinery/firealarm/FA in firealarms)
			FA.update_icon()
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_DAYBREAK)
			return "daybreak"
		if(SEC_LEVEL_SUNSET)
			return "sunset"
		if(SEC_LEVEL_NIGHTFALL)
			return "nightfall"
		if(SEC_LEVEL_SUPERNOVA)
			return "supernova"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_DAYBREAK)
			return "daybreak"
		if(SEC_LEVEL_SUNSET)
			return "sunset"
		if(SEC_LEVEL_NIGHTFALL)
			return "nightfall"
		if(SEC_LEVEL_SUPERNOVA)
			return "supernova"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("daybreak")
			return SEC_LEVEL_DAYBREAK
		if("sunset")
			return SEC_LEVEL_SUNSET
		if("nightfall")
			return SEC_LEVEL_NIGHTFALL
		if("supernova")
			return SEC_LEVEL_SUPERNOVA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/
