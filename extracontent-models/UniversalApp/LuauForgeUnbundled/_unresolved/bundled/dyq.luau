return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetExperienceNotificationsEnabledLimit", function(value)
	assert(type(value) == "number", "SetCanTurnOnExperienceNotificationsLimit: limit must be a number")

	return { limit = value }
end)
