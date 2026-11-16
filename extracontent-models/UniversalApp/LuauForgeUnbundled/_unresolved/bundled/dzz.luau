return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetGamePrivateServersEnabled", function(value, p2)
	assert(type(value) == "string", "SetGamePrivateServersEnabled: universeId must be a string")
	assert(type(p2) == "boolean", "SetGamePrivateServersEnabled: isFavorited must be a boolean")

	return { universeId = value, privateServersEnabled = p2 }
end)
