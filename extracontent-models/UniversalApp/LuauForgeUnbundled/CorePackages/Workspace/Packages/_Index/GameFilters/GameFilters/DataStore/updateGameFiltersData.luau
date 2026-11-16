require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

local GameFilterModel = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/DataStore/GameFilterModel")
local SetGameFilters = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/DataStore/SetGameFilters")

return function(object, p2, list)
	if not list or #list == 0 then
		warn("Found no filters in this sort")
	end

	local v5 = {}

	for k, item in list do
		table.insert(v5, (GameFilterModel.fromExploreJsonData(item)))
	end

	object:dispatch(SetGameFilters(p2, v5, (tick())))
end
