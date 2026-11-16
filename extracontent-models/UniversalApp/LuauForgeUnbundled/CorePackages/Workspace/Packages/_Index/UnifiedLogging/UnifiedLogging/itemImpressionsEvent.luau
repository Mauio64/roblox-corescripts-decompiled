local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Cryo")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local ContentType = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/ContentType")

local fFlagLuaAppLoosenCollectionIdTypeInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppLoosenCollectionIdTypeInterface
local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagProfilePlatformEnableImpressions
local fFlagItemImpressionsAddGameMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagItemImpressionsAddGameMetadata
local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagEnableTopSongsSort

local fFlagLuaAppMigrateItemEventsTelemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppMigrateItemEventsTelemetryService

local fFlagLuaAppItemEventsTelemetryServiceShadowTraffic = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppItemEventsTelemetryServiceShadowTraffic
local FFlagLuaAppItemImpressionsInteractionUuid = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/FFlagLuaAppItemImpressionsInteractionUuid")

local defineFastInt = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppItemImpressionsShadowThrottlingHundredthsPercent", 10000)

local v5 = fFlagLuaAppMigrateItemEventsTelemetryService and {
	eventName = "itemImpressions",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when items become visible to the user, primarily through SDUI"
} or nil

local v6 = fFlagLuaAppItemEventsTelemetryServiceShadowTraffic and {
	eventName = "itemImpressionsShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for itemImpressions event recovery percentage"
} or nil

local v7 = nil

local union = t.union
local interface = t.interface
local v9 = if fFlagLuaAppLoosenCollectionIdTypeInterface then t.union(t.string, t.number) else t.number
local v10 = interface({
	collectionId = v9,
	collectionIdStr = t.optional(t.string)
})

local interface2 = t.interface
local optional = t.optional
local v12

if fFlagLuaAppLoosenCollectionIdTypeInterface then
	v12 = t.union(t.string, t.number)
else
	v12 = t.number
end

local v13 = union(v10, interface2({
	collectionId = optional(v12),
	collectionIdStr = t.string
}))

local v14 = {
	collectionPosition = t.number,
	totalNumberOfItems = t.number,
	contentType = t.string,
	interactionUuid = 0,
	itemIds = 0,
	itemPositions = 0,
	rowNumbers = 0,
	feedRowNumbers = 0,
	positionsInRow = 0,
	positionsInTopic = 0
}
local v15 = if FFlagLuaAppItemImpressionsInteractionUuid then t.optional(t.string) else nil
v14.interactionUuid = v15

v14.itemIds = t.string
v14.itemPositions = t.string
v14.rowNumbers = t.optional(t.string)
v14.feedRowNumbers = t.optional(t.string)
v14.positionsInRow = t.optional(t.string)
v14.positionsInTopic = t.optional(t.string)

local intersection = t.intersection(v13, t.interface(v14))
local intersection2 = t.intersection(
	v13,
	t.interface(Cryo.Dictionary.join(v14, {
		sourceCarousel = t.string,
		friendStatuses = t.string,
		presences = t.string,
		presenceUniverseIds = t.string
	}))
)

if fFlagItemImpressionsAddGameMetadata then
	v7 = t.intersection(
		v13,
		t.interface(Cryo.Dictionary.join(v14, {
			universeId_arr = t.string,
			placeId_arr = t.string
		}))
	)
end

local v16 = { [ContentType.User] = intersection2 }
local Game = ContentType.Game

if not (fFlagItemImpressionsAddGameMetadata and fFlagProfilePlatformEnableImpressions) then
	v7 = if fFlagProfilePlatformEnableImpressions then intersection else nil
end

v16[Game] = v7

local song = ContentType.Song
v16[song] = if fFlagEnableTopSongsSort then intersection else nil
v16[ContentType.Badge] = intersection

return function(object, p2, p3, p4)
	if FFlagLuaAppItemImpressionsInteractionUuid and not p4.interactionUuid then
		p4.interactionUuid = HttpService:GenerateGUID(false)
	end

	local v18 = v16[p3] or intersection

	if v18 then
		local v19, v20 = v18(p4)

		if not v19 then
			discoveryEventErrorLogger.reportError("ItemImpressionsEventInvalidInterface", v20)
		end
	end

	if fFlagLuaAppMigrateItemEventsTelemetryService then
		for k, v19 in p4 do
			if type(v19) == "boolean" then
				p4[k] = v19 == true and "true" or v19 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = p4,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(p2, "itemImpressions", p4)
	end

	if fFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(p4)

		for k, v19 in clone do
			if type(v19) == "boolean" then
				clone[k] = v19 == true and "true" or v19 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v6, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = clone,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
