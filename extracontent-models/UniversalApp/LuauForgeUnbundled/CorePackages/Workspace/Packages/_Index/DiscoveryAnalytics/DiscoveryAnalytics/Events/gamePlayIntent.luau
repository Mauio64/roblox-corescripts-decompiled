local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Cryo")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppGamePlayIntentEventMobileAdsId = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppGamePlayIntentEventMobileAdsId
local fFlagTraversalHistoryDiscoveryTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagTraversalHistoryDiscoveryTelemetry

local fFlagLuaAppMigrateGameEventsTelemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppMigrateGameEventsTelemetryService

local fFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppGameEventsTelemetryServiceShadowTraffic
local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

local defineFastInt = game:DefineFastInt("LuaAppGamePlayIntentEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppGamePlayIntentShadowThrottlingHundredthsPercent", 10000)

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Constants")

local v5 = fFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gamePlayIntent",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when the user clicks on a Play Button"
} or nil

local v6 = fFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
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
local v7 = {
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
local v8 = if fFlagLuaAppDemoModePlayButtonTelemetry then t.optional(t.string) else nil
v7.actionType = v8
local v9 = strictInterface2(v7)

local strictInterface3 = t.strictInterface
local v10 = {
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
local v11 = if fFlagLuaAppDemoModePlayButtonTelemetry then t.optional(t.string) else nil
v10.actionType = v11
local v12 = strictInterface3(v10)

local strictInterface4 = t.strictInterface
local v13 = {
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
local v14 = if fFlagLuaAppDemoModePlayButtonTelemetry then t.optional(t.string) else nil
v13.actionType = v14
local v15 = strictInterface4(v13)

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
local v16 = {
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
local v17 = if fFlagLuaAppDemoModePlayButtonTelemetry then t.optional(t.string) else nil
v16.actionType = v17
local v18 = strictInterface10(v16)
local v19

if fFlagTraversalHistoryDiscoveryTelemetry then
	v19 = t.strictInterface({
		placeId = t.string,
		universeId = t.string,
		sortEntryIndex = t.string,
		pageName = t.optional(t.string)
	})
end

local v20 = {
	PlayButton = v9,
	[Constants.Context.ExperienceTile] = v12,
	[Constants.Context.SearchExperienceTile] = v15,
	[Constants.Context.PeopleListInHomePage] = strictInterface5,
	[Constants.Context.GamePlayIntentInPlacesList] = strictInterface6,
	shareLinks = strictInterface8,
	PlayGameFromPlayTogether = strictInterface,
	PlayGameFromLinkCard = strictInterface7,
	[Constants.Context.PlayerContextualMenu] = strictInterface9,
	[Constants.Context.HoldToPlayLauncher] = v18
}
local inExpHistoryTile = Constants.Context.InExpHistoryTile

if not fFlagTraversalHistoryDiscoveryTelemetry then
	v19 = nil
end

v20[inExpHistoryTile] = v19

local instantPlay = Constants.Context.InstantPlay

if not fFlagLuaAppContinueSortInstantPlay then
	v12 = nil
end

v20[instantPlay] = v12

local function addMobileAdvertisingIdToEventParams(p2)
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		p2.mobileAdvertisingId = item
	end
end

return function(object, p2, state)
	if v20[p2] == nil then
		discoveryEventErrorLogger.reportError(
			"GamePlayIntentMissingInterface",
			`Missing interface for eventContext {p2} to type check gamePlayIntent event parameters`,
			{ eventContext = p2 }
		)
	else
		local v21, v22 = v20[p2](state)

		if not v21 then
			discoveryEventErrorLogger.reportError("GamePlayIntentInvalidInterface", v22)
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

	if fFlagLuaAppGamePlayIntentEventMobileAdsId then
		local item = AppStorageService:GetItem("MobileAdvertisingId")

		if item and item ~= "" then
			state.mobileAdvertisingId = item
		end
	end

	if fFlagLuaAppMigrateGameEventsTelemetryService then
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

		local v21 = if fFlagLuaAppGamePlayIntentEventMobileAdsId then state.mobileAdvertisingId else nil
		joined.mobileAdvertisingId = v21

		joined.loadSource = state.loadSource
		local v22 = if state.launchData then state.launchData else nil
		joined.launchData = v22
		joined.sortSubId = state.sortSubId
		joined.tileType = state.tileType

		if analyticsData then
			joined = Cryo.Dictionary.join(analyticsData, joined)
		end

		TelemetryService:LogEvent(v5, {
			eventContext = p2,
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

		local v21 = if fFlagLuaAppGamePlayIntentEventMobileAdsId then state.mobileAdvertisingId else nil
		joined.mobileAdvertisingId = v21

		joined.loadSource = state.loadSource
		local v22 = if state.launchData then state.launchData else nil
		joined.launchData = v22
		joined.sortSubId = state.sortSubId
		joined.tileType = state.tileType

		if analyticsData then
			joined = Cryo.Dictionary.join(analyticsData, joined)
		end

		object:sendEventDeferred(p2, "gamePlayIntent", joined)
	end

	if fFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		local v24 = {
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

		local v25 = if fFlagLuaAppGamePlayIntentEventMobileAdsId then state.mobileAdvertisingId else nil
		v24.mobileAdvertisingId = v25

		v24.loadSource = state.loadSource
		local v26 = if state.launchData then state.launchData else nil
		v24.launchData = v26
		v24.sortSubId = state.sortSubId
		v24.tileType = state.tileType
		TelemetryService:LogEvent(v6, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = v24,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
