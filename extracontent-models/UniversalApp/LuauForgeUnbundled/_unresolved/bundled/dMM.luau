local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetAssetInfoFromSortResults", function(p2)
	module.isType(p2, "table", "SetAssetInfoFromSortResults expects sortResults")

	return { sortResults = p2 }
end)
