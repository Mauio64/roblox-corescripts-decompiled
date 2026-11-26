return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetGameFollowingStatus", function(value, p2, p3)
	assert(type(value) == "string", "SetGameFollowingStatus: universeId must be a string")
	assert(type(p2) == "boolean", "SetGameFollowingStatus: canFollow must be a boolean")
	assert(type(p3) == "boolean", "SetGameFollowingStatus: isFollowed must be a boolean")

	return { universeId = value, canFollow = p2, isFollowed = p3 }
end)
