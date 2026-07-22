local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local SetGamePlaySession = require(Parent.RobloxAppSessionization).SetGamePlaySession
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local findAnalyticsFieldInAncestors = require(Parent.SduiCoreSystem).findAnalyticsFieldInAncestors
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry

local function sduiReportGamePlayIntent(t1: {[any]: any}) -- line: 33
	-- upvalues: FFlagSduiExperienceDetailsSupport (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
	local sduiContext = t1.sduiContext
	local analyticsContext = t1.analyticsContext
	local universeId = t1.universeId
	local placeId = t1.placeId
	local v17 = t1.rootPlaceId or placeId
	local appliedFilters = t1.appliedFilters
	local v19 = if not FFlagSduiExperienceDetailsSupport then nil else t1.launchData
	local eventIngest = sduiContext.dependencies.eventIngest
	local sessionService = sduiContext.dependencies.sessionService
	local collectionPosition = nil
	local collectionId = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v26 = analyticsContext.getCollectionData and analyticsContext.getCollectionData() or nil

	if v26 then
		collectionPosition = v26.collectionPosition
		collectionId = v26.collectionId
		itemsPerRow = v26.itemsPerRow
		startRowNumber = v26.startRowNumber
	end

	local v27 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", analyticsContext)
	local v28 = collectionId or findAnalyticsFieldInAncestors("collectionId", analyticsContext)
	local v29 = findAnalyticsFieldInAncestors("gameSetTargetId", analyticsContext)
	local v30 = findAnalyticsFieldInAncestors("itemPosition", analyticsContext, -1)
	local v31 = findAnalyticsFieldInAncestors("topicDataPosition", analyticsContext, v30)
	local v32 = findAnalyticsFieldInAncestors("heroUnitId", analyticsContext)
	local v33 = findAnalyticsFieldInAncestors("eventContext", analyticsContext, "ExperienceTile")
	local v34 = findAnalyticsFieldInAncestors("referralSource", analyticsContext)
	local v35 = findAnalyticsFieldInAncestors("gamePlaySessionType", analyticsContext)

	if v35 then
		SetGamePlaySession(sessionService, v35, true)
	end

	local v36 = findAnalyticsFieldInAncestors("nativeAdData", analyticsContext)

	if v36 == nil then
		v36 = findAnalyticsFieldInAncestors("adId", analyticsContext)
	end

	if v36 then
		sponsoredGamesRecordClick(sduiContext.dependencies.networking, (tostring(v36)))
	end

	local v37 = if not FFlagSduiExperienceDetailsSupport then calculateRowPositionFields(v30, itemsPerRow, startRowNumber) else if typeof(v30) ~= "number" or (typeof(itemsPerRow) ~= "number" or (typeof(startRowNumber) ~= "number" or (v30 == -1 or (itemsPerRow == -1 or startRowNumber == -1)))) then {} else calculateRowPositionFields(v30, itemsPerRow, startRowNumber)
	local v38 = findAnalyticsFieldInAncestors("tileType", analyticsContext, "GameTile")

	if FFlagSduiExperienceDetailsSupport then
		gamePlayIntent(eventIngest, tostring(v33), {
			placeId = tostring(placeId or v17),
			rootPlaceId = tonumber(v17),
			universeId = tostring(universeId),
			sortIndex = if not v27 then nil else tostring(v27),
			sortEntryIndex = if typeof(v30) ~= "number" or v30 == -1 then nil else tostring(v30),
			referralSource = v34,
			gameSetTypeId = if not v28 then nil else tostring(v28),
			gameSetTargetId = v29,
			appliedFilters = appliedFilters,
			topicDataPosition = typeof(v31) == "number" and (v31 ~= -1 and v31) or nil,
			nativeAdData = v36,
			pageName = sduiContext.appPage,
			positionInRow = v37.positionInRow,
			rowNumber = v37.rowInSort,
			feedRowNumber = v37.rowOnPage,
			heroUnitId = v32,
			tileType = v38,
			launchData = v19,
			actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else t1.actionType
		})

		return
	end

	gamePlayIntent(eventIngest, tostring(v33), {
		placeId = tostring(placeId),
		rootPlaceId = tonumber(v17),
		universeId = tostring(universeId),
		sortIndex = tostring(v27),
		sortEntryIndex = if not v30 then nil else tostring(v30),
		referralSource = v34,
		gameSetTypeId = tostring(v28),
		gameSetTargetId = v29,
		appliedFilters = appliedFilters,
		topicDataPosition = v31,
		nativeAdData = v36,
		pageName = sduiContext.appPage,
		positionInRow = v37.positionInRow,
		rowNumber = v37.rowInSort,
		feedRowNumber = v37.rowOnPage,
		heroUnitId = v32,
		tileType = v38,
		actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else t1.actionType
	})
end

return sduiReportGamePlayIntent
