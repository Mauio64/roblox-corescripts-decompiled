local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 10
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetAssetInfoFromSortResults expects sortResults")

	return {
		sortResults = p1
	}
end)
