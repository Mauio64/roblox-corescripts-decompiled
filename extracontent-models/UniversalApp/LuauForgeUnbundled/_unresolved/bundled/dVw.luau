local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dVx")
local module2 = require("@luauforge/bundled/dVB")

return Rodux.combineReducers({
	AvailableToSellAssets = module,
	CurrentlySellingAssets = module2
})
