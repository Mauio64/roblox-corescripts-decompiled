local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 8
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "SetCollectibleResaleData expects collectibleItemId")
	ArgCheck.isType(p2, "table", "SetCollectibleResaleData expects resaleData")

	return {
		collectibleItemId = p1,
		resaleData = p2
	}
end)
