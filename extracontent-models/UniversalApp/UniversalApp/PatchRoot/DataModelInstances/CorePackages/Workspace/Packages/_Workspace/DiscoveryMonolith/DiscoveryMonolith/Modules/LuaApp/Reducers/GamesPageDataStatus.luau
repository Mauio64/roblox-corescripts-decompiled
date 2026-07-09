local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local SetGamesPageDataStatus = require(Modules.LuaApp.Actions.SetGamesPageDataStatus)
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange

return function(p1, p2) -- line: 11
	-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus (copy), SetGamesPageDataStatus (copy)
	local v9 = p1 or if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then RetrievalStatus.NotStarted else {
		isRefreshFetch = false,
		status = RetrievalStatus.NotStarted
	}

	if p2.type == SetGamesPageDataStatus.name then
		if FFlagLuaAppChartsResetFetchingStatusOnFilterChange then
			return {
				status = p2.status,
				isRefreshFetch = p2.isRefreshFetch or false
			}
		end

		v9 = p2.status
	end

	return v9
end
