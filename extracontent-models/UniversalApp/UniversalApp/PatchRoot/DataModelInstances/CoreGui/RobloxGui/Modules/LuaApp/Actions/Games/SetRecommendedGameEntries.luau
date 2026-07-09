local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 4
	return {
		universeId = p1,
		entries = p2
	}
end)
