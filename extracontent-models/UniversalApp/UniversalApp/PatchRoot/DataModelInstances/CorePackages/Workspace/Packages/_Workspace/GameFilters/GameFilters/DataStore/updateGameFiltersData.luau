local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent

require(GameFiltersParent.DiscoveryTypes)

local GameFilterModel = require(GameFilters.DataStore.GameFilterModel)
local SetGameFilters = require(GameFilters.DataStore.SetGameFilters)

return function(p1, p2, p3) -- line: 9
	-- upvalues: GameFilterModel (copy), SetGameFilters (copy)
	if not p3 or #p3 == 0 then
		warn("Found no filters in this sort")
	end

	local t1 = {}

	for _, v10 in p3 do
		table.insert(t1, (GameFilterModel.fromExploreJsonData(v10)))
	end

	local timestamp = tick()

	p1:dispatch(SetGameFilters(p2, t1, timestamp))
end
