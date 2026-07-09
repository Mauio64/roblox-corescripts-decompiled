local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local AvailableToSellAssets = require(scriptParent.AvailableToSellAssets)
local CurrentlySellingAssets = require(scriptParent.CurrentlySellingAssets)

return Rodux.combineReducers({
	AvailableToSellAssets = AvailableToSellAssets,
	CurrentlySellingAssets = CurrentlySellingAssets
})
