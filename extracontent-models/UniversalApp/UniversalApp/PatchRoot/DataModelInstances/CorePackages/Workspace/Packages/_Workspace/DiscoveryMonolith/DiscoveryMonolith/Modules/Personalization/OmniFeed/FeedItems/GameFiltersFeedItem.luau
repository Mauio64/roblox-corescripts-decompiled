local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local GameFilters = require(DiscoveryMonolithParent.GameFilters)
local FilterPillCarousel = GameFilters.FilterPillCarousel
local useGameFiltersSelector = GameFilters.DataStore.useGameFiltersSelector
local useGameFilterAnalyticsInfo = GameFilters.useGameFilterAnalyticsInfo
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local RoactAnalytics = require(DiscoveryMonolithParent.RoactServiceTags).RoactAnalytics
local AppEventIngestService = require(DiscoveryMonolithParent.RoactServiceTags).AppEventIngestService
local useDispatch = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local sendFilterImpressions = require(DiscoveryMonolithParent.GameFilters).sendFilterImpressions
local gamesFilterClickEvent = require(DiscoveryMonolithParent.GameFilters).gamesFilterClickEvent
local Modules = DiscoveryMonolith.Modules
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local FetchGamesPageData = require(Modules.LuaApp.Thunks.FetchGamesPageData)
local useGameFiltersFeedItemSideMargin = require(Modules.Personalization.OmniFeed.useGameFiltersFeedItemSideMargin)
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppChartsFilterOptionTextTag = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local FFlagLuaAppChartsActiveFilterChips = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsActiveFilterChips
local Games = GameSortGroups.Games

local function GameFiltersFeedItem(t1: {[any]: any}) -- line: 42
	-- upvalues: OmniFeedProps (copy), FFlagLuaAppCompositionAlways (copy), useGameFiltersSelector (copy), Games (copy), useGameFilterAnalyticsInfo (copy), React (copy), useGameFiltersFeedItemSideMargin (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), AppEventIngestService (copy), sendFilterImpressions (copy), gamesFilterClickEvent (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy), FetchGamesPageData (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), FilterPillCarousel (copy)
	local v27 = t1[OmniFeedProps.key]
	local v28 = not not FFlagLuaAppCompositionAlways or v27.appCompositionEnabled
	local v29 = useGameFiltersSelector(Games)
	local v30 = useGameFilterAnalyticsInfo(t1.gameSortId, t1.sortIndex)
	local v31 = React.useRef(nil)
	local v32 = if FFlagLuaAppCompositionAlways then nil else useGameFiltersFeedItemSideMargin(v31.current)
	local v33 = useDispatch()
	local v34 = useRoactService(RoactNetworking)
	local v35 = useRoactService(RoactAnalytics)
	local v36 = useRoactService(AppEventIngestService)
	local v37 = React.useCallback(function(t2: {[any]: any}) -- line: 63
		-- upvalues: sendFilterImpressions (copy), v36 (copy), v29 (copy), v27 (copy), v30 (copy)
		sendFilterImpressions(v36, t2, v29 and v29.allFilters or {}, v27.appPage, v30)
	end, {
		v36,
		v29,
		v27.appPage,
		v30
	})
	local v38 = React.useCallback(function(s1: string, s2: string, s3: string, s4: string?, s5: string?, s6: string?, b1: boolean?) -- line: 74
		-- upvalues: gamesFilterClickEvent (copy), v36 (copy), v27 (copy), v30 (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
		gamesFilterClickEvent(v36, v27.appPage, {
			buttonName = s1,
			filterId = s2,
			selectedOptionId = s3,
			previousOptionId = s4,
			gameSetTypeId = v30.gameSetTypeId,
			gameSetTargetId = v30.gameSetTargetId,
			sortPos = v30.sortPos,
			selectedOptionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else s5,
			previousOptionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else s6,
			isActive = if not FFlagLuaAppChartsActiveFilterChips then nil else b1
		})
	end, {
		v36,
		v27.appPage,
		v30
	})
	local v39 = React.useCallback(function(s7: string, s8: string) -- line: 103
		-- upvalues: v33 (copy), FetchGamesPageData (copy), v34 (copy), v35 (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy)
		local t3 = {
			[s7] = s8
		}

		return v33(FetchGamesPageData(v34, v35, nil, t3, not not FFlagLuaAppChartsResetFetchingStatusOnFilterChange or nil))
	end, {
		v34,
		v35,
		if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then nil else v33
	})

	if v29 and #v29.allFilters > 0 then
		return React.createElement(FilterPillCarousel, {
			title = t1.topicName,
			filters = v29.allFilters,
			sideMargin = if not v28 then v32 else nil,
			sortIndex = t1.sortIndex,
			onFilterApplied = v39,
			containerRef = v31,
			pageContext = v27.appPage,
			dataUpdatedTimestamp = v29.updatedTimestamp,
			analyticsInfo = v30,
			scrollViewPositionChangedSignal = v27.scrollViewPositionChangedSignal,
			sendImpressions = v37,
			sendFilterClick = v38
		})
	end

	return nil
end

return GameFiltersFeedItem
