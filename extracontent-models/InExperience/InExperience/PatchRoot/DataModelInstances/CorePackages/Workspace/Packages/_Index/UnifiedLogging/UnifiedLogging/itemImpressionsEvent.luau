local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local parent = UnifiedLogging.Parent

local Cryo = require(parent.Cryo)
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local ContentType = require(UnifiedLogging.ContentType)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLoosenCollectionIdTypeInterface = SharedFlags.FFlagLuaAppLoosenCollectionIdTypeInterface
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags2.FFlagProfilePlatformEnableImpressions
local SharedFlags3 = require(parent.SharedFlags)
local FFlagItemImpressionsAddGameMetadata = SharedFlags3.FFlagItemImpressionsAddGameMetadata
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags4.FFlagEnableTopSongsSort

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppMigrateItemEventsTelemetryService = SharedFlags5.FFlagLuaAppMigrateItemEventsTelemetryService

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppItemEventsTelemetryServiceShadowTraffic = SharedFlags6.FFlagLuaAppItemEventsTelemetryServiceShadowTraffic
local FFlagLuaAppItemImpressionsInteractionUuid = require(script.Parent.FFlagLuaAppItemImpressionsInteractionUuid)

local defineFastInt = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppItemImpressionsShadowThrottlingHundredthsPercent", 10000)

local v = FFlagLuaAppMigrateItemEventsTelemetryService and {
	eventName = "itemImpressions",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when items become visible to the user, primarily through SDUI"
} or nil

local v2 = FFlagLuaAppItemEventsTelemetryServiceShadowTraffic and {
	eventName = "itemImpressionsShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for itemImpressions event recovery percentage"
} or nil

local v3 = nil

local union = t.union
local interface = t.interface
local collectionId

if FFlagLuaAppLoosenCollectionIdTypeInterface then
	collectionId = t.union(t.string, t.number)
else
	collectionId = t.number
end

local v4 = interface({ collectionId = collectionId, collectionIdStr = t.optional(t.string) })

local interface2 = t.interface
local optional = t.optional
local v5

if FFlagLuaAppLoosenCollectionIdTypeInterface then
	v5 = t.union(t.string, t.number)
else
	v5 = t.number
end

local v6 = union(v4, interface2({ collectionId = optional(v5), collectionIdStr = t.string }))

local v7 = {
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
local interactionUuid

if FFlagLuaAppItemImpressionsInteractionUuid then
	interactionUuid = t.optional(t.string)
end

v7.interactionUuid = interactionUuid

v7.itemIds = t.string
v7.itemPositions = t.string
v7.rowNumbers = t.optional(t.string)
v7.feedRowNumbers = t.optional(t.string)
v7.positionsInRow = t.optional(t.string)
v7.positionsInTopic = t.optional(t.string)

local intersection = t.intersection(v6, t.interface(v7))
local intersection2 = t.intersection(
	v6,
	t.interface(Cryo.Dictionary.join(v7, {
		sourceCarousel = t.string,
		friendStatuses = t.string,
		presences = t.string,
		presenceUniverseIds = t.string
	}))
)

if FFlagItemImpressionsAddGameMetadata then
	v3 = t.intersection(
		v6,
		t.interface(Cryo.Dictionary.join(v7, { universeId_arr = t.string, placeId_arr = t.string }))
	)
end

local v8 = { [ContentType.User] = intersection2 }
local Game = ContentType.Game

if not (FFlagItemImpressionsAddGameMetadata and FFlagProfilePlatformEnableImpressions) then
	if FFlagProfilePlatformEnableImpressions then
		v3 = intersection
	else
		v3 = nil
	end
end

v8[Game] = v3

local Song = ContentType.Song
local v9

if FFlagEnableTopSongsSort then
	v9 = intersection
end

v8[Song] = v9
v8[ContentType.Badge] = intersection

return function(object, eventContext: string, p: string, customFields)
	if FFlagLuaAppItemImpressionsInteractionUuid and not customFields.interactionUuid then
		customFields.interactionUuid = HttpService:GenerateGUID(false)
	end

	local v10 = v8[p] or intersection

	if v10 then
		local v11, v12 = v10(customFields)

		if not v11 then
			DiscoveryEventErrorLogger.reportError("ItemImpressionsEventInvalidInterface", v12)
		end
	end

	if FFlagLuaAppMigrateItemEventsTelemetryService then
		for k, v11 in customFields do
			if type(v11) == "boolean" then
				customFields[k] = v11 == true and "true" or v11 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(eventContext, "itemImpressions", customFields)
	end

	if FFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(customFields)

		for k, v11 in clone do
			if type(v11) == "boolean" then
				clone[k] = v11 == true and "true" or v11 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v2, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = clone,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
