local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 9
	assert(type(p1) == "string", "SetGameFavorite: universeId must be a string")
	assert(type(p2) == "boolean", "SetGameFavorite: isFavorited must be a boolean")

	return {
		universeId = p1,
		isFavorited = p2
	}
end)
