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

local function useSduiReportExperienceLaunched(p1, p2, s1: string, s2: string?, s3: string?, p3, s4: string?) -- line: 24
	-- upvalues: React (copy), FFlagSduiLaunchExperienceAction (copy), sduiReportGamePlayIntent (copy), FFlagSduiExperienceDetailsSupport (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy)
	local eventIngest = p1.dependencies.eventIngest
	local sessionService = p1.dependencies.sessionService

	return React.useCallback(function() -- line: 37
		-- upvalues: FFlagSduiLaunchExperienceAction (copy), sduiReportGamePlayIntent (copy), p1 (copy), p2 (copy), s1 (copy), s2 (copy), s3 (ref), p3 (copy), FFlagSduiExperienceDetailsSupport (copy), s4 (copy), findAnalyticsFieldInAncestors (copy), SetGamePlaySession (copy), sessionService (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), gamePlayIntent (copy), eventIngest (copy)
		if FFlagSduiLaunchExperienceAction then
			sduiReportGamePlayIntent({
				sduiContext = p1,
				analyticsContext = p2,
				universeId = s1,
				placeId = s2,
				rootPlaceId = s3,
				appliedFilters = p3,
				launchData = if not FFlagSduiExperienceDetailsSupport then nil else s4
			})

			return
		end

		s3 = s3 or s2

		local collectionPosition = nil
		local collectionId = nil
		local itemsPerRow = nil
		local startRowNumber = nil
		local v27 = p2.getCollectionData and p2.getCollectionData() or nil

		if v27 then
			collectionPosition = v27.collectionPosition
			collectionId = v27.collectionId
			itemsPerRow = v27.itemsPerRow
			startRowNumber = v27.startRowNumber
		end

		local v28 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", p2)
		local v29 = collectionId or findAnalyticsFieldInAncestors("collectionId", p2)
		local v30 = findAnalyticsFieldInAncestors("gameSetTargetId", p2)
		local v31 = findAnalyticsFieldInAncestors("itemPosition", p2, -1)
		local v32 = findAnalyticsFieldInAncestors("topicDataPosition", p2, v31)
		local v33 = findAnalyticsFieldInAncestors("heroUnitId", p2)
		local v34 = findAnalyticsFieldInAncestors("eventContext", p2, "ExperienceTile")
		local v35 = findAnalyticsFieldInAncestors("referralSource", p2)
		local v36 = findAnalyticsFieldInAncestors("gamePlaySessionType", p2)

		if v36 then
			SetGamePlaySession(sessionService, v36, true)
		end

		local v37 = findAnalyticsFieldInAncestors("nativeAdData", p2)

		if v37 == nil then
			v37 = findAnalyticsFieldInAncestors("adId", p2)
		end

		if v37 then
			sponsoredGamesRecordClick(p1.dependencies.networking, (tostring(v37)))
		end

		local v38 = calculateRowPositionFields(v31, itemsPerRow, startRowNumber)
		local v39 = findAnalyticsFieldInAncestors("tileType", p2, "GameTile")

		gamePlayIntent(eventIngest, tostring(v34), {
			placeId = tostring(s2),
			rootPlaceId = tonumber(s3),
			universeId = tostring(s1),
			sortIndex = tostring(v28),
			sortEntryIndex = if not v31 then nil else tostring(v31),
			referralSource = v35,
			gameSetTypeId = tostring(v29),
			gameSetTargetId = v30,
			appliedFilters = p3,
			topicDataPosition = v32,
			nativeAdData = v37,
			pageName = p1.appPage,
			positionInRow = v38.positionInRow,
			rowNumber = v38.rowInSort,
			feedRowNumber = v38.rowOnPage,
			heroUnitId = v33,
			tileType = v39,
			launchData = if not FFlagSduiExperienceDetailsSupport then nil else s4
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
