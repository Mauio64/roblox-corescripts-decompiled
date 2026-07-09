local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 11
	return {
		searchUuid = p1,
		parameters = p2
	}
end)
