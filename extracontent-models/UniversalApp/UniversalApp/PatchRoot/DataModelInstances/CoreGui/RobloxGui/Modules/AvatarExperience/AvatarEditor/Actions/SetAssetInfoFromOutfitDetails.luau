local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 10
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetAssetInfoFromOutfitDetails action expects assets to be a table")

	return {
		assets = p1,
		outfitModerationStatus = p2
	}
end)
