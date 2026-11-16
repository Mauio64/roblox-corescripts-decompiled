local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local parent = script.Parent.Parent
local SetFavoriteAsset = require(parent.Actions.SetFavoriteAsset)

return Rodux.createReducer({}, {
	[SetFavoriteAsset.name] = function(p, p2)
		local id = p2.id
		local isFavorite = p2.isFavorite
		return Cryo.Dictionary.join(p, { [id] = isFavorite })
	end
})
