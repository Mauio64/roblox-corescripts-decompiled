local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 8
	assert(type(p1) == "number", "SetCanTurnOnExperienceNotificationsLimit: limit must be a number")

	return {
		limit = p1
	}
end)
