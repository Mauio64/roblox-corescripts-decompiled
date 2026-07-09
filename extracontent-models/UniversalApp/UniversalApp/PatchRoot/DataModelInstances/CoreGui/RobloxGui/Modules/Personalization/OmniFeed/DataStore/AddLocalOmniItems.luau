local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 4
	return {
		localItems = p1,
		appPage = p2
	}
end)
