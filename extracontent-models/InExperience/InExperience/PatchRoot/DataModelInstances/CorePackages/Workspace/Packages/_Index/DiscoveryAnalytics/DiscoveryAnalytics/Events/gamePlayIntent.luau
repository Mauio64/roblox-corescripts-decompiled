local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent

local Cryo = require(parent.Cryo)
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGamePlayIntentEventMobileAdsId = SharedFlags.FFlagLuaAppGamePlayIntentEventMobileAdsId
local SharedFlags2 = require(parent.SharedFlags)
local FFlagTraversalHistoryDiscoveryTelemetry = SharedFlags2.FFlagTraversalHistoryDiscoveryTelemetry

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameEventsTelemetryService = SharedFlags3.FFlagLuaAppMigrateGameEventsTelemetryService

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = SharedFlags4.FFlagLuaAppGameEventsTelemetryServiceShadowTraffic
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags5.FFlagLuaAppContinueSortInstantPlay
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags6.FFlagLuaAppDemoModePlayButtonTelemetry

local defineFastInt = game:DefineFastInt("LuaAppGamePlayIntentEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppGamePlayIntentShadowThrottlingHundredthsPercent", 10000)

local Constants = require(DiscoveryAnalytics.Constants)

local v = FFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gamePlayIntent",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when the user clicks on a Play Button"
} or nil

local v2 = FFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
	eventName = "gamePlayIntentShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for gamePlayIntent event recovery percentage"
} or nil

local strictInterface = t.strictInterface({
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
	pageName = t.optional(t.string)
})

local strictInterface2 = t.strictInterface
local v3 = {
	placeId = t.union(t.string, t.number),
	rootPlaceId = t.union(t.number, t.string),
	referralSource = t.optional(t.string),
	universeId = t.string,
	launchData = t.optional(t.string),
	tileType = t.optional(t.string),
	nativeAdData = t.optional(t.string),
	pageName = t.optional(t.string),
	actionType = 0
}
local actionType

if FFlagLuaAppDemoModePlayButtonTelemetry then
	actionType = t.optional(t.string)
end

v3.actionType = actionType
local playButton = strictInterface2(v3)

local strictInterface3 = t.strictInterface
local v4 = {
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
	sortSubId = t.optional(t.string),
	tileType = t.string,
	analyticsData = t.optional(t.table),
	actionType = 0
}
local actionType2

if FFlagLuaAppDemoModePlayButtonTelemetry then
	actionType2 = t.optional(t.string)
end

v4.actionType = actionType2
local v5 = strictInterface3(v4)

local strictInterface4 = t.strictInterface
local v6 = {
	placeId = t.string,
	rootPlaceId = t.number,
	universeId = t.string,
	sortEntryIndex = t.string,
	gameSetTypeId = t.string,
	sortIndex = t.string,
	rowOnPage = t.optional(t.number),
	topicDataPosition = t.optional(t.number),
	nativeAdData = t.optional(t.string),
	pageName = t.optional(t.string),
	launchData = t.optional(t.string),
	tileType = t.string,
	positionInRow = t.optional(t.number),
	rowNumber = t.optional(t.number),
	feedRowNumber = t.optional(t.number),
	actionType = 0
}
local actionType3

if FFlagLuaAppDemoModePlayButtonTelemetry then
	actionType3 = t.optional(t.string)
end

v6.actionType = actionType3
local v7 = strictInterface4(v6)

local strictInterface5 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	friendId = t.string,
	pageName = t.optional(t.string)
})

local strictInterface6 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	friendId = t.string,
	pageName = t.optional(t.string)
})

local strictInterface7 = t.strictInterface({
	placeId = t.string,
	rootPlaceId = t.number,
	joinAttemptId = t.optional(t.string),
	conversationId = t.optional(t.string),
	pageName = t.optional(t.string)
})

local strictInterface8 = t.strictInterface({
	placeId = t.union(t.string, t.number),
	rootPlaceId = t.union(t.number, t.string),
	linkId = t.string,
	linkType = t.string,
	linkStatus = t.string,
	joinAttemptId = t.optional(t.string),
	pageName = t.optional(t.string)
})

local strictInterface9 = t.strictInterface({
	friendId = t.string,
	pageName = t.string,
	placeId = t.optional(t.string),
	rootPlaceId = t.optional(t.string),
	joinAttemptId = t.string
})

local strictInterface10 = t.strictInterface
local v8 = {
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
	tileType = t.string,
	actionType = 0
}
local actionType4

if FFlagLuaAppDemoModePlayButtonTelemetry then
	actionType4 = t.optional(t.string)
end

v8.actionType = actionType4
local v9 = strictInterface10(v8)
local v10

if FFlagTraversalHistoryDiscoveryTelemetry then
	v10 = t.strictInterface({
		placeId = t.string,
		universeId = t.string,
		sortEntryIndex = t.string,
		pageName = t.optional(t.string)
	})
end

local v11 = {
	PlayButton = playButton,
	[Constants.Context.ExperienceTile] = v5,
	[Constants.Context.SearchExperienceTile] = v7,
	[Constants.Context.PeopleListInHomePage] = strictInterface5,
	[Constants.Context.GamePlayIntentInPlacesList] = strictInterface6,
	shareLinks = strictInterface8,
	PlayGameFromPlayTogether = strictInterface,
	PlayGameFromLinkCard = strictInterface7,
	[Constants.Context.PlayerContextualMenu] = strictInterface9,
	[Constants.Context.HoldToPlayLauncher] = v9
}
local InExpHistoryTile = Constants.Context.InExpHistoryTile

if not FFlagTraversalHistoryDiscoveryTelemetry then
	v10 = nil
end

v11[InExpHistoryTile] = v10

local InstantPlay = Constants.Context.InstantPlay

if not FFlagLuaAppContinueSortInstantPlay then
	v5 = nil
end

v11[InstantPlay] = v5

local function addMobileAdvertisingIdToEventParams(state) -- 1 equivalent call inferred from this helper
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		state.mobileAdvertisingId = item
	end
end

return function(object, eventContext: string, state)
	if v11[eventContext] == nil then
		DiscoveryEventErrorLogger.reportError(
			"GamePlayIntentMissingInterface",
			`Missing interface for eventContext {eventContext} to type check gamePlayIntent event parameters`,
			{ eventContext = eventContext }
		)
	else
		local v12, v13 = v11[eventContext](state)

		if not v12 then
			DiscoveryEventErrorLogger.reportError("GamePlayIntentInvalidInterface", v13)
		end
	end

	local analyticsData = state.analyticsData

	if not state.interactionUuid then
		state.interactionUuid = HttpService:GenerateGUID(false)
	end

	if not state.contentType then
		state.contentType = "Game"
	end

	if not state.actionType then
		state.actionType = "PlayButtonClick"
	end

	if FFlagLuaAppGamePlayIntentEventMobileAdsId then
		addMobileAdvertisingIdToEventParams(state) -- inferred equivalent call
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		local joined = {
			placeId = state.placeId,
			rootPlaceId = state.rootPlaceId,
			universeId = state.universeId,
			referralSource = state.referralSource,
			sortIndex = state.sortIndex,
			sortEntryIndex = state.sortEntryIndex,
			gameSetTypeId = state.gameSetTypeId,
			gameSetTargetId = state.gameSetTargetId,
			linkId = state.linkId,
			linkType = state.linkType,
			linkStatus = state.linkStatus,
			conversationId = state.conversationId,
			joinAttemptId = state.joinAttemptId,
			friendId = state.friendId,
			pageName = state.pageName,
			rowOnPage = state.rowOnPage,
			appliedFilters = state.appliedFilters,
			topicDataPosition = state.topicDataPosition,
			nativeAdData = state.nativeAdData,
			interactionUuid = state.interactionUuid,
			contentType = state.contentType,
			actionType = state.actionType,
			positionInRow = state.positionInRow,
			rowNumber = state.rowNumber,
			feedRowNumber = state.feedRowNumber,
			heroUnitId = state.heroUnitId,
			mobileAdvertisingId = 0,
			loadSource = 0,
			launchData = 0,
			sortSubId = 0,
			tileType = 0
		}
		local mobileAdvertisingId

		if FFlagLuaAppGamePlayIntentEventMobileAdsId then
			mobileAdvertisingId = state.mobileAdvertisingId
		end

		joined.mobileAdvertisingId = mobileAdvertisingId

		joined.loadSource = state.loadSource
		local launchData

		if state.launchData then
			launchData = state.launchData
		end

		joined.launchData = launchData
		joined.sortSubId = state.sortSubId
		joined.tileType = state.tileType

		if analyticsData then
			joined = Cryo.Dictionary.join(analyticsData, joined)
		end

		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = joined,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		local joined = {
			placeId = state.placeId,
			rootPlaceId = state.rootPlaceId,
			universeId = state.universeId,
			referralSource = state.referralSource,
			sortIndex = state.sortIndex,
			sortEntryIndex = state.sortEntryIndex,
			gameSetTypeId = state.gameSetTypeId,
			gameSetTargetId = state.gameSetTargetId,
			linkId = state.linkId,
			linkType = state.linkType,
			linkStatus = state.linkStatus,
			conversationId = state.conversationId,
			joinAttemptId = state.joinAttemptId,
			friendId = state.friendId,
			pageName = state.pageName,
			rowOnPage = state.rowOnPage,
			appliedFilters = state.appliedFilters,
			topicDataPosition = state.topicDataPosition,
			nativeAdData = state.nativeAdData,
			interactionUuid = state.interactionUuid,
			contentType = state.contentType,
			actionType = state.actionType,
			positionInRow = state.positionInRow,
			rowNumber = state.rowNumber,
			feedRowNumber = state.feedRowNumber,
			heroUnitId = state.heroUnitId,
			mobileAdvertisingId = 0,
			loadSource = 0,
			launchData = 0,
			sortSubId = 0,
			tileType = 0
		}
		local mobileAdvertisingId

		if FFlagLuaAppGamePlayIntentEventMobileAdsId then
			mobileAdvertisingId = state.mobileAdvertisingId
		end

		joined.mobileAdvertisingId = mobileAdvertisingId

		joined.loadSource = state.loadSource
		local launchData

		if state.launchData then
			launchData = state.launchData
		end

		joined.launchData = launchData
		joined.sortSubId = state.sortSubId
		joined.tileType = state.tileType

		if analyticsData then
			joined = Cryo.Dictionary.join(analyticsData, joined)
		end

		object:sendEventDeferred(eventContext, "gamePlayIntent", joined)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		local customFields = {
			placeId = state.placeId,
			rootPlaceId = state.rootPlaceId,
			universeId = state.universeId,
			referralSource = state.referralSource,
			sortIndex = state.sortIndex,
			sortEntryIndex = state.sortEntryIndex,
			gameSetTypeId = state.gameSetTypeId,
			gameSetTargetId = state.gameSetTargetId,
			linkId = state.linkId,
			linkType = state.linkType,
			linkStatus = state.linkStatus,
			conversationId = state.conversationId,
			joinAttemptId = state.joinAttemptId,
			friendId = state.friendId,
			pageName = state.pageName,
			rowOnPage = state.rowOnPage,
			appliedFilters = state.appliedFilters,
			topicDataPosition = state.topicDataPosition,
			nativeAdData = state.nativeAdData,
			interactionUuid = state.interactionUuid,
			contentType = state.contentType,
			actionType = state.actionType,
			positionInRow = state.positionInRow,
			rowNumber = state.rowNumber,
			feedRowNumber = state.feedRowNumber,
			heroUnitId = state.heroUnitId,
			mobileAdvertisingId = 0,
			loadSource = 0,
			launchData = 0,
			sortSubId = 0,
			tileType = 0
		}
		local mobileAdvertisingId

		if FFlagLuaAppGamePlayIntentEventMobileAdsId then
			mobileAdvertisingId = state.mobileAdvertisingId
		end

		customFields.mobileAdvertisingId = mobileAdvertisingId

		customFields.loadSource = state.loadSource
		local launchData

		if state.launchData then
			launchData = state.launchData
		end

		customFields.launchData = launchData
		customFields.sortSubId = state.sortSubId
		customFields.tileType = state.tileType
		TelemetryService:LogEvent(v2, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
