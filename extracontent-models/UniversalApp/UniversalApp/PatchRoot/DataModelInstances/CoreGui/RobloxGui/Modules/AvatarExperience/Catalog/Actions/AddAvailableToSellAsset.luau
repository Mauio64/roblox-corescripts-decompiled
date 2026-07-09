local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "assetId")
	ArgCheck.isType(p2, "string", "userAssetId")

	return {
		assetId = p1,
		userAssetId = p2
	}
end)
