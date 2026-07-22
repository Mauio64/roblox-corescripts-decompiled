local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local SetGamePlaySession = require(Parent.RobloxAppSessionization).SetGamePlaySession
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local findAnalyticsFieldInAncestors = require(Parent.SduiCoreSystem).findAnalyticsFieldInAncestors
local sduiReportGamePlayIntent = require(script.Parent.sduiReportGamePlayIntent)
local FFlagSduiLaunchExperienceAction = require(Parent.SharedFlags).FFlagSduiLaunchExperienceAction
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppDemoModePlayButtonTelemetry = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry

local function useSduiReportExperienceLaunched(p1, p2, s1: string, s2: string?, s3: string?, p3, s4: string?) -- line: 25
	-- upvalues: React (copy), FFlagSduiLaunchExperienceAction (copy), sduiReportGamePlayIntent (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy)
	local eventIngest = p1.dependencies.eventIngest
	local sessionService = p1.dependencies.sessionService

	return React.useCallback(function(s5: string?) -- line: 38
		-- upvalues: FFlagSduiLaunchExperienceAction (copy), sduiReportGamePlayIntent (copy), p1 (copy), p2 (copy), s1 (copy), s2 (copy), s3 (ref), p3 (copy), FFlagSduiExperienceDetailsSupport (copy), s4 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sessionService (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy), eventIngest (copy)
		if FFlagSduiLaunchExperienceAction then
			sduiReportGamePlayIntent({
				sduiContext = p1,
				analyticsContext = p2,
				universeId = s1,
				placeId = s2,
				rootPlaceId = s3,
				appliedFilters = p3,
				launchData = if not FFlagSduiExperienceDetailsSupport then nil else s4,
				actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s5
			})

			return
		end

		s3 = s3 or s2

		local collectionPosition = nil
		local collectionId = nil
		local itemsPerRow = nil
		local startRowNumber = nil
		local v29 = p2.getCollectionData and p2.getCollectionData() or nil

		if v29 then
			collectionPosition = v29.collectionPosition
			collectionId = v29.collectionId
			itemsPerRow = v29.itemsPerRow
			startRowNumber = v29.startRowNumber
		end

		local v30 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", p2)
		local v31 = collectionId or findAnalyticsFieldInAncestors("collectionId", p2)
		local v32 = findAnalyticsFieldInAncestors("gameSetTargetId", p2)
		local v33 = findAnalyticsFieldInAncestors("itemPosition", p2, -1)
		local v34 = findAnalyticsFieldInAncestors("topicDataPosition", p2, v33)
		local v35 = findAnalyticsFieldInAncestors("heroUnitId", p2)
		local v36 = findAnalyticsFieldInAncestors("eventContext", p2, "ExperienceTile")
		local v37 = findAnalyticsFieldInAncestors("referralSource", p2)
		local v38 = findAnalyticsFieldInAncestors("gamePlaySessionType", p2)

		if v38 then
			SetGamePlaySession(sessionService, v38, true)
		end

		local v39 = findAnalyticsFieldInAncestors("nativeAdData", p2)

		if v39 == nil then
			v39 = findAnalyticsFieldInAncestors("adId", p2)
		end

		if v39 then
			sponsoredGamesRecordClick(p1.dependencies.networking, (tostring(v39)))
		end

		local v40 = calculateRowPositionFields(v33, itemsPerRow, startRowNumber)
		local v41 = findAnalyticsFieldInAncestors("tileType", p2, "GameTile")

		gamePlayIntent(eventIngest, tostring(v36), {
			placeId = tostring(s2),
			rootPlaceId = tonumber(s3),
			universeId = tostring(s1),
			sortIndex = tostring(v30),
			sortEntryIndex = if not v33 then nil else tostring(v33),
			referralSource = v37,
			gameSetTypeId = tostring(v31),
			gameSetTargetId = v32,
			appliedFilters = p3,
			topicDataPosition = v34,
			nativeAdData = v39,
			pageName = p1.appPage,
			positionInRow = v40.positionInRow,
			rowNumber = v40.rowInSort,
			feedRowNumber = v40.rowOnPage,
			heroUnitId = v35,
			tileType = v41,
			launchData = if not FFlagSduiExperienceDetailsSupport then nil else s4,
			actionType = if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s5
		})
	end, {
		eventIngest,
		p2,
		s1,
		s2,
		s3,
		p3,
		if not FFlagSduiExperienceDetailsSupport then nil else s4,
		sessionService,
		p1
	})
end

return useSduiReportExperienceLaunched
