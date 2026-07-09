local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(t1: {[any]: any}, p1) -- line: 21
	return {
		boundInputs = t1,
		focusController = p1
	}
end)
