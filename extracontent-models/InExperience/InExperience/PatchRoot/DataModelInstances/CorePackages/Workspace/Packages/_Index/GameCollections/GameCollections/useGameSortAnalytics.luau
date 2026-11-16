local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags2.AppEventIngestService
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local DiscoveryAnalytics2 = require(parent.DiscoveryAnalytics)
local reportGameAttributionError = DiscoveryAnalytics2.Events.reportGameAttributionError
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local DiscoveryAvailability = require(parent.DiscoveryAvailability)
local GameSortLoadSource = DiscoveryAvailability.GameSortLoadSource
local ScrollTelemetry = require(parent.ScrollTelemetry)
local feedScroll = ScrollTelemetry.feedScroll
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLogGameAttributionError = SharedFlags.FFlagLuaAppLogGameAttributionError
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppGameDetailsAttributionFix = SharedFlags2.FFlagLuaAppGameDetailsAttributionFix
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags3.FFlagLuaAppDemoModePlayButtonTelemetry

local v = {}

local function mergeAnalyticsData(analyticsData, analyticsData2) -- 2 equivalent calls inferred from this helper
	if not (analyticsData or analyticsData2) then
		return nil
	end

	local joined = Cryo.Dictionary.join(analyticsData or v, analyticsData2 or v)
	return if next(joined) then joined else nil
end

local v2 = FFlagLuaAppLogGameAttributionError and {
	GameDetail = "GameDetail",
	PlayIntent = "PlayIntent"
} or nil

local function getGameSetTypeId(data, flag: boolean, flag2: boolean?) -- 1 equivalent call inferred from this helper
	if data == nil then
		return nil
	end

	return if flag or flag2 then data.topicId else data.gameSetTypeId
end

local function getGameSetTargetId(data, flag: boolean) -- 1 equivalent call inferred from this helper
	if flag or data == nil then
		return nil
	end

	return data.gameSetTargetId
end

local function getAppliedFilters(data, flag: boolean) -- 1 equivalent call inferred from this helper
	return if not (flag or not data) then data.appliedFilters else nil
end

local function useGameSortAnalytics(data, flag: boolean, p: number, pageName: string, p2, list, p3: number, p4: number?)
	local v3 = useStore()
	local v4 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v5 = useRoactService(AppEventIngestService)

	local gameSetTypeId = getGameSetTypeId(data, flag, pageName == AppPage.SearchPage) -- inferred equivalent call
	local gameSetTargetId = getGameSetTargetId(data, flag) -- inferred equivalent call
	local appliedFilters = getAppliedFilters(data, flag) -- inferred equivalent call
	local loadSource

	if pageName == AppPage.Home and data and data.topicId then
		loadSource = GameSortLoadSource.getSortLoadSource(data.topicId)
	else
		loadSource = nil
	end

	local sortSubId

	if data then
		sortSubId = data.sortSubId
	else
		sortSubId = nil
	end

	local analyticsData

	if data then
		analyticsData = data.analyticsData
	else
		analyticsData = nil
	end

	local v6 = React.useCallback(function(p5: number?, clickedUniverseId: string?)
		if FFlagLuaAppGameDetailsAttributionFix then
			local v6, v7

			if p5 and list then
				v6 = list[p5]
				v7 = not v6 or v6.universeId ~= clickedUniverseId
			else
				v7 = true
			end

			if v7 then
				local v8 = {
					errorType = v2.GameDetail,
					clickedUniverseId = clickedUniverseId,
					universeId = 0,
					gameSetTypeId = 0,
					gameSetTargetId = 0,
					sortIndex = 0,
					sortEntryIndex = 0
				}
				local universeId

				if v6 then
					universeId = v6.universeId
				end

				v8.universeId = universeId
				v8.gameSetTypeId = gameSetTypeId
				v8.gameSetTargetId = gameSetTargetId
				v8.sortIndex = p
				v8.sortEntryIndex = p5 or nil
				reportGameAttributionError(pageName, v8)
			end
		end

		if p5 ~= nil and list ~= nil then
			local item = list[p5]

			if not item then
				mutedError("reportGameDetailOpened requires a valid entry")
			end

			local v6 = calculateRowPositionFields(p5, p3, p4)

			local joined = mergeAnalyticsData(analyticsData, item.analyticsData) -- inferred equivalent call

			v4.reportOpenGameDetailWithId(
				item.placeIdOverride or item.placeId,
				gameSetTypeId,
				gameSetTargetId,
				p,
				p5,
				#list,
				item.isSponsored,
				item.adId,
				item.universeId,
				pageName,
				clickedUniverseId,
				appliedFilters,
				item.topicContentsIndex or p5,
				nil,
				v6.positionInRow,
				v6.rowInSort,
				v6.rowOnPage,
				nil,
				loadSource,
				item.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
				sortSubId,
				joined
			)
		end
	end, {
		v4,
		p,
		pageName,
		gameSetTypeId,
		gameSetTargetId,
		list,
		p3,
		p4,
		loadSource,
		sortSubId,
		analyticsData
	})

	local useCallback = React.useCallback
	local function fn(data2, referralSource: string?, _: string?, p5: string, p6: number?, actionType: string?)
		if FFlagLuaAppLogGameAttributionError then
			local v7, v8

			if p6 and list then
				v7 = list[p6]
				v8 = not v7 or v7.universeId ~= data2.universeId
			else
				v8 = true
			end

			if v8 then
				local v9 = {
					errorType = v2.PlayIntent,
					clickedUniverseId = data2.universeId,
					universeId = 0,
					gameSetTypeId = 0,
					gameSetTargetId = 0,
					sortIndex = 0,
					sortEntryIndex = 0
				}
				local universeId

				if v7 then
					universeId = v7.universeId
				end

				v9.universeId = universeId
				v9.gameSetTypeId = gameSetTypeId
				v9.gameSetTargetId = gameSetTargetId
				v9.sortIndex = p
				v9.sortEntryIndex = p6 or nil
				reportGameAttributionError(p5, v9)
			end
		end

		local v7 = calculateRowPositionFields(p6, p3, p4)

		local analyticsData2 = mergeAnalyticsData(analyticsData, data2.analyticsData) -- inferred equivalent call

		local v8 = {
			placeId = data2.placeIdOverride or data2.placeId,
			rootPlaceId = tonumber(data2.placeId),
			universeId = data2.universeId,
			sortIndex = tostring(p),
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
		local sortEntryIndex

		if p6 then
			sortEntryIndex = tostring(p6)
		end

		v8.sortEntryIndex = sortEntryIndex
		v8.referralSource = referralSource
		v8.gameSetTypeId = gameSetTypeId
		v8.gameSetTargetId = gameSetTargetId
		v8.appliedFilters = appliedFilters
		v8.topicDataPosition = data2.topicContentsIndex or p6
		v8.nativeAdData = data2.adId
		v8.pageName = pageName
		v8.positionInRow = v7.positionInRow
		v8.rowNumber = v7.rowInSort
		v8.feedRowNumber = v7.rowOnPage
		v8.loadSource = loadSource
		v8.launchData = data2.launchDataOverride
		v8.sortSubId = sortSubId
		v8.tileType = data2.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile
		v8.analyticsData = analyticsData2

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v8.actionType = actionType
		gamePlayIntent(v5, p5, v8)
	end

	local v7

	if FFlagLuaAppLogGameAttributionError then
		v7 = list
	end

	return v6, useCallback(fn, {
		p,
		v5,
		gameSetTypeId,
		gameSetTargetId,
		v7,
		pageName,
		p3,
		p4,
		loadSource,
		sortSubId,
		analyticsData
	}), React.useCallback(function()
		v4.reportSeeAllWithId(gameSetTypeId, gameSetTargetId, p)
	end, { v4, gameSetTypeId, gameSetTargetId, p }), (React.useCallback(
		function(distance: number, scrollDuration: number, startPos: number)
			if p2 and p2.current ~= nil then
				local scrollingDirection = p2.current.ScrollingDirection
				local scrollAreaSize = 0

				if scrollingDirection == Enum.ScrollingDirection.X then
					scrollAreaSize = p2.current.AbsoluteSize.X
				elseif scrollingDirection == Enum.ScrollingDirection.Y then
					scrollAreaSize = p2.current.AbsoluteSize.Y
				else
					mutedError(`Direction {scrollingDirection.Name} is an unsupported option for feedScroll event`)
				end

				local screenSize = v3:getState().ScreenSize
				local v8 = {
					distance = distance,
					screenSizeX = screenSize.X,
					screenSizeY = screenSize.Y,
					scrollAreaSize = scrollAreaSize,
					scrollDepth = 0,
					startDepth = 0,
					startPos = 0,
					scrollDuration = 0,
					sortPos = 0,
					gameSetTypeId = 0,
					gameSetTargetId = 0
				}
				local scrollDepth

				if scrollAreaSize > 0 then
					scrollDepth = distance / scrollAreaSize
				end

				v8.scrollDepth = scrollDepth
				local startDepth

				if scrollAreaSize > 0 then
					startDepth = startPos / scrollAreaSize
				end

				v8.startDepth = startDepth
				v8.startPos = startPos
				v8.scrollDuration = scrollDuration
				v8.sortPos = p
				v8.gameSetTypeId = gameSetTypeId
				v8.gameSetTargetId = gameSetTargetId

				feedScroll(v5, pageName, scrollingDirection, v8)
			end
		end,
		{ v5, p, pageName, p2, gameSetTypeId, gameSetTargetId, v3 }
	))
end

return useGameSortAnalytics
