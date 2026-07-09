local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 9
	assert(type(p1) == "string", "SetUserRobux: universeId must be a string")
	assert(type(p2) == "number", "SetUserRobux: robux must be a number")

	return {
		userId = p1,
		robux = p2
	}
end)
