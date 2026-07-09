local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2, p3) -- line: 10
	assert(type(p1) == "string", "SetGameFollowingStatus: universeId must be a string")
	assert(type(p2) == "boolean", "SetGameFollowingStatus: canFollow must be a boolean")
	assert(type(p3) == "boolean", "SetGameFollowingStatus: isFollowed must be a boolean")

	return {
		universeId = p1,
		canFollow = p2,
		isFollowed = p3
	}
end)
