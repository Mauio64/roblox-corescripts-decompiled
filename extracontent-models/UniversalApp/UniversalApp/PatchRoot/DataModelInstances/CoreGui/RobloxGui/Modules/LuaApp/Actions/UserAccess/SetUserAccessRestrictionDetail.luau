local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 10
	return {
		restrictionDetail = p1
	}
end)
