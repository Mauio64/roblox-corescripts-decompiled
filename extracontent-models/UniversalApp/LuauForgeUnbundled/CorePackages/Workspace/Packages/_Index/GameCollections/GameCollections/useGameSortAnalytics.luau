local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppHooks").useRoactService
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactServiceTags").RoactAnalyticsCommonGameEvents
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactServiceTags").AppEventIngestService
local gamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics").Events.gamePlayIntent
local reportGameAttributionError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics").Events.reportGameAttributionError
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Loggers").mutedError
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.RoactRodux.useStore
local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes
local gameSortLoadSource = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAvailability").GameSortLoadSource
local feedScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/ScrollTelemetry").feedScroll
local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UnifiedLogging").calculateRowPositionFields
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")

local fFlagLuaAppLogGameAttributionError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppLogGameAttributionError
local fFlagLuaAppGameDetailsAttributionFix = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameDetailsAttributionFix
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

local v5 = {}

local function mergeAnalyticsData(p2, p3)
	if not (p2 or p3) then
		return nil
	end

	local joined = Cryo.Dictionary.join(p2 or v5, p3 or v5)

	if next(joined) then
		return joined
	end

	return nil
end

local v6 = fFlagLuaAppLogGameAttributionError
	and { GameDetail = "GameDetail", PlayIntent = "PlayIntent" }
	or nil

local function getGameSetTypeId(p2, p3, p4)
	if p2 == nil then
		return nil
	end

	if p3 or p4 then
		return p2.topicId
	end

	return p2.gameSetTypeId
end

local function getGameSetTargetId(p2, p3)
	if p3 or p2 == nil then
		return nil
	end

	return p2.gameSetTargetId
end

local function getAppliedFilters(p2, p3)
	if p3 or not p2 then
		return nil
	end

	return p2.appliedFilters
end

local function useGameSortAnalytics(data, p2, p3, pageName, p4, list, p5, p6)
	local v7 = useStore()
	local v8 = useRoactService(roactAnalyticsCommonGameEvents)
	local v9 = useRoactService(appEventIngestService)

	local v10 = pageName == appPage.SearchPage
	local v11 = if data ~= nil then (if p2 or v10 then data.topicId else data.gameSetTypeId) else nil

	local gameSetTargetId = if not (p2 or data == nil) then data.gameSetTargetId else nil

	local appliedFilters = if not (p2 or not data) then data.appliedFilters else nil
	local v12

	if pageName == appPage.Home and data and data.topicId then
		v12 = gameSortLoadSource.getSortLoadSource(data.topicId)
	else
		v12 = nil
	end

	local sortSubId = if data then data.sortSubId else nil
	local analyticsData = if data then data.analyticsData else nil

	local function fn(data2, referralSource, p7, p8, p9, actionType)
		if fFlagLuaAppLogGameAttributionError then
			local v14, v15

			if p9 and list then
				v14 = list[p9]
				v15 = not v14 or v14.universeId ~= data2.universeId
			else
				v15 = true
			end

			if v15 then
				local v17 = {
					errorType = v6.PlayIntent,
					clickedUniverseId = data2.universeId,
					universeId = 0,
					gameSetTypeId = 0,
					gameSetTargetId = 0,
					sortIndex = 0,
					sortEntryIndex = 0
				}
				local v18 = if v14 then v14.universeId else nil
				v17.universeId = v18
				v17.gameSetTypeId = v11
				v17.gameSetTargetId = gameSetTargetId
				v17.sortIndex = p3
				v17.sortEntryIndex = p9 or nil
				reportGameAttributionError(p8, v17)
			end
		end

		local v14 = calculateRowPositionFields(p9, p5, p6)

		local v15 = analyticsData
		local analyticsData2 = data2.analyticsData
		local joined

		if v15 or analyticsData2 then
			joined = Cryo.Dictionary.join(v15 or v5, analyticsData2 or v5)

			if not next(joined) then
				joined = nil
			end
		end

		local v18 = {
			placeId = data2.placeIdOverride or data2.placeId,
			rootPlaceId = tonumber(data2.placeId),
			universeId = data2.universeId,
			sortIndex = tostring(p3),
			sortEntryIndex = 0,
			referralSource = 0,
			gameSetTypeId = 0,
			gameSetTargetId = 0,
			appliedFilters = 0,
			topicDataPosition = 0,
			nativeAdData = 0,
			pageName = 0,
			positionInRow = 0,
			rowNumber = 0,
			feedRowNumber = 0,
			loadSource = 0,
			launchData = 0,
			sortSubId = 0,
			tileType = 0,
			analyticsData = 0,
			actionType = 0
		}
		local v19 = if p9 then tostring(p9) else nil
		v18.sortEntryIndex = v19
		v18.referralSource = referralSource
		v18.gameSetTypeId = v11
		v18.gameSetTargetId = gameSetTargetId
		v18.appliedFilters = appliedFilters
		v18.topicDataPosition = data2.topicContentsIndex or p9
		v18.nativeAdData = data2.adId
		v18.pageName = pageName
		v18.positionInRow = v14.positionInRow
		v18.rowNumber = v14.rowInSort
		v18.feedRowNumber = v14.rowOnPage
		v18.loadSource = v12
		v18.launchData = data2.launchDataOverride
		v18.sortSubId = sortSubId
		v18.tileType = data2.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile
		v18.analyticsData = joined

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v18.actionType = actionType
		gamePlayIntent(v9, p8, v18)
	end

	return React.useCallback(function(p7, p8)
		if fFlagLuaAppGameDetailsAttributionFix then
			local v14, v15

			if p7 and list then
				v14 = list[p7]
				v15 = not v14 or v14.universeId ~= p8
			else
				v15 = true
			end

			if v15 then
				local v18 = {
					errorType = v6.GameDetail,
					clickedUniverseId = p8,
					universeId = 0,
					gameSetTypeId = 0,
					gameSetTargetId = 0,
					sortIndex = 0,
					sortEntryIndex = 0
				}

				local v19 = if v14 then v14.universeId else nil
				v18.universeId = v19
				v18.gameSetTypeId = v11
				v18.gameSetTargetId = gameSetTargetId
				v18.sortIndex = p3
				v18.sortEntryIndex = p7 or nil
				reportGameAttributionError(pageName, v18)
			end
		end

		if p7 ~= nil and list ~= nil then
			local item = list[p7]

			if not item then
				mutedError("reportGameDetailOpened requires a valid entry")
			end

			local v14 = calculateRowPositionFields(p7, p5, p6)

			local v15 = analyticsData
			local analyticsData2 = item.analyticsData
			local joined

			if v15 or analyticsData2 then
				joined = Cryo.Dictionary.join(v15 or v5, analyticsData2 or v5)

				if not next(joined) then
					joined = nil
				end
			end

			v8.reportOpenGameDetailWithId(
				item.placeIdOverride or item.placeId,
				v11,
				gameSetTargetId,
				p3,
				p7,
				#list,
				item.isSponsored,
				item.adId,
				item.universeId,
				pageName,
				p8,
				appliedFilters,
				item.topicContentsIndex or p7,
				nil,
				v14.positionInRow,
				v14.rowInSort,
				v14.rowOnPage,
				nil,
				v12,
				item.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
				sortSubId,
				joined
			)
		end
	end, {
		v8,
		p3,
		pageName,
		v11,
		gameSetTargetId,
		list,
		p5,
		p6,
		v12,
		sortSubId,
		analyticsData
	}), React.useCallback(fn, {
		p3,
		v9,
		v11,
		gameSetTargetId,
		if fFlagLuaAppLogGameAttributionError then list else nil,
		pageName,
		p5,
		p6,
		v12,
		sortSubId,
		analyticsData
	}), React.useCallback(function()
		v8.reportSeeAllWithId(v11, gameSetTargetId, p3)
	end, { v8, v11, gameSetTargetId, p3 }), (React.useCallback(function(p7, scrollDuration, startPos)
		if p4 and p4.current ~= nil then
			local scrollingDirection = p4.current.ScrollingDirection
			local v16 = 0

			if scrollingDirection == Enum.ScrollingDirection.X then
				v16 = p4.current.AbsoluteSize.X
			elseif scrollingDirection == Enum.ScrollingDirection.Y then
				v16 = p4.current.AbsoluteSize.Y
			else
				mutedError(`Direction {scrollingDirection.Name} is an unsupported option for feedScroll event`)
			end

			local screenSize = v7:getState().ScreenSize
			local v17 = {
				distance = p7,
				screenSizeX = screenSize.X,
				screenSizeY = screenSize.Y,
				scrollAreaSize = v16,
				scrollDepth = 0,
				startDepth = 0,
				startPos = 0,
				scrollDuration = 0,
				sortPos = 0,
				gameSetTypeId = 0,
				gameSetTargetId = 0
			}

			local v18 = if v16 > 0 then p7 / v16 else nil
			v17.scrollDepth = v18
			local v19 = if v16 > 0 then startPos / v16 else nil
			v17.startDepth = v19
			v17.startPos = startPos
			v17.scrollDuration = scrollDuration
			v17.sortPos = p3
			v17.gameSetTypeId = v11
			v17.gameSetTargetId = gameSetTargetId

			feedScroll(v9, pageName, scrollingDirection, v17)
		end
	end, { v9, p3, pageName, p4, v11, gameSetTargetId, v7 }))
end

return useGameSortAnalytics
