local GameFilters = script:FindFirstAncestor("GameFilters")

local SetGameFilters = require(GameFilters.DataStore.SetGameFilters)

local parent = GameFilters.Parent
local Cryo = require(parent.Cryo)
require(parent.DiscoveryTypes)

return {
	key = "GameFiltersKey",
	reducer = function(options, data)
		local v = options or {}

		if data.type ~= SetGameFilters.name then
			return v
		end

		return (Cryo.Dictionary.join(v, {
			[data.groupId] = { allFilters = data.filters, updatedTimestamp = data.updatedTimestamp }
		}))
	end
}
