local GameFilters = script:FindFirstAncestor("GameFilters")
local SetGameFilters = require(GameFilters.DataStore.SetGameFilters)
local GameFiltersParent = GameFilters.Parent
local Cryo = require(GameFiltersParent.Cryo)

require(GameFiltersParent.DiscoveryTypes)

return {
	key = "GameFiltersKey",
	reducer = function(p1, p2) -- line: 11
		-- upvalues: SetGameFilters (copy), Cryo (copy)
		local v7 = p1 or {}

		if p2.type == SetGameFilters.name then
			v7 = Cryo.Dictionary.join(v7, {
				[p2.groupId] = {
					allFilters = p2.filters,
					updatedTimestamp = p2.updatedTimestamp
				}
			})
		end

		return v7
	end
}
