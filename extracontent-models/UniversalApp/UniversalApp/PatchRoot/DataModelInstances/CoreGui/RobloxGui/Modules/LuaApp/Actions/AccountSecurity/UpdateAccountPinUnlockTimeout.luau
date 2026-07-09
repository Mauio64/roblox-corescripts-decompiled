local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	assert(p1 == nil or typeof(p1) == "DateTime", "Expected the passed unlock time must be a valid `DateTime` or nil")

	return {
		accountPinUnlockedUntil = p1
	}
end)
