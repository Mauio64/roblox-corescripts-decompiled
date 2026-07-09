local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetTopics = require(Modules.AvatarExperience.Catalog.Actions.SetTopics)

return Rodux.createReducer({}, {
	[SetTopics.name] = function(t1: {[any]: any}, p1) -- line: 19
		-- upvalues: CatalogUtils (copy), Cryo (copy)
		local v10 = CatalogUtils.getTopicRequestKey(p1.selectedTopics, p1.initialItems, p1.searchKeyword)

		return Cryo.Dictionary.join(t1, {
			[v10] = p1.newTopics
		})
	end
})
