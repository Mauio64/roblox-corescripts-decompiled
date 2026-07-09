local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(Parent.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange

return makeActionCreator(script.Name, function(p1, b1: boolean?) -- line: 8
	-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy)
	assert(type(p1) == "string", string.format("SetGamesPageDataStatus action expects status to be a string, was %s", (type(p1))))

	return {
		status = p1,
		isRefreshFetch = if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then nil else b1
	}
end)
