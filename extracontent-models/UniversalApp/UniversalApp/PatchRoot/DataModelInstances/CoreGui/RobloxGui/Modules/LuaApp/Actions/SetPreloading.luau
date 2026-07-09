local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 4
	return {
		isPreloading = p1
	}
end)
