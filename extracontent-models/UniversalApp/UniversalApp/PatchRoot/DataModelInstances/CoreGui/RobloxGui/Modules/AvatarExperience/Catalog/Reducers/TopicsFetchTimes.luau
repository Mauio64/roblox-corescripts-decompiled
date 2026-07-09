local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local SetTopics = require(Modules.AvatarExperience.Catalog.Actions.SetTopics)

return Rodux.createReducer({}, {
	[SetTopics.name] = function(t1: {[any]: any}, p1) -- line: 21
		-- upvalues: CatalogUtils (copy), Cryo (copy)
		local v10 = CatalogUtils.getTopicRequestKey(p1.selectedTopics, p1.initialItems, p1.searchKeyword)
		local timestamp = tick()

		return Cryo.Dictionary.join(t1, {
			[v10] = timestamp
		})
	end
})
