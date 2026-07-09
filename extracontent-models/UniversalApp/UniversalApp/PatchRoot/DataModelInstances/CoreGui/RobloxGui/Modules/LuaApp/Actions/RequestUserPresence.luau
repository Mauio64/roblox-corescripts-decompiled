local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 5
	return {
		userId = p1
	}
end)
