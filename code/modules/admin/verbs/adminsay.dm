/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	log_adminsay("[key_name(src)] : [msg]", null, 0)

	if(check_rights(R_ADMIN,0))
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights)
				C << "<span class='admin_channel'>" + create_text_tag("admin", "ADMIN:", C) + " <span class='name'>[key_name(usr, 1)]</span>(<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"

/*
/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_MENTOR))	return

	msg = sanitize(msg)
	log_admin("MOD: [key_name(src)] : [msg]", null, 0)

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "<span class='admin'>[sender_name]</span>"
	for(var/client/C in admins)
		C << "<span class='mod_channel'>" + create_text_tag("mod", "MOD:", C) + " <span class='name'>[sender_name]</span>(<A HREF='?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
*/
