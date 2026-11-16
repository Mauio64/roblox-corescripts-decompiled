local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
require(parent.DiscoveryTypes)

local GameFilterModel = require(GameFilters.DataStore.GameFilterModel)
local SetGameFilters = require(GameFilters.DataStore.SetGameFilters)

return function(object, p, list)
	if not list or #list == 0 then
		warn("Found no filters in this sort")
	end

	local v = {}

	for _, item in list do
		table.insert(v, (GameFilterModel.fromExploreJsonData(item)))
	end

	object:dispatch(SetGameFilters(p, v, (tick())))
end
