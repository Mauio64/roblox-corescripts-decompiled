local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetUserAssetsFromSellPageAndResellers", function(p2)
	module.isType(p2, "table", "userAssets")

	return { userAssets = p2 }
end)
