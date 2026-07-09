local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 7
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join({
		updateRequested = true
	}, p1 or {})
end)
