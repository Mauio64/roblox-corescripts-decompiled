return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetGameFavorite", function(value, p2)
	assert(type(value) == "string", "SetGameFavorite: universeId must be a string")
	assert(type(p2) == "boolean", "SetGameFavorite: isFavorited must be a boolean")

	return { universeId = value, isFavorited = p2 }
end)
