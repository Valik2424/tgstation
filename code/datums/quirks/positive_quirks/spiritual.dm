/datum/quirk/item_quirk/spiritual
	name = "Религиозный"
	desc = "Шанс, что молитвы будут услышаны, будет немного увеличен. Возможно."
	icon = FA_ICON_BIBLE
	value = 4
	mob_trait = TRAIT_SPIRITUAL
	gain_text = span_notice("Теперь вы верите в высшую силу.")
	lose_text = span_danger("Больше не верую!")
	medical_record_text = "Пациент сообщает о своей вере в некую силу."
	mail_goodies = list(
		/obj/item/book/bible/booze,
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/bedsheet/chaplain,
		/obj/item/toy/cards/deck/tarot,
		/obj/item/storage/fancy/candle_box,
	)

/datum/quirk/item_quirk/spiritual/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/fancy/candle_box, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/matches, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
