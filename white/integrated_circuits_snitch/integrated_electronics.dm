#define IC_INPUT 		"I"
#define IC_OUTPUT		"O"
#define IC_ACTIVATOR	"A"

// Pin functionality.
#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

// Methods of obtaining a circuit.
#define IC_SPAWN_DEFAULT			1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 			2 // If the circuit design will be available in the IC printer after upgrading it.

// Categories that help differentiate circuits that can do different tipes of actions
#define IC_ACTION_MOVEMENT		(1<<0) // If the circuit can move the assembly
#define IC_ACTION_COMBAT		(1<<1) // If the circuit can cause harm
#define IC_ACTION_LONG_RANGE	(1<<2) // If the circuit communicate with something outside of the assembly

// Displayed along with the pin name to show what type of pin it is.
#define IC_FORMAT_ANY			"\<ANY\>"
#define IC_FORMAT_STRING		"\<TEXT\>"
#define IC_FORMAT_CHAR			"\<CHAR\>"
#define IC_FORMAT_COLOR			"\<COLOR\>"
#define IC_FORMAT_NUMBER		"\<NUM\>"
#define IC_FORMAT_DIR			"\<DIR\>"
#define IC_FORMAT_BOOLEAN		"\<BOOL\>"
#define IC_FORMAT_REF			"\<REF\>"
#define IC_FORMAT_LIST			"\<LIST\>"
#define IC_FORMAT_INDEX			"\<INDEX\>"

#define IC_FORMAT_PULSE			"\<PULSE\>"

// Used inside input/output list to tell the constructor what pin to make.
#define IC_PINTYPE_ANY				/datum/integrated_io
#define IC_PINTYPE_STRING			/datum/integrated_io/string
#define IC_PINTYPE_CHAR				/datum/integrated_io/char
#define IC_PINTYPE_COLOR			/datum/integrated_io/color
#define IC_PINTYPE_NUMBER			/datum/integrated_io/number
#define IC_PINTYPE_DIR				/datum/integrated_io/dir
#define IC_PINTYPE_BOOLEAN			/datum/integrated_io/boolean
#define IC_PINTYPE_REF				/datum/integrated_io/ref
#define IC_PINTYPE_LIST				/datum/integrated_io/lists
#define IC_PINTYPE_INDEX			/datum/integrated_io/index
#define IC_PINTYPE_SELFREF			/datum/integrated_io/selfref

#define IC_PINTYPE_PULSE_IN			/datum/integrated_io/activate
#define IC_PINTYPE_PULSE_OUT		/datum/integrated_io/activate/out

// Data limits.
#define IC_MAX_LIST_LENGTH	500


#define INVESTIGATE_CIRCUIT			"circuit"

// сюда засуну ту хуйню которой нет в новой версии TG но которая нужна
//The amount of materials you get from a sheet of mineral like iron/diamond/glass etc
#define MINERAL_MATERIAL_AMOUNT 2000

#define BE_CLOSE TRUE		//in the case of a silicon, to select if they need to be next to the atom

GLOBAL_VAR_INIT(CELLRATE, 0.002)  // conversion ratio between a watt-tick and kilojoule
//shitcode goes here
GLOBAL_VAR_INIT(remote_control, TRUE)

GLOBAL_VAR_INIT(random_damage_goes_on, FALSE)

GLOBAL_LIST_EMPTY(ic_speakers)
//
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1


/datum/atom_hud/data/diagnostic/proc/add_to_hud(atom/movable/A)
	if(!istype(A))
		return FALSE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	hud_atoms[T.z] |= A

	for(var/mob/M in get_hud_users_for_z_level(T.z))
		if(!M.client)
			continue
		if(!hud_exceptions[M] || !(A in hud_exceptions[M]))
			for(var/hud_category in (hud_icons & A.active_hud_list))
				M.client.images |= A.active_hud_list[hud_category]
	return TRUE

/datum/atom_hud/data/diagnostic/proc/remove_from_single_hud(mob/M, atom/A)
	if(!M.client || !A || !A.hud_list)
		return

	for(var/hud_category in hud_icons)
		var/image/hud_image = A.hud_list?[hud_category]
		if(hud_image)
			M.client.images -= hud_image

/datum/atom_hud/data/diagnostic/proc/remove_from_hud(atom/movable/A)
	if(!istype(A) || !hud_atoms_all_z_levels[A]) // Використовуємо  hud_atoms_all_z_levels
		return FALSE

	var/turf/A_turf = get_turf(A)
	if(!A_turf)
		return FALSE

	hud_atoms[A_turf.z] -= A // Видаляємо  A  з  hud_atoms

	for(var/mob/M in hud_users_all_z_levels) // Використовуємо  hud_users_all_z_levels
		var/turf/M_turf = get_turf(M)
		if(!M_turf || M_turf.z != A_turf.z) // Перевірка Z-рівня
			continue
		remove_from_single_hud(M, A) // Викликаємо  remove_from_single_hud
	return TRUE

/proc/r_json_decode(text) //now I'm stupid
	for(var/s in GLOB.rus_unicode_conversion_hex)
		text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", s)
	return json_decode(text)

/proc/hextostr(str, safe=FALSE)
	if(!istext(str)||!str)
		return
	var/r
	var/c
	for(var/i = 1 to length(str)/2)
		c = hex2num(copytext(str,i*2-1,i*2+1))
		if(isnull(c))
			return null
		r += ascii2text(c)
	return r
/datum/reagents/proc/log_list(external_list)
	if((external_list && !length(external_list)) || !length(reagent_list))
		return "no reagents"

	var/list/data = list()
	if(external_list)
		for(var/r in external_list)
			data += "[r] ([round(external_list[r], 0.1)]u)"
	else
		for(var/datum/reagent/reagent as anything in reagent_list) //no reagents will be left behind
			data += "[reagent.type] ([round(reagent.volume, 0.1)]u)"
			//Using types because SOME chemicals (I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
	return english_list(data)
/obj/item/proc/GetCard()
/obj/item/card/data
	name = "карта с данными"
	desc = "Пластиковая магнитная карта для простого и быстрого хранения и передачи данных. У этой есть полоса, бегущая по середине."
	icon_state = "data_1"
	obj_flags = UNIQUE_RENAME
	var/function = "storage"
	var/data = "null"
	var/special = null
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	var/detail_color = COLOR_ASSEMBLY_ORANGE

/obj/proc/text2access(access_text)
	. = list()
	if(!access_text)
		return
	var/list/split = splittext(access_text,";")
	for(var/x in split)
		var/n = text2num(x)
		if(n)
			. += n
//Return a list with no duplicate entries
/proc/uniqueList(list/L)
	. = list()
	for(var/i in L)
		. |= i

