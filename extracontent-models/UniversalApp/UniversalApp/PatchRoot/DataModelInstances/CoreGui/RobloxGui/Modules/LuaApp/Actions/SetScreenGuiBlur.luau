local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2, p3) -- line: 4
	return {
		source = p1,
		blur = p2,
		displayOrder = p3
	}
end)
