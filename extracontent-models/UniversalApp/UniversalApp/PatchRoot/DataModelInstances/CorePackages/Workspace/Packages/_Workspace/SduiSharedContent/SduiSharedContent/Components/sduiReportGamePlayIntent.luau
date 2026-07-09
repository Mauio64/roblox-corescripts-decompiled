local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local SetGamePlaySession = require(Parent.RobloxAppSessionization).SetGamePlaySession
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local findAnalyticsFieldInAncestors = require(Parent.SduiCoreSystem).findAnalyticsFieldInAncestors
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function sduiReportGamePlayIntent(t1: {[any]: any}) -- line: 31
	-- upvalues: FFlagSduiExperienceDetailsSupport (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy)
	local sduiContext = t1.sduiContext
	local analyticsContext = t1.analyticsContext
	local universeId = t1.universeId
	local placeId = t1.placeId
	local v15 = t1.rootPlaceId or placeId
	local appliedFilters = t1.appliedFilters
	local v17 = if not FFlagSduiExperienceDetailsSupport then nil else t1.launchData
	local eventIngest = sduiContext.dependencies.eventIngest
	local sessionService = sduiContext.dependencies.sessionService
	local collectionPosition = nil
	local collectionId = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v24 = analyticsContext.getCollectionData and analyticsContext.getCollectionData() or nil

	if v24 then
		collectionPosition = v24.collectionPosition
		collectionId = v24.collectionId
		itemsPerRow = v24.itemsPerRow
		startRowNumber = v24.startRowNumber
	end

	local v25 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", analyticsContext)
	local v26 = collectionId or findAnalyticsFieldInAncestors("collectionId", analyticsContext)
	local v27 = findAnalyticsFieldInAncestors("gameSetTargetId", analyticsContext)
	local v28 = findAnalyticsFieldInAncestors("itemPosition", analyticsContext, -1)
	local v29 = findAnalyticsFieldInAncestors("topicDataPosition", analyticsContext, v28)
	local v30 = findAnalyticsFieldInAncestors("heroUnitId", analyticsContext)
	local v31 = findAnalyticsFieldInAncestors("eventContext", analyticsContext, "ExperienceTile")
	local v32 = findAnalyticsFieldInAncestors("referralSource", analyticsContext)
	local v33 = findAnalyticsFieldInAncestors("gamePlaySessionType", analyticsContext)

	if v33 then
		SetGamePlaySession(sessionService, v33, true)
	end

	local v34 = findAnalyticsFieldInAncestors("nativeAdData", analyticsContext)

	if v34 == nil then
		v34 = findAnalyticsFieldInAncestors("adId", analyticsContext)
	end

	if v34 then
		sponsoredGamesRecordClick(sduiContext.dependencies.networking, (tostring(v34)))
	end

	local v35 = if not FFlagSduiExperienceDetailsSupport then calculateRowPositionFields(v28, itemsPerRow, startRowNumber) else if typeof(v28) ~= "number" or (typeof(itemsPerRow) ~= "number" or (typeof(startRowNumber) ~= "number" or (v28 == -1 or (itemsPerRow == -1 or startRowNumber == -1)))) then {} else calculateRowPositionFields(v28, itemsPerRow, startRowNumber)
	local v36 = findAnalyticsFieldInAncestors("tileType", analyticsContext, "GameTile")

	if FFlagSduiExperienceDetailsSupport then
		gamePlayIntent(eventIngest, tostring(v31), {
			placeId = tostring(placeId or v15),
			rootPlaceId = tonumber(v15),
			universeId = tostring(universeId),
			sortIndex = if not v25 then nil else tostring(v25),
			sortEntryIndex = if typeof(v28) ~= "number" or v28 == -1 then nil else tostring(v28),
			referralSource = v32,
			gameSetTypeId = if not v26 then nil else tostring(v26),
			gameSetTargetId = v27,
			appliedFilters = appliedFilters,
			topicDataPosition = typeof(v29) == "number" and (v29 ~= -1 and v29) or nil,
			nativeAdData = v34,
			pageName = sduiContext.appPage,
			positionInRow = v35.positionInRow,
			rowNumber = v35.rowInSort,
			feedRowNumber = v35.rowOnPage,
			heroUnitId = v30,
			tileType = v36,
			launchData = v17
		})

		return
	end

	gamePlayIntent(eventIngest, tostring(v31), {
		placeId = tostring(placeId),
		rootPlaceId = tonumber(v15),
		universeId = tostring(universeId),
		sortIndex = tostring(v25),
		sortEntryIndex = if not v28 then nil else tostring(v28),
		referralSource = v32,
		gameSetTypeId = tostring(v26),
		gameSetTargetId = v27,
		appliedFilters = appliedFilters,
		topicDataPosition = v29,
		nativeAdData = v34,
		pageName = sduiContext.appPage,
		positionInRow = v35.positionInRow,
		rowNumber = v35.rowInSort,
		feedRowNumber = v35.rowOnPage,
		heroUnitId = v30,
		tileType = v36
	})
end

return sduiReportGamePlayIntent
