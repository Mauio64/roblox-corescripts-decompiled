local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 15
	return {
		searchUuid = p1,
		searchType = p2
	}
end)
