local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Catalog.Models.SortResults)

local AppendUserInventoryRecommendations = require(Modules.AvatarExperience.AvatarEditor.Actions.AppendUserInventoryRecommendations)

return Rodux.createReducer({}, {
	[AppendUserInventoryRecommendations.name] = function(t1: {[any]: any}, p1) -- line: 36
		-- upvalues: Cryo (copy)
		local v9 = t1[p1.searchUuid]

		if not v9 or p1.forceUpdate then
			local v10 = Cryo.Dictionary.join(p1.sortResults, {
				initialStorageTime = tick()
			})

			return Cryo.Dictionary.join(t1, {
				[p1.searchUuid] = v10
			})
		end

		local t2 = {
			items = Cryo.List.join(v9.items, p1.sortResults.items),
			initialStorageTime = v9.initialStorageTime,
			nextPageCursor = p1.sortResults.nextPageCursor,
			previousPageCursor = p1.sortResults.previousPageCursor,
			keyword = p1.sortResults.keyword
		}

		return Cryo.Dictionary.join(t1, {
			[p1.searchUuid] = t2
		})
	end
})
