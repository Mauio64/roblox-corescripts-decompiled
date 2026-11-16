return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetExperienceNotificationsEnabledCount", function(value)
	assert(type(value) == "number", "SetCanTurnOnExperienceNotificationsCount: count must be a number")

	return { count = value }
end)
