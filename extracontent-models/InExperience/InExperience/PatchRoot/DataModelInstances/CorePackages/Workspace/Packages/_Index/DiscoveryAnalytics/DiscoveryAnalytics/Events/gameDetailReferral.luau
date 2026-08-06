local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local Cryo = require(Parent.Cryo)
local getPlatformTarget = require(Parent.Analytics).getPlatformTarget
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagEnableShareLinksInGameDetailEvent = require(Parent.SharedFlags).FFlagEnableShareLinksInGameDetailEvent
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppGameDetailEventMobileAdsId = require(Parent.SharedFlags).FFlagLuaAppGameDetailEventMobileAdsId
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppMigrateGameEventsTelemetryService = require(Parent.SharedFlags).FFlagLuaAppMigrateGameEventsTelemetryService
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require(Parent.SharedFlags).FFlagLuaAppGameEventsTelemetryServiceShadowTraffic
local FFlagLuaAppGameItemTelemetryServiceTarget = require(Parent.SharedFlags).FFlagLuaAppGameItemTelemetryServiceTarget
local FFlagLuaAppAddSeeAllFlagToGameDetailReferral = require(Parent.SharedFlags).FFlagLuaAppAddSeeAllFlagToGameDetailReferral
local v17 = game:DefineFastInt("LuaAppGameDetailReferralEventThrottlingHundredthsPercent", 10000)
local v18 = game:DefineFastInt("LuaAppGameDetailReferralShadowThrottlingHundredthsPercent", 10000)
local t1 = nil

if FFlagLuaAppMigrateGameEventsTelemetryService then
	t1 = {
		eventName = "gameDetailReferral",
		description = "Fires when the user navigates to game details",
		backends = { "EventIngest" },
		throttlingPercentage = v17,
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
		eventName = "gameDetailReferralShadow",
		description = "Shadow traffic for gameDetailReferral event recovery percentage",
		backends = { "EventIngest" },
		throttlingPercentage = v18,
		lastUpdated = {
			26,
			3,
			4
		}
	}
end

local v21 = t.strictInterface({
	pg = t.string,
	universeId = t.union(t.string, t.number),
	navigationUniverseId = t.optional(t.string),
	pos = t.optional(t.number),
	pid = t.optional(t.union(t.number, t.string)),
	sortPos = t.optional(t.number),
	ad = t.optional(t.string),
	isAd = t.optional(t.boolean),
	nativeAdData = t.optional(t.string),
	gameSetTargetId = t.optional(t.number),
	gameSetTypeId = t.optional(t.string),
	tis = t.optional(t.number),
	refId = t.optional(t.string),
	src = t.optional(t.string),
	friendId = t.optional(t.string),
	position = t.optional(t.number),
	absolutePosition = t.optional(t.number),
	fromWhere = t.optional(t.string),
	locale = t.optional(t.string),
	conversationId = t.optional(t.number),
	shareLinkType = if not FFlagEnableShareLinksInGameDetailEvent then nil else t.optional(t.string),
	shareLinkId = if not FFlagEnableShareLinksInGameDetailEvent then nil else t.optional(t.string),
	rowOnPage = t.optional(t.number),
	appliedFilters = t.optional(t.string),
	topicDataPosition = t.optional(t.number),
	refSongId = if not FFlagEnableTopSongsSort then nil else t.optional(t.string),
	isSdui = t.optional(t.boolean),
	contentType = t.optional(t.string),
	actionType = t.optional(t.string),
	interactionUuid = t.optional(t.string),
	positionInRow = t.optional(t.number),
	rowNumber = t.optional(t.number),
	heroUnitId = t.optional(t.string),
	loadSource = t.optional(t.string),
	tileType = t.optional(t.string),
	sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else t.optional(t.string),
	analyticsData = t.optional(t.table),
	seeAllFlag = if not FFlagLuaAppAddSeeAllFlagToGameDetailReferral then nil else t.optional(t.number)
})

local function addMobileAdvertisingIdToEventParams(p1) -- line: 95
	-- upvalues: AppStorageService (copy)
	local Item = AppStorageService:GetItem("MobileAdvertisingId")

	if Item and Item ~= "" then
		p1.mobileAdvertisingId = Item
	end
end

return function(p2, s1: string, p3) -- line: 102
	-- upvalues: v21 (copy), DiscoveryEventErrorLogger (copy), HttpService (copy), FFlagLuaAppGameDetailEventMobileAdsId (copy), AppStorageService (copy), Cryo (copy), FFlagLuaAppMigrateGameEventsTelemetryService (copy), TelemetryService (copy), t1 (ref), FFlagLuaAppGameItemTelemetryServiceTarget (copy), getPlatformTarget (copy), FFlagLuaAppGameEventsTelemetryServiceShadowTraffic (copy), t2 (ref)
	local v28, v29 = v21(p3)

	if not v28 then
		DiscoveryEventErrorLogger.reportError("GameDetailReferralInvalidInterface", v29)
	end

	if not p3.interactionUuid then
		p3.interactionUuid = HttpService:GenerateGUID(false)
	end

	if not p3.contentType then
		p3.contentType = "Game"
	end

	if not p3.actionType then
		p3.actionType = "OpenGameDetails"
	end

	if FFlagLuaAppGameDetailEventMobileAdsId then
		local Item = AppStorageService:GetItem("MobileAdvertisingId")

		if Item and Item ~= "" then
			p3.mobileAdvertisingId = Item
		end
	end

	if p3.analyticsData then
		local analyticsData = p3.analyticsData

		p3 = Cryo.Dictionary.join(analyticsData, p3, {
			analyticsData = Cryo.None
		})
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		p3.isSdui = if p3.isSdui ~= true then if p3.isSdui ~= false then nil else "false" else "true"
		p3.isAd = if p3.isAd ~= true then if p3.isAd ~= false then nil else "false" else "true"
		TelemetryService:LogEvent(t1, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = p3,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	else
		p2:sendEventDeferred(s1, "gameDetailReferral", p3)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		local v32 = table.clone(p3)

		v32.isSdui = if v32.isSdui ~= true then if v32.isSdui ~= false then v32.isSdui else "false" else "true"
		v32.isAd = if v32.isAd ~= true then if v32.isAd ~= false then v32.isAd else "false" else "true"
		TelemetryService:LogEvent(t2, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = v32,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	end
end
