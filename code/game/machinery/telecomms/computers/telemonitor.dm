/*
	Telecomms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/

#define MAIN_VIEW 0
#define MACHINE_VIEW 1
#define MAX_NETWORK_ID_LENGTH 15

/obj/machinery/computer/telecomms/monitor
	name = "консоль мониторинга телекоммуникаций"
	desc = "Отслеживает параметры телекоммуникационной сети, с которой она синхронизирована."
	icon_screen = "comm_monitor"

	/// Current screen the user is viewing
	var/screen = MAIN_VIEW
	/// Weakrefs of the machines located by the computer
	var/list/machine_list = list()
	/// Weakref of the currently selected tcomms machine
	var/datum/weakref/selected_machine_ref
	/// The network to probe
	var/network = "NULL"
	/// Error message to show
	var/error_message = ""
	circuit = /obj/item/circuitboard/computer/comm_monitor

/obj/machinery/computer/telecomms/monitor/ui_data(mob/user)
	var/list/data = list(
		"screen" = screen,
		"network" = network,
		"error_message" = error_message,
	)

	switch(screen)
	  	// --- Main Menu ---
		if(MAIN_VIEW)
			var/list/found_machinery = list()
			for(var/datum/weakref/tcomms_ref in machine_list)
				var/obj/machinery/telecomms/telecomms = tcomms_ref.resolve()
				if(!telecomms)
					machine_list -= tcomms_ref
					continue
				found_machinery += list(list("ref" = REF(telecomms), "name" = telecomms.name, "id" = telecomms.id))
			data["machinery"] = found_machinery
	  	// --- Viewing Machine ---
		if(MACHINE_VIEW)
			// Send selected machinery data
			var/list/machine_out = list()
			var/obj/machinery/telecomms/selected = selected_machine_ref.resolve()
			if(selected)
				machine_out["name"] = selected.name
				// Get the linked machinery
				var/list/linked_machinery = list()
				for(var/obj/machinery/telecomms/T in selected.links)
					linked_machinery += list(list("ref" = REF(T.id), "name" = T.name, "id" = T.id))
				machine_out["linked_machinery"] = linked_machinery
				data["machine"] = machine_out
	return data

/obj/machinery/computer/telecomms/monitor/ui_act(action, params)
	. = ..()
	if(.)
		return .

	error_message = ""

	switch(action)
		// Scan for a network
		if("probe_network")
			var/new_network = params["network_id"]

			if(length(new_network) > MAX_NETWORK_ID_LENGTH)
				error_message = "OPERATION FAILED: NETWORK ID TOO LONG."
				return TRUE

			list_clear_empty_weakrefs(machine_list)

			if(machine_list.len > 0)
				error_message = "OPERATION FAILED: CANNOT PROBE WHEN BUFFER FULL."
				return TRUE

			network = new_network

			for(var/obj/machinery/telecomms/T in urange(25, src))
				if(T.network == network)
					machine_list += WEAKREF(T)
			if(machine_list.len == 0)
				error_message = "OPERATION FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN  [network]."
				return TRUE
			error_message = "[machine_list.len] ENTITIES LOCATED & BUFFERED";
			return TRUE
		if("flush_buffer")
			machine_list = list()
			network = ""
			return TRUE
		if("view_machine")
			for(var/datum/weakref/tcomms_ref in machine_list)
				var/obj/machinery/telecomms/tcomms = tcomms_ref.resolve()
				if(!tcomms)
					machine_list -= tcomms_ref
					continue
				if(tcomms.id == params["id"])
					selected_machine_ref = tcomms_ref
			if(!selected_machine_ref)
				error_message = "OPERATION FAILED: UNABLE TO LOCATE MACHINERY."
			screen = MACHINE_VIEW
			return TRUE
		if("return_home")
			selected_machine_ref = null
			screen = MAIN_VIEW
			return TRUE
	return TRUE

/obj/machinery/computer/telecomms/monitor/attackby()
	. = ..()
	updateUsrDialog()

/obj/machinery/computer/telecomms/monitor/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TelecommsMonitor", name)
		ui.open()

#undef MAIN_VIEW
#undef MACHINE_VIEW
#undef MAX_NETWORK_ID_LENGTH
