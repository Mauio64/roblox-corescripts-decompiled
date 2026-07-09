local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 9
	assert(type(p1) == "string", "SetGamePrivateServersEnabled: universeId must be a string")
	assert(type(p2) == "boolean", "SetGamePrivateServersEnabled: isFavorited must be a boolean")

	return {
		universeId = p1,
		privateServersEnabled = p2
	}
end)
