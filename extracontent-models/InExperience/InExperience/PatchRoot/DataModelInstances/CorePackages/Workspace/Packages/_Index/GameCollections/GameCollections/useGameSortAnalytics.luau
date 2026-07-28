local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppPage = require(Parent.RobloxAppEnums).AppPage
local RoactAnalyticsCommonGameEvents = require(Parent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local gamePlayIntent = require(Parent.DiscoveryAnalytics).Events.gamePlayIntent
local reportGameAttributionError = require(Parent.DiscoveryAnalytics).Events.reportGameAttributionError
local mutedError = require(Parent.Loggers).mutedError
local useStore = require(Parent.RoactUtils).Hooks.RoactRodux.useStore
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local GameSortLoadSource = require(Parent.DiscoveryAvailability).GameSortLoadSource
local feedScroll = require(Parent.ScrollTelemetry).feedScroll
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local Cryo = require(Parent.Cryo)
local FFlagLuaAppLogGameAttributionError = require(Parent.SharedFlags).FFlagLuaAppLogGameAttributionError
local FFlagLuaAppGameDetailsAttributionFix = require(Parent.SharedFlags).FFlagLuaAppGameDetailsAttributionFix
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppDemoModePlayButtonTelemetry = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry
local t1 = {}

local function mergeAnalyticsData(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 30
	-- upvalues: Cryo (copy), t1 (copy)
	if not t2 and not t3 then
		return nil
	end

	local v29 = Cryo.Dictionary.join(t2 or t1, t3 or t1)

	if next(v29) then
		return v29
	end

	return nil
end

local v22 = if not FFlagLuaAppLogGameAttributionError then nil else {
	GameDetail = "GameDetail",
	PlayIntent = "PlayIntent"
}

local function getGameSetTypeId(p1, b1: boolean, b2: boolean?) -- line: 51
	if p1 ~= nil then
		if b1 or b2 then
			return p1.topicId
		end

		return p1.gameSetTypeId
	end

	return nil
end
local function getGameSetTargetId(p2, b3: boolean) -- line: 63
	if not b3 and p2 ~= nil then
		return p2.gameSetTargetId
	end

	return nil
end
local function getAppliedFilters(p3, b4: boolean) -- line: 73
	if not b4 and p3 then
		return p3.appliedFilters
	end

	return nil
end
local function useGameSortAnalytics(p4, b5: boolean, n1: number, s1: string, t4: {[any]: any}?, t5: {[any]: any}?, n2: number, n3: number?) -- line: 86
	-- upvalues: useStore (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), AppEventIngestService (copy), AppPage (copy), GameSortLoadSource (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), React (copy), FFlagLuaAppGameDetailsAttributionFix (copy), reportGameAttributionError (copy), v22 (copy), mutedError (copy), calculateRowPositionFields (copy), Cryo (copy), t1 (copy), GameCollectionItemTypes (copy), FFlagLuaAppLogGameAttributionError (copy), gamePlayIntent (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), feedScroll (copy)
	local v45 = useStore()
	local v46 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v47 = useRoactService(AppEventIngestService)
	local v48 = s1 == AppPage.SearchPage
	local v49 = if p4 == nil then nil else if not b5 and not v48 then p4.gameSetTypeId else p4.topicId
	local v50 = if b5 or p4 == nil then nil else p4.gameSetTargetId
	local v51 = if b5 or not p4 then nil else p4.appliedFilters
	local v52 = if s1 ~= AppPage.Home or (not p4 or not p4.topicId) then nil else GameSortLoadSource.getSortLoadSource(p4.topicId)
	local v53 = if not FFlagLuaAppAddSubIdToHomeEvents or not p4 then nil else p4.sortSubId
	local v54 = if not p4 then nil else p4.analyticsData

	return React.useCallback(function(n4: number?, s2: string?) -- line: 116
		-- upvalues: FFlagLuaAppGameDetailsAttributionFix (copy), t5 (copy), reportGameAttributionError (copy), s1 (copy), v22 (copy), v49 (copy), v50 (copy), n1 (copy), mutedError (copy), calculateRowPositionFields (copy), n2 (copy), n3 (copy), v54 (copy), Cryo (copy), t1 (copy), v46 (copy), v51 (copy), v52 (copy), GameCollectionItemTypes (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v53 (copy)
		if FFlagLuaAppGameDetailsAttributionFix then
			local v57 = nil
			local v58

			if n4 and t5 then
				v57 = t5[n4]
				v58 = not v57 or s2 ~= v57.universeId
			else
				v58 = true
			end

			if v58 then
				reportGameAttributionError(s1, {
					errorType = v22.GameDetail,
					clickedUniverseId = s2,
					universeId = if not v57 then nil else v57.universeId,
					gameSetTypeId = v49,
					gameSetTargetId = v50,
					sortIndex = n1,
					sortEntryIndex = n4 or nil
				})
			end
		end

		if n4 ~= nil and t5 ~= nil then
			local v59 = t5[n4]

			if not v59 then
				mutedError("reportGameDetailOpened requires a valid entry")
			end

			local v60 = calculateRowPositionFields(n4, n2, n3)
			local v61 = v54
			local analyticsData = v59.analyticsData
			local v63

			if not v61 and not analyticsData then
				v63 = nil
			else
				local v64 = Cryo.Dictionary.join(v61 or t1, analyticsData or t1)

				v63 = if not next(v64) then nil else v64
			end

			v46.reportOpenGameDetailWithId(v59.placeIdOverride or v59.placeId, v49, v50, n1, n4, #t5, v59.isSponsored, v59.adId, v59.universeId, s1, s2, v51, v59.topicContentsIndex or n4, nil, v60.positionInRow, v60.rowInSort, v60.rowOnPage, nil, v52, v59.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile, if not FFlagLuaAppAddSubIdToHomeEvents then nil else v53, v63)
		end
	end, {
		v46,
		n1,
		s1,
		v49,
		v50,
		t5,
		n2,
		n3,
		v52,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v53,
		v54
	}), React.useCallback(function(p5, s3: string?, _: string?, s5: string, n5: number?, s6: string?) -- line: 194
		-- upvalues: FFlagLuaAppLogGameAttributionError (copy), t5 (copy), reportGameAttributionError (copy), v22 (copy), v49 (copy), v50 (copy), n1 (copy), calculateRowPositionFields (copy), n2 (copy), n3 (copy), v54 (copy), Cryo (copy), t1 (copy), gamePlayIntent (copy), v47 (copy), v51 (copy), s1 (copy), v52 (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v53 (copy), GameCollectionItemTypes (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		if FFlagLuaAppLogGameAttributionError then
			local v71 = nil
			local v72

			if n5 and t5 then
				v71 = t5[n5]
				v72 = not v71 or v71.universeId ~= p5.universeId
			else
				v72 = true
			end

			if v72 then
				reportGameAttributionError(s5, {
					errorType = v22.PlayIntent,
					clickedUniverseId = p5.universeId,
					universeId = if not v71 then nil else v71.universeId,
					gameSetTypeId = v49,
					gameSetTargetId = v50,
					sortIndex = n1,
					sortEntryIndex = n5 or nil
				})
			end
		end

		local v73 = calculateRowPositionFields(n5, n2, n3)
		local v74 = v54
		local analyticsData = p5.analyticsData
		local v76

		if not v74 and not analyticsData then
			v76 = nil
		else
			local v77 = Cryo.Dictionary.join(v74 or t1, analyticsData or t1)

			v76 = if not next(v77) then nil else v77
		end

		gamePlayIntent(v47, s5, {
			placeId = p5.placeIdOverride or p5.placeId,
			rootPlaceId = tonumber(p5.placeId),
			universeId = p5.universeId,
			sortIndex = tostring(n1),
			sortEntryIndex = if not n5 then nil else tostring(n5),
			referralSource = s3,
			gameSetTypeId = v49,
			gameSetTargetId = v50,
			appliedFilters = v51,
			topicDataPosition = p5.topicContentsIndex or n5,
			nativeAdData = p5.adId,
			pageName = s1,
			positionInRow = v73.positionInRow,
			rowNumber = v73.rowInSort,
			feedRowNumber = v73.rowOnPage,
			loadSource = v52,
			launchData = p5.launchDataOverride,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else v53,
			tileType = p5.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
			analyticsData = v76,
			actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s6
		})
	end, {
		n1,
		v47,
		v49,
		v50,
		if not FFlagLuaAppLogGameAttributionError then nil else t5,
		s1,
		n2,
		n3,
		v52,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v53,
		v54
	}), React.useCallback(function() -- line: 275
		-- upvalues: v46 (copy), v49 (copy), v50 (copy), n1 (copy)
		v46.reportSeeAllWithId(v49, v50, n1)
	end, {
		v46,
		v49,
		v50,
		n1
	}), (React.useCallback(function(n6: number, n7: number, n8: number) -- line: 288
		-- upvalues: t4 (copy), mutedError (copy), v45 (copy), n1 (copy), v49 (copy), v50 (copy), feedScroll (copy), v47 (copy), s1 (copy)
		if t4 and t4.current ~= nil then
			local ScrollingDirection = t4.current.ScrollingDirection
			local n9 = 0

			if ScrollingDirection == Enum.ScrollingDirection.X then
				n9 = t4.current.AbsoluteSize.X
			elseif ScrollingDirection == Enum.ScrollingDirection.Y then
				n9 = t4.current.AbsoluteSize.Y
			else
				mutedError(`Direction { ScrollingDirection.Name } is an unsupported option for feedScroll event`)
			end

			local ScreenSize = v45:getState().ScreenSize
			local t6 = {
				distance = n6,
				screenSizeX = ScreenSize.X,
				screenSizeY = ScreenSize.Y,
				scrollAreaSize = n9,
				scrollDepth = if not (n9 > 0) then nil else n6 / n9,
				startDepth = if not (n9 > 0) then nil else n8 / n9,
				startPos = n8,
				scrollDuration = n7,
				sortPos = n1,
				gameSetTypeId = v49,
				gameSetTargetId = v50
			}

			feedScroll(v47, s1, ScrollingDirection, t6)
		end
	end, {
		v47,
		n1,
		s1,
		t4,
		v49,
		v50,
		v45
	}))
end

return useGameSortAnalytics
