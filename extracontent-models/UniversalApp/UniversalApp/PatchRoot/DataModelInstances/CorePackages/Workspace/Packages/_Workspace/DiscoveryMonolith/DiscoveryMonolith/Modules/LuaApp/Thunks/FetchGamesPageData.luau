local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local Promise = require(DiscoveryMonolithParent.Promise)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local ApiFetchSortTokens = require(Modules.LuaApp.Thunks.Games.ApiFetchSortTokens)
local SetGamesPageDataStatus = require(Modules.LuaApp.Actions.SetGamesPageDataStatus)
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange
local FVariable = settings():GetFVariable("LuaAppsDiagPageLoadTimeGames")

return function(p1, p2, p3, p4, b1: boolean?) -- line: 17
	-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus (copy), Promise (copy), SetGamesPageDataStatus (copy), ApiFetchSortTokens (copy), GameSortGroups (copy), FVariable (copy)
	return function(p5) -- line: 18
		-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus (copy), Promise (copy), SetGamesPageDataStatus (copy), b1 (copy), ApiFetchSortTokens (copy), p1 (copy), GameSortGroups (copy), p3 (copy), p4 (copy), p2 (copy), FVariable (copy)
		if ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then p5:getState().Startup.GamesPageDataStatus else p5:getState().Startup.GamesPageDataStatus.status)) == RetrievalStatus.Fetching then
			return Promise.resolve("games page data is already fetching")
		end

		local timestamp = tick()

		p5:dispatch(SetGamesPageDataStatus(RetrievalStatus.Fetching, if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then nil else b1))

		return p5:dispatch(ApiFetchSortTokens(p1, GameSortGroups.Games, p3, p4)):andThen(function() -- line: 41
			-- upvalues: p5 (copy), SetGamesPageDataStatus (copy), RetrievalStatus (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), b1 (copy), p3 (copy), timestamp (copy), p2 (copy), FVariable (copy), Promise (copy)
			p5:dispatch(SetGamesPageDataStatus(RetrievalStatus.Done, if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then nil else b1))

			if not p3 or p3 == "" then
				local v18 = (tick() - timestamp) * 1000

				p2.Diag:reportStats(FVariable, v18)
			end

			return Promise.resolve()
		end, function(p6) -- line: 57
			-- upvalues: p5 (copy), SetGamesPageDataStatus (copy), RetrievalStatus (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), b1 (copy), Promise (copy)
			p5:dispatch(SetGamesPageDataStatus(RetrievalStatus.Failed, if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then nil else b1))

			return Promise.reject(p6)
		end)
	end
end
