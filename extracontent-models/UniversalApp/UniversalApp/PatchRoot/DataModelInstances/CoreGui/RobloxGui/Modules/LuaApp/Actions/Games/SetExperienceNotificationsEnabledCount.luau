local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 8
	assert(type(p1) == "number", "SetCanTurnOnExperienceNotificationsCount: count must be a number")

	return {
		count = p1
	}
end)
