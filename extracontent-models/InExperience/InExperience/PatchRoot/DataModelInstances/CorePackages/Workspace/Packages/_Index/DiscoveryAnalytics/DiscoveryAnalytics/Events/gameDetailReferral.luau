local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local Cryo = require(parent.Cryo)
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableShareLinksInGameDetailEvent = SharedFlags.FFlagEnableShareLinksInGameDetailEvent
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags2.FFlagEnableTopSongsSort
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameDetailEventMobileAdsId = SharedFlags3.FFlagLuaAppGameDetailEventMobileAdsId

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameEventsTelemetryService = SharedFlags4.FFlagLuaAppMigrateGameEventsTelemetryService

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = SharedFlags5.FFlagLuaAppGameEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppGameDetailReferralEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppGameDetailReferralShadowThrottlingHundredthsPercent", 10000)

local v = FFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gameDetailReferral",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when the user navigates to game details"
} or nil

local v2 = FFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
	eventName = "gameDetailReferralShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for gameDetailReferral event recovery percentage"
} or nil

local strictInterface = t.strictInterface
local v3 = {}
v3.pg = t.string
v3.universeId = t.union(t.string, t.number)
v3.navigationUniverseId = t.optional(t.string)
v3.pos = t.optional(t.number)
v3.pid = t.optional(t.union(t.number, t.string))
v3.sortPos = t.optional(t.number)
v3.ad = t.optional(t.string)
v3.isAd = t.optional(t.boolean)
v3.nativeAdData = t.optional(t.string)
v3.gameSetTargetId = t.optional(t.number)
v3.gameSetTypeId = t.optional(t.string)
v3.tis = t.optional(t.number)
v3.refId = t.optional(t.string)
v3.src = t.optional(t.string)
v3.friendId = t.optional(t.string)
v3.position = t.optional(t.number)
v3.absolutePosition = t.optional(t.number)
v3.fromWhere = t.optional(t.string)
v3.locale = t.optional(t.string)
v3.conversationId = t.optional(t.number)
local shareLinkType

if FFlagEnableShareLinksInGameDetailEvent then
	shareLinkType = t.optional(t.string)
end

v3.shareLinkType = shareLinkType
local shareLinkId

if FFlagEnableShareLinksInGameDetailEvent then
	shareLinkId = t.optional(t.string)
end

v3.shareLinkId = shareLinkId
v3.rowOnPage = t.optional(t.number)
v3.appliedFilters = t.optional(t.string)
v3.topicDataPosition = t.optional(t.number)
local refSongId

if FFlagEnableTopSongsSort then
	refSongId = t.optional(t.string)
end

v3.refSongId = refSongId
v3.isSdui = t.optional(t.boolean)
v3.contentType = t.optional(t.string)
v3.actionType = t.optional(t.string)
v3.interactionUuid = t.optional(t.string)
v3.positionInRow = t.optional(t.number)
v3.rowNumber = t.optional(t.number)
v3.heroUnitId = t.optional(t.string)
v3.loadSource = t.optional(t.string)
v3.tileType = t.optional(t.string)
v3.sortSubId = t.optional(t.string)
v3.analyticsData = t.optional(t.table)
v3.seeAllFlag = t.optional(t.number)
local v4 = strictInterface(v3)

local function addMobileAdvertisingIdToEventParams(state) -- 1 equivalent call inferred from this helper
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		state.mobileAdvertisingId = item
	end
end

return function(object, eventContext: string, state)
	local v5, v6 = v4(state)

	if not v5 then
		DiscoveryEventErrorLogger.reportError("GameDetailReferralInvalidInterface", v6)
	end

	if not state.interactionUuid then
		state.interactionUuid = HttpService:GenerateGUID(false)
	end

	if not state.contentType then
		state.contentType = "Game"
	end

	if not state.actionType then
		state.actionType = "OpenGameDetails"
	end

	if FFlagLuaAppGameDetailEventMobileAdsId then
		addMobileAdvertisingIdToEventParams(state) -- inferred equivalent call
	end

	if state.analyticsData then
		local analyticsData = state.analyticsData
		state = Cryo.Dictionary.join(analyticsData, state, { analyticsData = Cryo.None })
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		state.isSdui = state.isSdui == true and "true" or state.isSdui == false and "false" or nil

		state.isAd = state.isAd == true and "true" or state.isAd == false and "false" or nil

		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = state,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(eventContext, "gameDetailReferral", state)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(state)
		clone.isSdui = clone.isSdui == true and "true" or clone.isSdui == false and "false" or clone.isSdui
		clone.isAd = clone.isAd == true and "true" or clone.isAd == false and "false" or clone.isAd

		TelemetryService:LogEvent(v2, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = clone,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
