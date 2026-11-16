local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/dsD")
local filterPillCarousel = module2.FilterPillCarousel
local useGameFiltersSelector = module2.DataStore.useGameFiltersSelector
local useGameFilterAnalyticsInfo = module2.useGameFilterAnalyticsInfo
local gameSortGroups = require("@luauforge/bundled/dqn").GameSortGroups
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local roactAnalytics = require("@luauforge/bundled/drk").RoactAnalytics
local appEventIngestService = require("@luauforge/bundled/drk").AppEventIngestService
local useDispatch = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/dsp").useRoactService

local sendFilterImpressions = require("@luauforge/bundled/dsD").sendFilterImpressions
local gamesFilterClickEvent = require("@luauforge/bundled/dsD").gamesFilterClickEvent

local module3 = require("@luauforge/bundled/dvt")
local module4 = require("@luauforge/bundled/dtO")

local module5 = require("@luauforge/bundled/dvw")
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways
local fFlagLuaAppChartsFilterOptionTextTag = require("@luauforge/bundled/dqB").FFlagLuaAppChartsFilterOptionTextTag

local games = gameSortGroups.Games

local function GameFiltersFeedItem(data)
	local v5 = data[module3.key]
	local v6 = fFlagLuaAppCompositionAlways and true or v5.appCompositionEnabled

	local v7 = useGameFiltersSelector(games)
	local v8 = useGameFilterAnalyticsInfo(data.gameSortId, data.sortIndex)

	local ref = module.useRef(nil)

	local v9 = if not fFlagLuaAppCompositionAlways then module5(ref.current) else nil

	if v6 then
		v9 = nil
	end

	local v10 = useDispatch()
	local v11 = useRoactService(roactNetworking)
	local v12 = useRoactService(roactAnalytics)

	local v13 = useRoactService(appEventIngestService)

	local v14 = module.useCallback(function(p2)
		sendFilterImpressions(v13, p2, v7 and v7.allFilters or {}, v5.appPage, v8)
	end, { v13, v7, v5.appPage, v8 })

	local v15 = module.useCallback(
		function(p2, p3, p4, p5, selectedOptionContextTag, previousOptionContextTag, isActive)
			local appPage = v5.appPage
			local v18 = {
				buttonName = p2,
				filterId = p3,
				selectedOptionId = p4,
				previousOptionId = p5,
				gameSetTypeId = v8.gameSetTypeId,
				gameSetTargetId = v8.gameSetTargetId,
				sortPos = v8.sortPos,
				selectedOptionContextTag = 0,
				previousOptionContextTag = 0,
				isActive = 0
			}

			if not fFlagLuaAppChartsFilterOptionTextTag then
				selectedOptionContextTag = nil
			end

			v18.selectedOptionContextTag = selectedOptionContextTag

			if not fFlagLuaAppChartsFilterOptionTextTag then
				previousOptionContextTag = nil
			end

			v18.previousOptionContextTag = previousOptionContextTag

			v18.isActive = isActive
			gamesFilterClickEvent(v13, appPage, v18)
		end,
		{ v13, v5.appPage, v8 }
	)

	local v16 = module.useCallback(function(p2, p3)
		return v10(module4(v11, v12, nil, { [p2] = p3 }, true))
	end, { v11, v12, v10 })

	if v7 and #v7.allFilters > 0 then
		return module.createElement(filterPillCarousel, {
			title = data.topicName,
			filters = v7.allFilters,
			sideMargin = v9,
			sortIndex = data.sortIndex,
			onFilterApplied = v16,
			containerRef = ref,
			pageContext = v5.appPage,
			dataUpdatedTimestamp = v7.updatedTimestamp,
			analyticsInfo = v8,
			scrollViewPositionChangedSignal = v5.scrollViewPositionChangedSignal,
			sendImpressions = v14,
			sendFilterClick = v15
		})
	end

	return nil
end

return GameFiltersFeedItem
