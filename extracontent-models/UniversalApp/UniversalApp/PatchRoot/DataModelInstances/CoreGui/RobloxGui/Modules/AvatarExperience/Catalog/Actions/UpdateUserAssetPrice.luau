local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "userAssetId")
	ArgCheck.isTypeOrNil(p2, "number", "priceInRobux")

	return {
		userAssetId = p1,
		priceInRobux = p2
	}
end)
