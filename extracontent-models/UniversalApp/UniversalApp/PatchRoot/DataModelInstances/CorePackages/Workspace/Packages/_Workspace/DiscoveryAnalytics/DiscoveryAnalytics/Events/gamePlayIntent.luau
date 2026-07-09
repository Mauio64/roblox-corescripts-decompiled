local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local DiscoveryAnalyticsParent = DiscoveryAnalytics.Parent
local Cryo = require(DiscoveryAnalyticsParent.Cryo)
local getPlatformTarget = require(DiscoveryAnalyticsParent.Analytics).getPlatformTarget
local t = require(DiscoveryAnalyticsParent.t)
local DiscoveryEventErrorLogger = require(DiscoveryAnalyticsParent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagEnableInGameExitModalNextUpUi = require(DiscoveryAnalyticsParent.SharedFlags).FFlagEnableInGameExitModalNextUpUi
local FFlagLuaAppGamePlayIntentEventMobileAdsId = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppGamePlayIntentEventMobileAdsId
local FFlagTraversalHistoryDiscoveryTelemetry = require(DiscoveryAnalyticsParent.SharedFlags).FFlagTraversalHistoryDiscoveryTelemetry
local FFlagLuaAppAddSubIdToHomeEvents = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixCustomTileBugs = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppFixCustomTileBugs
local v15 = game:DefineFastFlag("LuaAppRemoveNumericalSortIndexSearch", false) and FFlagLuaAppFixCustomTileBugs
local FFlagSduiExperienceDetailsSupport = require(DiscoveryAnalyticsParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppMigrateGameEventsTelemetryService = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppMigrateGameEventsTelemetryService
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppGameEventsTelemetryServiceShadowTraffic
local FFlagLuaAppGameItemTelemetryServiceTarget = require(DiscoveryAnalyticsParent.SharedFlags).FFlagLuaAppGameItemTelemetryServiceTarget
local v20 = game:DefineFastInt("LuaAppGamePlayIntentEventThrottlingHundredthsPercent", 10000)
local v21 = game:DefineFastInt("LuaAppGamePlayIntentShadowThrottlingHundredthsPercent", 10000)
local Constants = require(DiscoveryAnalytics.Constants)
local t1 = nil

if FFlagLuaAppMigrateGameEventsTelemetryService then
	t1 = {
		eventName = "gamePlayIntent",
		description = "Fires when the user clicks on a Play Button",
		backends = { "EventIngest" },
		throttlingPercentage = v20,
		lastUpdated = {
			26,
			2,
			4
		}
	}
end

local t2 = nil

if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
	t2 = {
		eventName = "gamePlayIntentShadow",
		description = "Shadow traffic for gamePlayIntent event recovery percentage",
		backends = { "EventIngest" },
		throttlingPercentage = v21,
		lastUpdated = {
			26,
			3,
			4
		}
	}
end

local v25 = t.strictInterface({
	placeId = t.union(t.string, t.number),
	rootPlaceId = t.union(t.number, t.string),
	referralSource = t.optional(t.string),
	sortIndex = t.optional(t.string),
	sortEntryIndex = t.optional(t.string),
	gameSetTypeId = t.optional(t.string),
	gameSetTargetId = t.optional(t.number),
	linkId = t.optional(t.union(t.string, t.number)),
	linkType = t.optional(t.string),
	linkStatus = t.optional(t.string),
	conversationId = t.optional(t.union(t.number, t.string)),
	joinAttemptId = t.optional(t.string),
	uid = t.optional(t.string),
	launchData = t.optional(t.string),
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v26 = t.strictInterface({
	placeId = t.union(t.string, t.number),
	rootPlaceId = t.union(t.number, t.string),
	referralSource = t.optional(t.string),
	universeId = t.string,
	launchData = t.optional(t.string),
	tileType = t.optional(t.string),
	nativeAdData = t.optional(t.string),
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v27 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	universeId = t.string,
	referralSource = t.optional(t.string),
	sortIndex = t.string,
	sortEntryIndex = t.string,
	gameSetTypeId = t.optional(t.string),
	gameSetTargetId = t.optional(t.number),
	appliedFilters = t.optional(t.string),
	topicDataPosition = t.optional(t.number),
	nativeAdData = t.optional(t.string),
	pageName = t.optional(t.string),
	positionInRow = t.optional(t.number),
	rowNumber = t.optional(t.number),
	feedRowNumber = t.optional(t.number),
	heroUnitId = t.optional(t.string),
	loadSource = t.optional(t.string),
	launchData = t.optional(t.string),
	sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else t.optional(t.string),
	tileType = t.string,
	analyticsData = t.optional(t.table)
})
local v28 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	universeId = t.string,
	sortEntryIndex = t.string,
	gameSetTypeId = t.string,
	sortIndex = if not v15 then if not FFlagLuaAppFixCustomTileBugs then t.number else t.union(t.string, t.number) else t.string,
	rowOnPage = t.optional(t.number),
	topicDataPosition = t.optional(t.number),
	nativeAdData = t.optional(t.string),
	pageName = t.optional(t.string),
	launchData = t.optional(t.string),
	tileType = t.string,
	positionInRow = if not FFlagLuaAppFixCustomTileBugs then nil else t.optional(t.number),
	rowNumber = if not FFlagLuaAppFixCustomTileBugs then nil else t.optional(t.number),
	feedRowNumber = if not FFlagLuaAppFixCustomTileBugs then nil else t.optional(t.number)
})
local v29 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	friendId = t.string,
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v30 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	friendId = t.string,
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v31 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	conversationId = t.optional(t.string),
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v32 = t.strictInterface({
	placeId = t.union(t.string, t.number),
	rootPlaceId = t.union(t.number, t.string),
	linkId = t.string,
	linkType = t.string,
	linkStatus = t.string,
	joinAttemptId = t.optional(t.string),
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v33 = t.strictInterface({
	friendId = t.string,
	pageName = t.string,
	placeId = t.optional(t.string),
	rootPlaceId = t.optional(t.string),
	joinAttemptId = t.string
})
local v34 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	universeId = t.string,
	referralSource = t.string,
	sortIndex = t.string,
	sortEntryIndex = t.string,
	gameSetTypeId = t.string,
	gameSetTargetId = t.optional(t.number),
	topicDataPosition = t.optional(t.number),
	nativeAdData = t.optional(t.string),
	pageName = t.optional(t.string),
	tileType = t.string
})
local v35 = if not FFlagEnableInGameExitModalNextUpUi then nil else t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	universeId = t.string,
	sortEntryIndex = t.string,
	gameSetTypeId = t.string,
	joinAttemptId = t.string,
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local v36 = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else t.strictInterface({
	placeId = t.string,
	universeId = t.string,
	sortEntryIndex = t.string,
	pageName = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
})
local t3 = {
	PlayButton = v26,
	[Constants.Context.ExperienceTile] = v27,
	[Constants.Context.SearchExperienceTile] = v28,
	[Constants.Context.PeopleListInHomePage] = v29,
	[Constants.Context.GamePlayIntentInPlacesList] = v30,
	shareLinks = v32,
	PlayGameFromPlayTogether = v25,
	PlayGameFromLinkCard = v31,
	[Constants.Context.PlayerContextualMenu] = v33,
	[Constants.Context.HoldToPlayLauncher] = v34,
	[Constants.Context.InExpHistoryTile] = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else v36,
	InGameExitPage = if not FFlagEnableInGameExitModalNextUpUi then nil else v35
}

local function addMobileAdvertisingIdToEventParams(p1) -- line: 226
	-- upvalues: AppStorageService (copy)
	local Item = AppStorageService:GetItem("MobileAdvertisingId")

	if Item and Item ~= "" then
		p1.mobileAdvertisingId = Item
	end
end

return function(p2, s1: string, p3) -- line: 233
	-- upvalues: t3 (copy), DiscoveryEventErrorLogger (copy), HttpService (copy), FFlagLuaAppGamePlayIntentEventMobileAdsId (copy), AppStorageService (copy), FFlagLuaAppMigrateGameEventsTelemetryService (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), Cryo (copy), TelemetryService (copy), t1 (ref), FFlagLuaAppGameItemTelemetryServiceTarget (copy), getPlatformTarget (copy), FFlagLuaAppGameEventsTelemetryServiceShadowTraffic (copy), t2 (ref)
	if t3[s1] ~= nil then
		local v44, v45 = t3[s1](p3)

		if not v44 then
			DiscoveryEventErrorLogger.reportError("GamePlayIntentInvalidInterface", v45)
		end
	else
		DiscoveryEventErrorLogger.reportError("GamePlayIntentMissingInterface", `Missing interface for eventContext { s1 } to type check gamePlayIntent event parameters`, {
			eventContext = s1
		})
	end

	local analyticsData = p3.analyticsData

	if not p3.interactionUuid then
		p3.interactionUuid = HttpService:GenerateGUID(false)
	end

	if not p3.contentType then
		p3.contentType = "Game"
	end

	if not p3.actionType then
		p3.actionType = "PlayButtonClick"
	end

	if FFlagLuaAppGamePlayIntentEventMobileAdsId then
		local Item = AppStorageService:GetItem("MobileAdvertisingId")

		if Item and Item ~= "" then
			p3.mobileAdvertisingId = Item
		end
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		local t4 = {
			placeId = p3.placeId,
			rootPlaceId = p3.rootPlaceId,
			universeId = p3.universeId,
			referralSource = p3.referralSource,
			sortIndex = p3.sortIndex,
			sortEntryIndex = p3.sortEntryIndex,
			gameSetTypeId = p3.gameSetTypeId,
			gameSetTargetId = p3.gameSetTargetId,
			linkId = p3.linkId,
			linkType = p3.linkType,
			linkStatus = p3.linkStatus,
			conversationId = p3.conversationId,
			joinAttemptId = p3.joinAttemptId,
			friendId = p3.friendId,
			pageName = p3.pageName,
			rowOnPage = p3.rowOnPage,
			appliedFilters = p3.appliedFilters,
			topicDataPosition = p3.topicDataPosition,
			nativeAdData = p3.nativeAdData,
			interactionUuid = p3.interactionUuid,
			contentType = p3.contentType,
			actionType = p3.actionType,
			positionInRow = p3.positionInRow,
			rowNumber = p3.rowNumber,
			feedRowNumber = p3.feedRowNumber,
			heroUnitId = p3.heroUnitId,
			mobileAdvertisingId = if not FFlagLuaAppGamePlayIntentEventMobileAdsId then nil else p3.mobileAdvertisingId,
			loadSource = p3.loadSource,
			launchData = if not p3.launchData then nil else p3.launchData,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p3.sortSubId,
			tileType = p3.tileType
		}

		if analyticsData then
			t4 = Cryo.Dictionary.join(analyticsData, t4)
		end

		TelemetryService:LogEvent(t1, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = t4,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	else
		local t5 = {
			placeId = p3.placeId,
			rootPlaceId = p3.rootPlaceId,
			universeId = p3.universeId,
			referralSource = p3.referralSource,
			sortIndex = p3.sortIndex,
			sortEntryIndex = p3.sortEntryIndex,
			gameSetTypeId = p3.gameSetTypeId,
			gameSetTargetId = p3.gameSetTargetId,
			linkId = p3.linkId,
			linkType = p3.linkType,
			linkStatus = p3.linkStatus,
			conversationId = p3.conversationId,
			joinAttemptId = p3.joinAttemptId,
			friendId = p3.friendId,
			pageName = p3.pageName,
			rowOnPage = p3.rowOnPage,
			appliedFilters = p3.appliedFilters,
			topicDataPosition = p3.topicDataPosition,
			nativeAdData = p3.nativeAdData,
			interactionUuid = p3.interactionUuid,
			contentType = p3.contentType,
			actionType = p3.actionType,
			positionInRow = p3.positionInRow,
			rowNumber = p3.rowNumber,
			feedRowNumber = p3.feedRowNumber,
			heroUnitId = p3.heroUnitId,
			mobileAdvertisingId = if not FFlagLuaAppGamePlayIntentEventMobileAdsId then nil else p3.mobileAdvertisingId,
			loadSource = p3.loadSource,
			launchData = if not p3.launchData then nil else p3.launchData,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p3.sortSubId,
			tileType = p3.tileType
		}

		if analyticsData then
			t5 = Cryo.Dictionary.join(analyticsData, t5)
		end

		p2:sendEventDeferred(s1, "gamePlayIntent", t5)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		TelemetryService:LogEvent(t2, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = {
				placeId = p3.placeId,
				rootPlaceId = p3.rootPlaceId,
				universeId = p3.universeId,
				referralSource = p3.referralSource,
				sortIndex = p3.sortIndex,
				sortEntryIndex = p3.sortEntryIndex,
				gameSetTypeId = p3.gameSetTypeId,
				gameSetTargetId = p3.gameSetTargetId,
				linkId = p3.linkId,
				linkType = p3.linkType,
				linkStatus = p3.linkStatus,
				conversationId = p3.conversationId,
				joinAttemptId = p3.joinAttemptId,
				friendId = p3.friendId,
				pageName = p3.pageName,
				rowOnPage = p3.rowOnPage,
				appliedFilters = p3.appliedFilters,
				topicDataPosition = p3.topicDataPosition,
				nativeAdData = p3.nativeAdData,
				interactionUuid = p3.interactionUuid,
				contentType = p3.contentType,
				actionType = p3.actionType,
				positionInRow = p3.positionInRow,
				rowNumber = p3.rowNumber,
				feedRowNumber = p3.feedRowNumber,
				heroUnitId = p3.heroUnitId,
				mobileAdvertisingId = if not FFlagLuaAppGamePlayIntentEventMobileAdsId then nil else p3.mobileAdvertisingId,
				loadSource = p3.loadSource,
				launchData = if not p3.launchData then nil else p3.launchData,
				sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else p3.sortSubId,
				tileType = p3.tileType
			},
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	end
end
