local SetGameFilters = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/DataStore/SetGameFilters")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

return {
	key = "GameFiltersKey",
	reducer = function(options, data)
		local v5 = options or {}

		if data.type ~= SetGameFilters.name then
			return v5
		end

		v5 = Cryo.Dictionary.join(v5, {
			[data.groupId] = {
				allFilters = data.filters,
				updatedTimestamp = data.updatedTimestamp
			}
		})

		return v5
	end
}
