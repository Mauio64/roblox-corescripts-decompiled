local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local parent = script.Parent.Parent
local SetFavoriteBundle = require(parent.Actions.SetFavoriteBundle)

return Rodux.createReducer({}, {
	[SetFavoriteBundle.name] = function(p, p2)
		local id = p2.id
		local isFavorite = p2.isFavorite
		return Cryo.Dictionary.join(p, { [id] = isFavorite })
	end
})
