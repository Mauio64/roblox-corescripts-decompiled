local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetBundleFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetBundleFavorite)

return Rodux.createReducer({}, {
	[SetBundleFavorite.name] = function(p1, p2) -- line: 19
		-- upvalues: Cryo (copy)
		local bundleId = p2.bundleId

		return Cryo.Dictionary.join(p1, {
			[bundleId] = p2.isFavorited
		})
	end
})
