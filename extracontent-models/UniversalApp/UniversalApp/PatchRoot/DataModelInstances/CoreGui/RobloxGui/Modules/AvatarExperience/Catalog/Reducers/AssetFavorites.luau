local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetAssetFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetAssetFavorite)

return Rodux.createReducer({}, {
	[SetAssetFavorite.name] = function(p1, p2) -- line: 19
		-- upvalues: Cryo (copy)
		local assetId = p2.assetId

		return Cryo.Dictionary.join(p1, {
			[assetId] = p2.isFavorited
		})
	end
})
