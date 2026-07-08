local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local SetFavoriteAsset = require(ParentParent.Actions.SetFavoriteAsset)

return Rodux.createReducer({}, {
	[SetFavoriteAsset.name] = function(p1, p2) -- line: 8
		-- upvalues: Cryo (copy)
		local id = p2.id
		local isFavorite = p2.isFavorite

		return Cryo.Dictionary.join(p1, {
			[id] = isFavorite
		})
	end
})
