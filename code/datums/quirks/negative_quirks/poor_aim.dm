/datum/quirk/poor_aim
	name = "Плохо стреляющий"
	desc = "Мои навыки обращения с оружием оставляют желать лучшего."
	icon = FA_ICON_BULLSEYE
	value = -4
	medical_record_text = "У пациента сильная дрожь в обеих руках."
	hardcore_value = 3
	mail_goodies = list(/obj/item/cardboard_cutout) // for target practice

/datum/quirk/poor_aim/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOB_FIRED_GUN, PROC_REF(on_mob_fired_gun))

/datum/quirk/poor_aim/remove(client/client_source)
	UnregisterSignal(quirk_holder, COMSIG_MOB_FIRED_GUN)

/datum/quirk/poor_aim/proc/on_mob_fired_gun(mob/user, obj/item/gun/gun_fired, target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	bonus_spread_values[MIN_BONUS_SPREAD_INDEX] += 10
	bonus_spread_values[MAX_BONUS_SPREAD_INDEX] += 35
