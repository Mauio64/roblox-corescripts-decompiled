local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Cryo")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagEnableShareLinksInGameDetailEvent
local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagEnableTopSongsSort
local fFlagLuaAppGameDetailEventMobileAdsId = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppGameDetailEventMobileAdsId

local fFlagLuaAppMigrateGameEventsTelemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppMigrateGameEventsTelemetryService

local fFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppGameEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppGameDetailReferralEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt(
	"LuaAppGameDetailReferralShadowThrottlingHundredthsPercent",
	10000
)

local v5 = fFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gameDetailReferral",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when the user navigates to game details"
} or nil

local v6 = fFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
	eventName = "gameDetailReferralShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for gameDetailReferral event recovery percentage"
} or nil

local strictInterface = t.strictInterface
local v7 = {}
v7.pg = t.string
v7.universeId = t.union(t.string, t.number)
v7.navigationUniverseId = t.optional(t.string)
v7.pos = t.optional(t.number)
v7.pid = t.optional(t.union(t.number, t.string))
v7.sortPos = t.optional(t.number)
v7.ad = t.optional(t.string)
v7.isAd = t.optional(t.boolean)
v7.nativeAdData = t.optional(t.string)
v7.gameSetTargetId = t.optional(t.number)
v7.gameSetTypeId = t.optional(t.string)
v7.tis = t.optional(t.number)
v7.refId = t.optional(t.string)
v7.src = t.optional(t.string)
v7.friendId = t.optional(t.string)
v7.position = t.optional(t.number)
v7.absolutePosition = t.optional(t.number)
v7.fromWhere = t.optional(t.string)
v7.locale = t.optional(t.string)
v7.conversationId = t.optional(t.number)
local v8 = if fFlagEnableShareLinksInGameDetailEvent then t.optional(t.string) else nil
v7.shareLinkType = v8
local v9 = if fFlagEnableShareLinksInGameDetailEvent then t.optional(t.string) else nil
v7.shareLinkId = v9
v7.rowOnPage = t.optional(t.number)
v7.appliedFilters = t.optional(t.string)
v7.topicDataPosition = t.optional(t.number)
local v10 = if fFlagEnableTopSongsSort then t.optional(t.string) else nil
v7.refSongId = v10
v7.isSdui = t.optional(t.boolean)
v7.contentType = t.optional(t.string)
v7.actionType = t.optional(t.string)
v7.interactionUuid = t.optional(t.string)
v7.positionInRow = t.optional(t.number)
v7.rowNumber = t.optional(t.number)
v7.heroUnitId = t.optional(t.string)
v7.loadSource = t.optional(t.string)
v7.tileType = t.optional(t.string)
v7.sortSubId = t.optional(t.string)
v7.analyticsData = t.optional(t.table)
v7.seeAllFlag = t.optional(t.number)
local v11 = strictInterface(v7)

local function addMobileAdvertisingIdToEventParams(p2)
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		p2.mobileAdvertisingId = item
	end
end

return function(object, p2, state)
	local v12, v13 = v11(state)

	if not v12 then
		discoveryEventErrorLogger.reportError("GameDetailReferralInvalidInterface", v13)
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

	if fFlagLuaAppGameDetailEventMobileAdsId then
		local item = AppStorageService:GetItem("MobileAdvertisingId")

		if item and item ~= "" then
			state.mobileAdvertisingId = item
		end
	end

	if state.analyticsData then
		local analyticsData = state.analyticsData
		state = Cryo.Dictionary.join(analyticsData, state, {
			analyticsData = Cryo.None
		})
	end

	if fFlagLuaAppMigrateGameEventsTelemetryService then
		state.isSdui = state.isSdui == true and "true" or state.isSdui == false and "false" or nil

		state.isAd = state.isAd == true and "true" or state.isAd == false and "false" or nil

		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = state,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(p2, "gameDetailReferral", state)
	end

	if fFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(state)
		clone.isSdui = clone.isSdui == true and "true" or clone.isSdui == false and "false" or clone.isSdui
		clone.isAd = clone.isAd == true and "true" or clone.isAd == false and "false" or clone.isAd

		TelemetryService:LogEvent(v6, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = clone,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
