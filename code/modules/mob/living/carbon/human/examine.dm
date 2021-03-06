/mob/living/carbon/human/examine(mob/user)
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0

	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0
	var/skipchest = 0
	var/skipgroin = 0
	var/skiphands = 0
	var/skiplegs = 0
	var/skiparms = 0
	var/skipfeet = 0

	var/looks_synth = looksSynthetic()

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipsuitstorage |= wear_suit.flags_inv & HIDESUITSTORAGE
		if(wear_suit.flags_inv & HIDEJUMPSUIT)
			skiparms |= 1
			skiplegs |= 1
			skipchest |= 1
			skipgroin |= 1
		if(wear_suit.flags_inv & HIDESHOES)
			skipshoes |= 1
			skipfeet |= 1
		if(wear_suit.flags_inv & HIDEGLOVES)
			skipgloves |= 1
			skiphands |= 1

	if(w_uniform)
		skiplegs |= w_uniform.body_parts_covered & LEGS
		skiparms |= w_uniform.body_parts_covered & ARMS
		skipchest |= w_uniform.body_parts_covered & UPPER_TORSO
		skipgroin |= w_uniform.body_parts_covered & LOWER_TORSO

	if(gloves)
		skiphands |= gloves.body_parts_covered & HANDS

	if(shoes)
		skipfeet |= shoes.body_parts_covered & FEET

	if(head)
		skipmask |= head.flags_inv & HIDEMASK
		skipeyes |= head.flags_inv & HIDEEYES
		skipears |= head.flags_inv & HIDEEARS
		skipface |= head.flags_inv & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	//This is what hides what
	var/list/hidden = list(
		BP_GROIN = skipgroin,
		BP_CHEST = skipchest,
		BP_HEAD  = skipface,
		BP_L_ARM = skiparms,
		BP_R_ARM = skiparms,
		BP_L_HAND= skiphands,
		BP_R_HAND= skiphands,
		BP_L_FOOT= skipfeet,
		BP_R_FOOT= skipfeet,
		BP_L_LEG = skiplegs,
		BP_R_LEG = skiplegs
	)

	var/msg = "<span class='info'>*---------*\nThis is "

	var/datum/gender/T = gender_datums[get_gender()]
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]

	if(!T)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : gender]'")

	msg += "<EM>[src.name]</EM>"

	//big suits/masks/helmets make it hard to tell their gender and age
	if(!skipjumpsuit || !skipface)

		var/t_appeal = "<b><font color='[get_flesh_colour()]'>[species.name]</font></b>"
		switch(gender)
			if(MALE)
				if(species.name == "Human") t_appeal = "man"
			if(FEMALE)
				if(species.name == "Human") t_appeal = "woman"

		if (species.name == "Machine")
			msg += ", a [t_appeal]"
		else switch(age)
			if(1 to 25)
				msg += ", a young [t_appeal]"
			if(26 to 45)
				msg += ", a [t_appeal]"
			if(46 to 75)
				msg += ", an old [t_appeal]"
			else
				msg += ", a very old [t_appeal]"

	msg += "!<br>"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				tie_msg += ". Attached to it is [lowertext(english_list(U.accessories))]"

		if(w_uniform.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [w_uniform.name][tie_msg]!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[w_uniform] \a [w_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] [(head.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [head.name] on [T.his] head!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[head] \a [head] on [T.his] head.\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_suit.name]!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[wear_suit] \a [wear_suit].\n"

		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_DNA)
				msg += "<span class='warning'>[T.He] [T.is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [s_store.name] on [T.his] [wear_suit.name]!</span>\n"
			else
				msg += "[T.He] [T.is] carrying \icon[s_store] \a [s_store] on [T.his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[back] [back.gender==PLURAL?"some":"a"] [(back.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [back] on [T.his] back.</span>\n"
		else
			msg += "[T.He] [T.has] \icon[back] \a [back] on [T.his] back.\n"

	//left hand
	if(l_hand)
		if(l_hand.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[l_hand] [l_hand.gender==PLURAL?"some":"a"] [(l_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [l_hand.name] in [T.his] left hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[l_hand] \a [l_hand] in [T.his] left hand.\n"

	//right hand
	if(r_hand)
		if(r_hand.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[r_hand] [r_hand.gender==PLURAL?"some":"a"] [(r_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [r_hand.name] in [T.his] right hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[r_hand] \a [r_hand] in [T.his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [gloves.name] on [T.his] hands!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[gloves] \a [gloves] on [T.his] hands.\n"
	else if(blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!</span>\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/handcuffs/cable))
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[T.He] [T.is] \icon[buckled] buckled to [buckled]!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[belt] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [belt.name] about [T.his] waist!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[belt] \a [belt] about [T.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [shoes.name] on [T.his] feet!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[shoes] \a [shoes] on [T.his] feet.\n"
	else if(feet_blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		var/descriptor = "on [T.his] neck"
		if(wear_mask.body_parts_covered&FACE)
			descriptor = "on [T.his] face"

		if(wear_mask.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_mask.name] [descriptor]!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[wear_mask] \a [wear_mask] [descriptor].\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [glasses] covering [T.his] eyes!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[glasses] \a [glasses] covering [T.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[T.He] [T.has] \icon[l_ear] \a [l_ear] on [T.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[T.He] [T.has] \icon[r_ear] \a [r_ear] on [T.his] right ear.\n"

	//ID
	if(wear_id)
		/*var/id
		if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/weapon/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/weapon/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, usr) <= 1) && prob(10))
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span>\n"
		else*/
		msg += "[T.He] [T.is] wearing \icon[wear_id] \a [wear_id].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[T.He] [T.is] extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "<span class='warning'>[T.He] [T.has] a splint on [T.his] [o.name]!</span>\n"

	if(suiciding)
		msg += "<span class='warning'>[T.He] appears to have commited suicide... there is no hope of recovery.</span>\n"

	var/distance = get_dist(user,src)
	if(isobserver(user) || usr.stat == DEAD) // ghosts can see anything
		distance = 1
	if (src.birth)
		msg += "<span class='warning'>[T.He] [T.has] a large hole in [T.his] chest!</span>\n"
	if (src.stat)
		msg += "<span class='warning'>[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.</span>\n"
		if((stat == DEAD || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[T.He] [T.does] not appear to be breathing.</span>\n"
		if(ishuman(user) && !usr.stat && Adjacent(user))
			spawn(0)
				usr.visible_message("<b>[user]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
				if(do_mob(user, src, 15))
					if(pulse == PULSE_NONE)
						user << "<span class='deadsay'>[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]...</span>"
					else
						user << "<span class='deadsay'>[T.He] [T.has] a pulse!</span>"

	if(fire_stacks)
		msg += "[T.He] [T.is] covered in some liquid.\n"
	if(on_fire)
		msg += "<span class='warning'>[T.He] [T.is] on fire!.</span>\n"
	msg += "<span class='warning'>"

	if(nutrition < 100)
		msg += "[T.He] [T.is] severely malnourished.\n"
	else if(nutrition >= 500)
		/*if(usr.nutrition < 100)
			msg += "[T.He] [T.is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else*/
		msg += "[T.He] [T.is] quite chubby.\n"

	msg += "</span>"

	var/ssd_msg = get_ssd()
	if(ssd_msg && (!should_have_organ(O_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg].</span>\n"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()

	for(var/organ_tag in species.has_limbs)

		var/datum/organ_description/organ_data = species.has_limbs[organ_tag]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text[organ_data.name] = "<span class='danger'>[T.He] [T.is] missing [T.his] [organ_data.name].</span>\n"
		else if(E.is_stump())
			wound_flavor_text[organ_data.name] = "<span class='danger'>[T.He] [T.has] a stump where [T.his] [organ_data.name] should be.</span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if((temp.organ_tag in hidden) && hidden[temp.organ_tag])
			continue //Organ is hidden, don't talk about it
		if(temp.status & ORGAN_DESTROYED)
			wound_flavor_text[temp.name] = "<span class='danger'>[T.He] [T.is] missing [T.his] [temp.name].</span>\n"
			continue
		if(!looks_synth && (temp.robotic >= ORGAN_ROBOT))
			if(!(temp.brute_dam + temp.burn_dam))
				wound_flavor_text[temp.name] = "[T.He] [T.has] a [temp.name].\n"
			else
				wound_flavor_text[temp.name] = "<span class='warning'>[T.He] [T.has] a [temp.name] with [temp.get_wounds_desc()]!</span>\n"
			continue
		else if(temp.wounds.len > 0 || temp.open)
			if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
				var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
				wound_flavor_text[temp.name] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [parent.name].</span><br>"
			else
				wound_flavor_text[temp.name] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [temp.name].</span><br>"
			if(temp.status & ORGAN_BLEEDING)
				is_bleeding[temp.name] = "<span class='danger'>[T.His] [temp.name] is bleeding!</span><br>"
		else
			wound_flavor_text[temp.name] = ""
		if(temp.dislocated == 2)
			wound_flavor_text[temp.name] += "<span class='warning'>[T.His] [temp.joint] is dislocated!</span><br>"
		if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
			wound_flavor_text[temp.name] += "<span class='warning'>[T.His] [temp.name] is dented and swollen!</span><br>"

	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
		is_bleeding[limb] = null
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/implant in get_visible_implants(0))
		msg += "<span class='danger'>[src] [T.has] \a [implant] sticking out of [T.his] flesh!</span>\n"
	if(digitalcamo)
		msg += "[T.He] [T.is] repulsively uncanny!\n"

	if(hasHUD(usr,"security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
		else
			perpname = name

		if(perpname)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(usr,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id,/obj/item/weapon/card/id))
				perpname = wear_id:registered_name
			else if(istype(wear_id,/obj/item/device/pda))
				var/obj/item/device/pda/tempPda = wear_id
				perpname = tempPda.owner
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"

		var/obj/item/clothing/under/U = w_uniform
		if(U && istype(U) && U.sensor_mode >= 2)
			msg += "<span class='deptradio'><b>Damage Specifics:</span> <span style=\"color:blue\">[round(src.getOxyLoss(), 1)]</span>-<span style=\"color:green\">[round(src.getToxLoss(), 1)]</span>-<span style=\"color:#FFA500\">[round(src.getFireLoss(), 1)]</span>-<span style=\"color:red\">[round(src.getBruteLoss(), 1)]</span></b>\n"

	var/flavor = print_flavor_text()
	if(flavor) msg += "[flavor]\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",lentext(pose)) == 0 && findtext(pose,"!",lentext(pose)) == 0 && findtext(pose,"?",lentext(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[T.He] [pose]"

	user << msg

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else if(istype(M, /mob/living/silicon/pai))
		var/mob/living/silicon/pai/P = M
		switch(hudtype)
			if("security")
				return P.secHUD
			if("medical")
				return P.medHUD
	else
		return 0
