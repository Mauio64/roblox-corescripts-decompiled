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
local t1 = {}

local function mergeAnalyticsData(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 29
	-- upvalues: Cryo (copy), t1 (copy)
	if not t2 and not t3 then
		return nil
	end

	local v28 = Cryo.Dictionary.join(t2 or t1, t3 or t1)

	if next(v28) then
		return v28
	end

	return nil
end

local v21 = if not FFlagLuaAppLogGameAttributionError then nil else {
	GameDetail = "GameDetail",
	PlayIntent = "PlayIntent"
}

local function getGameSetTypeId(p1, b1: boolean, b2: boolean?) -- line: 50
	if p1 ~= nil then
		if b1 or b2 then
			return p1.topicId
		end

		return p1.gameSetTypeId
	end

	return nil
end
local function getGameSetTargetId(p2, b3: boolean) -- line: 62
	if not b3 and p2 ~= nil then
		return p2.gameSetTargetId
	end

	return nil
end
local function getAppliedFilters(p3, b4: boolean) -- line: 72
	if not b4 and p3 then
		return p3.appliedFilters
	end

	return nil
end
local function useGameSortAnalytics(p4, b5: boolean, n1: number, s1: string, t4: {[any]: any}?, t5: {[any]: any}?, n2: number, n3: number?) -- line: 85
	-- upvalues: useStore (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), AppEventIngestService (copy), AppPage (copy), GameSortLoadSource (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), React (copy), FFlagLuaAppGameDetailsAttributionFix (copy), reportGameAttributionError (copy), v21 (copy), mutedError (copy), calculateRowPositionFields (copy), Cryo (copy), t1 (copy), GameCollectionItemTypes (copy), FFlagLuaAppLogGameAttributionError (copy), gamePlayIntent (copy), feedScroll (copy)
	local v44 = useStore()
	local v45 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v46 = useRoactService(AppEventIngestService)
	local v47 = s1 == AppPage.SearchPage
	local v48 = if p4 == nil then nil else if not b5 and not v47 then p4.gameSetTypeId else p4.topicId
	local v49 = if b5 or p4 == nil then nil else p4.gameSetTargetId
	local v50 = if b5 or not p4 then nil else p4.appliedFilters
	local v51 = if s1 ~= AppPage.Home or (not p4 or not p4.topicId) then nil else GameSortLoadSource.getSortLoadSource(p4.topicId)
	local v52 = if not FFlagLuaAppAddSubIdToHomeEvents or not p4 then nil else p4.sortSubId
	local v53 = if not p4 then nil else p4.analyticsData

	return React.useCallback(function(n4: number?, s2: string?) -- line: 115
		-- upvalues: FFlagLuaAppGameDetailsAttributionFix (copy), t5 (copy), reportGameAttributionError (copy), s1 (copy), v21 (copy), v48 (copy), v49 (copy), n1 (copy), mutedError (copy), calculateRowPositionFields (copy), n2 (copy), n3 (copy), v53 (copy), Cryo (copy), t1 (copy), v45 (copy), v50 (copy), v51 (copy), GameCollectionItemTypes (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v52 (copy)
		if FFlagLuaAppGameDetailsAttributionFix then
			local v56 = nil
			local v57

			if n4 and t5 then
				v56 = t5[n4]
				v57 = not v56 or s2 ~= v56.universeId
			else
				v57 = true
			end

			if v57 then
				reportGameAttributionError(s1, {
					errorType = v21.GameDetail,
					clickedUniverseId = s2,
					universeId = if not v56 then nil else v56.universeId,
					gameSetTypeId = v48,
					gameSetTargetId = v49,
					sortIndex = n1,
					sortEntryIndex = n4 or nil
				})
			end
		end

		if n4 ~= nil and t5 ~= nil then
			local v58 = t5[n4]

			if not v58 then
				mutedError("reportGameDetailOpened requires a valid entry")
			end

			local v59 = calculateRowPositionFields(n4, n2, n3)
			local v60 = v53
			local analyticsData = v58.analyticsData
			local v62

			if not v60 and not analyticsData then
				v62 = nil
			else
				local v63 = Cryo.Dictionary.join(v60 or t1, analyticsData or t1)

				v62 = if not next(v63) then nil else v63
			end

			v45.reportOpenGameDetailWithId(v58.placeIdOverride or v58.placeId, v48, v49, n1, n4, #t5, v58.isSponsored, v58.adId, v58.universeId, s1, s2, v50, v58.topicContentsIndex or n4, nil, v59.positionInRow, v59.rowInSort, v59.rowOnPage, nil, v51, v58.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile, if not FFlagLuaAppAddSubIdToHomeEvents then nil else v52, v62)
		end
	end, {
		v45,
		n1,
		s1,
		v48,
		v49,
		t5,
		n2,
		n3,
		v51,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v52,
		v53
	}), React.useCallback(function(p5, s3: string?, _: string?, s5: string, n5: number?) -- line: 193
		-- upvalues: FFlagLuaAppLogGameAttributionError (copy), t5 (copy), reportGameAttributionError (copy), v21 (copy), v48 (copy), v49 (copy), n1 (copy), calculateRowPositionFields (copy), n2 (copy), n3 (copy), v53 (copy), Cryo (copy), t1 (copy), gamePlayIntent (copy), v46 (copy), v50 (copy), s1 (copy), v51 (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v52 (copy), GameCollectionItemTypes (copy)
		if FFlagLuaAppLogGameAttributionError then
			local v69 = nil
			local v70

			if n5 and t5 then
				v69 = t5[n5]
				v70 = not v69 or v69.universeId ~= p5.universeId
			else
				v70 = true
			end

			if v70 then
				reportGameAttributionError(s5, {
					errorType = v21.PlayIntent,
					clickedUniverseId = p5.universeId,
					universeId = if not v69 then nil else v69.universeId,
					gameSetTypeId = v48,
					gameSetTargetId = v49,
					sortIndex = n1,
					sortEntryIndex = n5 or nil
				})
			end
		end

		local v71 = calculateRowPositionFields(n5, n2, n3)
		local v72 = v53
		local analyticsData = p5.analyticsData
		local v74

		if not v72 and not analyticsData then
			v74 = nil
		else
			local v75 = Cryo.Dictionary.join(v72 or t1, analyticsData or t1)

			v74 = if not next(v75) then nil else v75
		end

		gamePlayIntent(v46, s5, {
			placeId = p5.placeIdOverride or p5.placeId,
			rootPlaceId = tonumber(p5.placeId),
			universeId = p5.universeId,
			sortIndex = tostring(n1),
			sortEntryIndex = if not n5 then nil else tostring(n5),
			referralSource = s3,
			gameSetTypeId = v48,
			gameSetTargetId = v49,
			appliedFilters = v50,
			topicDataPosition = p5.topicContentsIndex or n5,
			nativeAdData = p5.adId,
			pageName = s1,
			positionInRow = v71.positionInRow,
			rowNumber = v71.rowInSort,
			feedRowNumber = v71.rowOnPage,
			loadSource = v51,
			launchData = p5.launchDataOverride,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else v52,
			tileType = p5.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
			analyticsData = v74
		})
	end, {
		n1,
		v46,
		v48,
		v49,
		if not FFlagLuaAppLogGameAttributionError then nil else t5,
		s1,
		n2,
		n3,
		v51,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v52,
		v53
	}), React.useCallback(function() -- line: 266
		-- upvalues: v45 (copy), v48 (copy), v49 (copy), n1 (copy)
		v45.reportSeeAllWithId(v48, v49, n1)
	end, {
		v45,
		v48,
		v49,
		n1
	}), (React.useCallback(function(n6: number, n7: number, n8: number) -- line: 279
		-- upvalues: t4 (copy), mutedError (copy), v44 (copy), n1 (copy), v48 (copy), v49 (copy), feedScroll (copy), v46 (copy), s1 (copy)
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

			local ScreenSize = v44:getState().ScreenSize
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
				gameSetTypeId = v48,
				gameSetTargetId = v49
			}

			feedScroll(v46, s1, ScrollingDirection, t6)
		end
	end, {
		v46,
		n1,
		s1,
		t4,
		v48,
		v49,
		v44
	}))
end

return useGameSortAnalytics
