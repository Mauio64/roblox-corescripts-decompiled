local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetUserInventoryRecommendationsFetchStatus = require(Modules.AvatarExperience.AvatarEditor.Actions.SetUserInventoryRecommendationsFetchStatus)

return Rodux.createReducer({}, {
	[SetUserInventoryRecommendationsFetchStatus.name] = function(p1, p2) -- line: 25
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.searchUuid] = p2.status
		})
	end
})
