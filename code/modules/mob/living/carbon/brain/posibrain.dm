/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = 3
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)

	construction_cost = list(DEFAULT_WALL_MATERIAL=500,"glass"=500,"silver"=200,"gold"=200,"phoron"=100,"diamond"=10)
	construction_time = 75
	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(access_robotics)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.


/obj/item/device/mmi/digital/posibrain/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		user << "\blue You carefully locate the manual activation switch and start the positronic brain's boot process."
		src.searching = 1
		update_icon()
		src.request_player()
		spawn(600) reset_search()

/obj/item/device/mmi/digital/posibrain/proc/request_player()
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn(0, 1))
			continue
		if(jobban_isbanned(O, "AI") && jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_AI)
				question(O.client)

/obj/item/device/mmi/digital/posibrain/proc/question(var/client/C)
	spawn(0)
		if(!C)	return
		var/response = alert(C, "Someone is requesting a personality for a positronic brain. Would you like to play as one?", "Positronic brain request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a positronic brain?", "Positronic brain request", "Yes", "No")
		if(!C || brainmob.key || 0 == searching)	return		//handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_AI

/obj/item/device/mmi/digital/posibrain/update_icon()
	if(searching)
		icon_state = "posibrain-searching"
		name = initial(name)
	else
		if(brainmob && brainmob.key)
			icon_state = "posibrain-occupied"
			name = "[initial(name)] ([brainmob.real_name])"
		else
			icon_state = "posibrain"
			name = initial(name)

/obj/item/device/mmi/digital/posibrain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're just a metal cube.</span>"
	return

/obj/item/device/mmi/digital/posibrain/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a positronic brain now.")
	src.searching = 0
	src.brainmob.mind = candidate.mind
	src.brainmob.ckey = candidate.ckey
	src.brainmob.mind.reset()
	src.brainmob << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	src.brainmob << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	src.brainmob << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	src.brainmob << "<b>Use say :b to speak to other artificial intelligences.</b>"
	src.brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain chimes quietly.")
	update_icon()

/obj/item/device/mmi/digital/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.

	if(src.brainmob && src.brainmob.key) return

	src.searching = 0
	update_icon()

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?")

/obj/item/device/mmi/digital/posibrain/examine(mob/user)
//	.=..() //Check this.

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "<span class='info'>*---------*</span>"
	user << msg
	return

/obj/item/device/mmi/digital/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

/obj/item/device/mmi/digital/posibrain/New()
	..()
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name
