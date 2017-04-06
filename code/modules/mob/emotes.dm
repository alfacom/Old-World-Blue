#define EMOTE_HUMAN		0x1
#define EMOTE_ROBOT		0x2

// Emotes
var/global/list/human_emotes_list = list()
var/global/list/robot_emotes_list = list()

/hook/startup/proc/populate_emotes()
	var/paths = typesof(/datum/emote)
	. = length(paths)
	for(var/T in paths)
		var/datum/emote/E = new T
		if(!E.key || !E.autolist)
			del(E)
			continue
		if(E.autolist & EMOTE_HUMAN)
			human_emotes_list[E.key] = E
		if(E.autolist & EMOTE_ROBOT)
			robot_emotes_list[E.key] = E


/datum/emote
	var/key = ""
	var/message = ""
	var/r_message =  ""
	var/m_type = MESSAGE_VISIBLE
	var/autolist = EMOTE_HUMAN

/datum/emote/special
	autolist = null

/datum/emote/proc/act(var/mob/living/H)
	var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
	if(russified)
		return H.custom_emote(m_type, r_message)
	else
		return H.custom_emote(m_type, message)

/datum/emote/select
	var/target_message = ""
	var/r_target_message = ""
	var/range = null

	proc/get_target(var/mob/living/H)
		var/list/targets = list()
		for(var/mob/living/L in view(H, range ? range : world.view))
			targets += L
		return input(H) as null|mob in targets

	act(var/mob/living/carbon/human/H)
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/mob/living/target = get_target(H)
		if(!target || target==H)
			if(message)
				return ..()
			else
				return null
		else if(target in view(H, range ? range : world.view))
			if(russified)
				return H.custom_emote(m_type, replacetext(r_target_message,"@target", target))
			else
				return H.custom_emote(m_type, replacetext(target_message,"@target", target))

/datum/emote/select/local
	range = 1

/*
/datum/emote/select/ask
	range = 1
	var/ask_msg = ""

	act(var/mob/living/H)
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/mob/living/carbon/human/target = get_target(H)
		if(!target || target==H)
			if(message)
				return ..()
			else
				return null
		else
			if(russified)
				return H.custom_emote(m_type, replacetext(r_target_message,"@target", target))
			else
				return H.custom_emote(m_type, replacetext(target_message,"@target", target))
*/

////EMOTES////

/datum/emote/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a safari chimp."
	r_message = "������ �� ������������ ������ � ��&#255;�� ������� � ����."
	act(var/mob/living/H)
		if(!H.restrained())
			return ..()
		return null

/datum/emote/blink
	key = "blink"
	message = "blinks."
	r_message = "�������."

/datum/emote/blink_r
	key = "blink_r"
	message = "blinks rapidly."
	r_message = "����� �������."

/datum/emote/blush
	key = "blush"
	message = "blushes."
	r_message = "��������."

/datum/emote/choke
	key = "choke"
	message = "chokes!"
	r_message = "���������&#255;!"
	m_type = MESSAGE_HEARABLE

/datum/emote/chuckle
	key = "chuckle"
	message = "chuckles."
	r_message = "�����������&#255;."
	m_type = MESSAGE_HEARABLE

/datum/emote/clap
	key = "clap"
	message = "claps."
	r_message = "������� � ������."
	m_type = MESSAGE_HEARABLE
	autolist = EMOTE_HUMAN | EMOTE_ROBOT
	act(var/mob/living/carbon/human/H)
		if (!H.restrained())
			return ..()

/datum/emote/clear
	key = "clear"
	message = "clears /his throat"
	r_message = "��������� ���� �����."
	m_type = MESSAGE_HEARABLE

/datum/emote/collapse
	key = "collapse"
	message = "collapses!"
	r_message = "������!"
	m_type = MESSAGE_HEARABLE
	act(var/mob/living/H)
		H.Paralyse(2)
		return ..()

/datum/emote/cough
	key = "cough"
	message = "coughs!"
	r_message = "����&#255;��!"
	m_type = MESSAGE_HEARABLE

/datum/emote/cry
	key = "cry"
	message = "cries."
	r_message = "������."
	m_type = MESSAGE_HEARABLE

/datum/emote/deathgasp
	key = "deathgasp"
	m_type = MESSAGE_HEARABLE
	act(var/mob/living/carbon/human/H)
		if(!istype(H)) return
		return H.custom_emote(MESSAGE_VISIBLE, H.get_death_message())

/datum/emote/drool
	key = "drool"
	message = "drools."
	r_message = "������� �����."

/datum/emote/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."
	r_message = "������������� ��������� �����."

/datum/emote/faint
	key = "faint"
	message = "faints."
	r_message = "������ � �������."
	act(var/mob/living/H)
		if(!H.sleeping)
			. = ..()
			H.sleeping += 10 //Short-short nap

/datum/emote/flap
	key= "flap"
	message = "flaps wings."
	r_message = "������� �����&#255;��."
	m_type = MESSAGE_HEARABLE
	autolist = EMOTE_HUMAN | EMOTE_ROBOT
	act(var/mob/living/H)
		if (!H.restrained())
			return ..()

/datum/emote/flap_a
	key = "flap_a"
	message = "flaps wings ANGRILY!"
	r_message = "��������� ������� �����&#255;��!"
	m_type = MESSAGE_HEARABLE
	autolist = EMOTE_HUMAN | EMOTE_ROBOT
	act(var/mob/living/H)
		if (!H.restrained())
			return ..()

/datum/emote/frown
	key = "frown"
	message = "frowns."
	r_message = "�������&#255;."

/datum/emote/gasp
	key = "gasp"
	message = "gasps!"
	r_message = "�������&#255; ��������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/giggle
	key = "giggle"
	message = "giggles."
	r_message = "��������."
	m_type = MESSAGE_HEARABLE

/datum/emote/grin
	key = "grin"
	message = "grins."
	r_message = "�����&#255;���&#255;."

/datum/emote/groan
	key = "groan"
	message = "groans!"
	r_message = "������� ������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/grumble
	key = "grumble"
	message = "grumbles!"
	r_message = "������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/hem
	key = "hem"
	message = "hems"
	r_message = "�������."
	m_type = MESSAGE_HEARABLE

/datum/emote/hum
	key = "hum"
	message = "hums."
	r_message = "�������� ���� ��� ���."
	m_type = MESSAGE_HEARABLE

/datum/emote/laugh
	key = "laugh"
	message = "laughs."
	r_message = "�����&#255;."
	m_type = MESSAGE_HEARABLE

/datum/emote/moan
	key = "moan"
	message = "moans!"
	r_message = "������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/mumble
	key = "mumble"
	message = "mumbles!"
	r_message = "�������� ���-�� ����&#255;����."
	m_type = MESSAGE_HEARABLE

/datum/emote/nod
	key = "nod"
	message = "nods."
	r_message = "������."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

/datum/emote/pale
	key = "pale"
	message = "goes pale for a second."
	r_message = "��������."

/datum/emote/raise
	key = "raise"
	message = "raises a hand."
	r_message = "��������� ���� �����."
	act(var/mob/living/H)
		if (!H.restrained())
			return ..()

/datum/emote/scream
	key = "scream"
	message = "screams!"
	r_message = "������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/shake
	key = "shake"
	message = "shakes head."
	r_message = "���������� �������."

/datum/emote/shiver
	key = "shiver"
	message = "shivers."
	r_message = "������."

/datum/emote/shrug
	key = "shrug"
	message = "shrugs."
	r_message = "�������� �������."

/datum/emote/sigh
	key = "sigh"
	message = "sighs."
	r_message = "��������."
	m_type = MESSAGE_HEARABLE

/datum/emote/smile
	key = "smile"
	message = "smiles."
	r_message = "��������&#255;."

/datum/emote/sneeze
	key = "sneeze"
	message = "sneezes."
	r_message = "������."
	m_type = MESSAGE_HEARABLE

/datum/emote/sniff
	key = "sniff"
	message = "sniffs."
	r_message = "������� �����."
	m_type = MESSAGE_HEARABLE

/datum/emote/snore
	key = "snore"
	message = "snores."
	r_message = "�����."
	m_type = MESSAGE_HEARABLE

/datum/emote/tremble
	key = "tremble"
	message = "trembles in fear!"
	r_message = "������ �� �����!"

/datum/emote/twitch
	key = "twitch"
	message = "twitches violently."
	r_message = "����� ��������&#255;."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

/datum/emote/twitch_s
	key = "twitch_s"
	message = "twitches."
	r_message = "��������&#255;."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

/datum/emote/wave
	key = "wave"
	message = "waves."
	r_message = "����� �����."

/datum/emote/whimper
	key = "whimper"
	message = "whimpers."
	r_message = "�����������."
	m_type = MESSAGE_HEARABLE

/datum/emote/whistle
	key = "whistle"
	message = "whistles!"
	r_message = "�������!"
	m_type = MESSAGE_HEARABLE

/datum/emote/wink
	key = "wink"
	message = "winks."
	r_message = "�����������."

/datum/emote/yawn
	key = "yawn"
	message = "yawns."
	r_message = "������."
	m_type = MESSAGE_HEARABLE
	act(var/mob/living/carbon/human/H)
		if (!istype(H.wear_mask, /obj/item/clothing/mask/muzzle))
			return ..()

////SELECT////

/datum/emote/select/airkiss
	key = "airkiss"
	message = "blowing a kiss."
	r_message = "�������&#255;�� ��������� �������."
	target_message = "blowing a kiss to @target."
	r_target_message = "�������&#255;�� ��������� ������� @target."
	act(var/mob/living/H)
		if(!H.restrained())
			return ..()

/datum/emote/select/bow
	key = "bow"
	message = "bows."
	r_message = "����&#255;���&#255;."
	target_message = "bows to @target."
	r_target_message = "����&#255;���&#255; @target."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT
	act(var/mob/living/H)
		if(!H.buckled)
			return ..()

/datum/emote/select/glare
	key = "glare"
	message = "glares."
	r_message = "������ �������."
	target_message = "glares at @target."
	r_target_message = "������� �� @target �� ������."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

/datum/emote/select/look
	key = "look"
	message = "looks."
	r_message = "������������&#255;."
	target_message = "looks at @target."
	r_target_message = "������� ��@target."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

/datum/emote/select/salute
	key = "salute"
	message = "salutes."
	r_message = "������ �����."
	target_message = "salutes to @target."
	r_target_message = "������ ����� @target."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT
	act(var/mob/living/carbon/human/H)
		if(!H.handcuffed)
			return ..()

/datum/emote/select/stare
	key = "stare"
	message = "stares."
	r_message = "����������� ������� �� ��������&#255;���."
	target_message = "stares at @target."
	r_target_message = "�&#255;����&#255; �� @target."
	autolist = EMOTE_HUMAN | EMOTE_ROBOT

////SELECT LOCAL////

/datum/emote/select/local/cuddle
	key = "cuddle"
	target_message = "cuddles @target."
	r_target_message = "����������&#255; � @target."
	act(var/mob/living/carbon/human/H)
		if(!H.restrained())
			..()

/datum/emote/select/local/dap
	key = "dap"
	message = "sadly can't find anybody to give daps to, and daps himself. Shameful."
	r_message = "�� ����&#255; ������ �&#255;��� � �����, ������  ������� ��� � �����.  ������ �������."
	target_message = "gives daps to @target."
	r_target_message = "������ ������� � @target."
	act(var/mob/living/H)
		if(!H.restrained())
			..()

/datum/emote/select/local/handshake
	key = "handshake"
	target_message = "shakes hands with @target."
	r_target_message = "���� ���� � @target."

/datum/emote/select/local/highfive
	key = "five"
	message = "can't find anybody to give high five to."
	r_message = "�� ������� ������, ���� ����� ���� �� ���� �&#255;��."
	target_message = "gives hihg five to @target."
	r_target_message = "���� �&#255;�� @target"

/datum/emote/select/local/hug
	key = "hug"
	message = "hugs itself."
	r_message = "�������� ���&#255;."
	target_message = "hugs @target."
	r_target_message = "�������� @target."

/datum/emote/select/local/kiss
	key = "kiss"
	target_message = "kisses @target."
	r_target_message = "������ @target."

/datum/emote/select/local/snuggle
	key = "snuggle"
	target_message = "snuggles @target."
	r_target_message = "��������� @target � ����."

////Special////

/datum/emote/signal
	key = "signal"
	m_type = MESSAGE_VISIBLE

	act(var/mob/living/carbon/human/H)
		if(!istype(H)) return
		var/russified = H.client && (H.client.prefs.toggles & RUS_AUTOEMOTES)
		var/t1 = input("How many fingers will you raise?", "Ammount", 2) as num
		if (isnum(t1))
			if (t1 <= 0) return
			switch(t1)
				if (1 to 5)
					if((H.r_hand || !H.get_organ(BP_R_HAND)) && (H.l_hand  || !H.get_organ(BP_L_HAND)))
						H << "<span class='warning'>Your need at least one free hand for this</span>"
						return
					if(!russified)
						return H.custom_emote(m_type, "raises [t1] finger\s.")
					else
						var/emote = "��������� [t1] �������"
						switch(t1)
							if(1)   emote = "��������� [t1] �����."
							if(2 to 4) emote = "��������� [t1] ������."
							if(5)   emote = "��������� [t1] �������."
						return H.custom_emote(m_type, emote)
				if (6 to 10)
					if((H.r_hand || !H.get_organ(BP_R_HAND)) || (H.l_hand  || !H.get_organ(BP_L_HAND)))
						H << "<span class='warning'>Your need at least two free hands for this</span>"
						return
					if(russified)
						return H.custom_emote(m_type, "��������� [t1] �������.")
					else
						return H.custom_emote(m_type, "raises [t1] fingers.")

//// Pure silicon emotes ////

/datum/emote/deathgasp_robot
	key = "deathgasp"
	message = "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
	r_message = "����� �����������, ����� ���� ��������� ��� �������&#255;, ��� ����� ������ ������."
	m_type = MESSAGE_HEARABLE
	autolist = EMOTE_ROBOT

/datum/emote/select/beep
	key = "beep"
	message = "beeps."
	r_message = "�����."
	target_message = "beeps at @target."
	r_target_message = "����� �� @target."
	autolist = EMOTE_ROBOT
	act(var/mob/living/H)
		if(..())
			playsound(H.loc, 'sound/machines/twobeep.ogg', 50, 0)

/datum/emote/select/buzz
	key = "buzz"
	message = "buzzes."
	r_message = "������."
	target_message = "buzzes at @target."
	r_target_message = "������ �� @target."
	autolist = EMOTE_ROBOT
	act(var/mob/living/H)
		if(..())
			playsound(H.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)

/datum/emote/select/ping
	key = "ping"
	message = "pings."
	r_message = "������."
	target_message = "pings at @target."
	r_target_message = "������ �� @target."
	autolist = EMOTE_ROBOT
	act(var/mob/living/H)
		if(..())
			playsound(H.loc, 'sound/machines/ping.ogg', 50, 0)


/// Species tail emote ///

/datum/emote/tail
	autolist = null

/datum/emote/tail/swish
	key = "swish"
	m_type = MESSAGE_VISIBLE
	act(var/mob/living/carbon/human/H)
		H.animate_tail_once()

/datum/emote/tail/wag
	key = "wag"
	act(var/mob/living/carbon/human/H)
		H.animate_tail_start()

/datum/emote/tail/wag/sway
	key = "sway"


/datum/emote/tail/qwag
	key = "qwag"
	act(var/mob/living/carbon/human/H)
		H.animate_tail_fast()

/datum/emote/tail/qwag/fastsway
	key = "fastsway"


/datum/emote/tail/swag
	key = "swag"
	act(var/mob/living/carbon/human/H)
		H.animate_tail_stop()

/datum/emote/tail/swag/stopsway
	key = "stopsway"


#undef EMOTE_HUMAN
#undef EMOTE_ROBOT
