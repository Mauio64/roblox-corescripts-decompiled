return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetGameFollow", function(value, p2)
	assert(type(value) == "string", "SetGameFollow: universeId must be a string")
	assert(type(p2) == "boolean", "SetGameFollow: isFollowed must be a boolean")

	return { universeId = value, isFollowed = p2 }
end)
