local CorePackages = game:GetService("CorePackages")
local scriptParent = script.Parent
local Rodux = require(CorePackages.Packages.Rodux)
local FavoriteAssets = require(scriptParent.FavoriteAssets)
local FavoriteBundles = require(scriptParent.FavoriteBundles)

return Rodux.combineReducers({
	assets = FavoriteAssets,
	bundles = FavoriteBundles
})
