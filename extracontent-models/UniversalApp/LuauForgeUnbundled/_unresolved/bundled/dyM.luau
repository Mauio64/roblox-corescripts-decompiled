return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetUserRobux", function(value, value2)
	assert(type(value) == "string", "SetUserRobux: universeId must be a string")
	assert(type(value2) == "number", "SetUserRobux: robux must be a number")

	return { userId = value, robux = value2 }
end)
