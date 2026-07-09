local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 8
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "SetCollectibleResellersInstances expects collectibleItemId")
	ArgCheck.isType(p2, "table", "SetCollectibleResellersInstances expects collectibleItemInstances")

	return {
		collectibleItemId = p1,
		collectibleItemInstances = p2
	}
end)
