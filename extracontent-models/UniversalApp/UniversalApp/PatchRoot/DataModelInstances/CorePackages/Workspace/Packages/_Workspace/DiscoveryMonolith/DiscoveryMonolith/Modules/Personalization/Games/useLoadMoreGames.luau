local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local AppLogging = require(DiscoveryMonolithParent.RoactServiceTags).AppLogging
local useDispatch = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useDispatch
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local DEFAULT_GAME_FETCH_COUNT = DiscoveryTypes.Constants.DEFAULT_GAME_FETCH_COUNT
local reportWarning = require(DiscoveryMonolithParent.DiscoveryAnalytics).Points.reportWarning
local Modules = DiscoveryMonolith.Modules
local FetchDataWithErrorToasts = require(Modules.LuaApp.Thunks.FetchDataWithErrorToasts)
local ApiFetchGamesInSort = require(Modules.LuaApp.Thunks.Games.ApiFetchGamesInSort)
local ApiFetchOmniRecommendationsMetadata = require(Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendationsMetadata)
local FFlagLuaAppLogOmniRecommendationsMetadata = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppLogOmniRecommendationsMetadata

local function useLoadMoreGames(p1, p2, s1: string, s2: string?, n1: number?) -- line: 30
	-- upvalues: RetrievalStatus (copy), useRoactService (copy), RoactNetworking (copy), AppLogging (copy), useDispatch (copy), React (copy), FetchDataWithErrorToasts (copy), ApiFetchOmniRecommendationsMetadata (copy), DEFAULT_GAME_FETCH_COUNT (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy), DiscoveryTypes (copy), ApiFetchGamesInSort (copy), reportWarning (copy)
	local v23 = not not p1 and (p1.hasMoreRows or false)
	local v24 = s1 == RetrievalStatus.Fetching
	local v25 = v23 and not v24
	local v26 = useRoactService(RoactNetworking)
	local v27 = useRoactService(AppLogging)
	local v28 = useDispatch()

	return (React.useCallback(function() -- line: 47
		-- upvalues: v25 (copy), p1 (copy), p2 (copy), v28 (copy), FetchDataWithErrorToasts (copy), ApiFetchOmniRecommendationsMetadata (copy), v26 (copy), s2 (copy), n1 (copy), DEFAULT_GAME_FETCH_COUNT (copy), v27 (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy), DiscoveryTypes (copy), ApiFetchGamesInSort (copy), reportWarning (copy)
		if not v25 then
			return
		end

		if p1 == nil or p2 == nil then
			return
		end

		if p2:isOmni() then
			return v28((FetchDataWithErrorToasts((ApiFetchOmniRecommendationsMetadata(v26, s2, n1, DEFAULT_GAME_FETCH_COUNT, v27, if not FFlagLuaAppLogOmniRecommendationsMetadata then nil else "useLoadMoreGames")))))
		end

		if p2.dataSource == DiscoveryTypes.DataSourceType.ExploreApi then
			return v28((FetchDataWithErrorToasts((ApiFetchGamesInSort(v26, p2, true, {
				startRows = p1.rowsRequested,
				maxRows = DEFAULT_GAME_FETCH_COUNT,
				exclusiveStartId = p1.nextPageExclusiveStartId,
				pageToken = p1.nextPageToken
			})))))
		end

		reportWarning(v27, "DataFetch", `Tried to fetch more games for unsupported API. sort: { p2.name }, API: { p2.dataSource }`)
	end, {
		v25,
		v26,
		v28,
		s2,
		p2,
		p1,
		n1,
		v27
	}))
end

return useLoadMoreGames
