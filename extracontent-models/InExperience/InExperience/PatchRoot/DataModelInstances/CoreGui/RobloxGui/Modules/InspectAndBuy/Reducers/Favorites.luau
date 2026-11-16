local CorePackages = game:GetService("CorePackages")
local parent = script.Parent
local Rodux = require(CorePackages.Packages.Rodux)
local FavoriteAssets = require(parent.FavoriteAssets)
local FavoriteBundles = require(parent.FavoriteBundles)

return Rodux.combineReducers({ assets = FavoriteAssets, bundles = FavoriteBundles })
