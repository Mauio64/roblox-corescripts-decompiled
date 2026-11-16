local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dSc")
local module2 = require("@luauforge/bundled/dSg")

return Rodux.combineReducers({
	AvailableToSellAssets = module,
	CurrentlySellingAssets = module2
})
