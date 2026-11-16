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
local FFlagLuaAppUnifiedLoggingDialogContentType = require(script.Parent.FFlagLuaAppUnifiedLoggingDialogContentType)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppMigrateItemEventsTelemetryService = SharedFlags2.FFlagLuaAppMigrateItemEventsTelemetryService

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppItemEventsTelemetryServiceShadowTraffic = SharedFlags3.FFlagLuaAppItemEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppItemActionEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppItemActionShadowThrottlingHundredthsPercent", 10000)

local v = FFlagLuaAppMigrateItemEventsTelemetryService and {
	eventName = "itemAction",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires for default user actions, primarily through SDUI"
} or nil

local v2 = FFlagLuaAppItemEventsTelemetryServiceShadowTraffic and {
	eventName = "itemActionShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for itemAction event recovery percentage"
} or nil

local union = t.union
local interface = t.interface
local collectionId

if FFlagLuaAppLoosenCollectionIdTypeInterface then
	collectionId = t.union(t.string, t.number)
else
	collectionId = t.number
end

local v3 = interface({ collectionId = collectionId, collectionIdStr = t.optional(t.string) })

local interface2 = t.interface
local optional = t.optional
local v4

if FFlagLuaAppLoosenCollectionIdTypeInterface then
	v4 = t.union(t.string, t.number)
else
	v4 = t.number
end

local v5 = union(v3, interface2({ collectionId = optional(v4), collectionIdStr = t.string }))

local v6 = {
	collectionPosition = t.number,
	totalNumberOfItems = t.number,
	contentType = t.string,
	itemId = t.optional(t.string),
	itemPosition = t.optional(t.number),
	positionInRow = t.optional(t.number),
	rowNumber = t.optional(t.number),
	feedRowNumber = t.optional(t.number),
	positionInTopic = t.optional(t.number),
	actionType = t.string,
	interactionUuid = t.optional(t.string)
}

local intersection = t.intersection(v5, t.interface(v6))
local intersection2 = t.intersection(v5, t.interface(Cryo.Dictionary.join(v6, {
	itemId = t.string,
	itemPosition = t.number,
	sourceCarousel = t.string,
	friendStatus = t.string,
	presence = t.string,
	presenceUniverseId = t.string
})))
local v7

if FFlagLuaAppUnifiedLoggingDialogContentType then
	v7 = t.interface({
		contentType = t.string,
		actionType = t.string,
		interactionUuid = t.optional(t.string)
	})
end

local v8 = { [ContentType.User] = intersection2 }

if FFlagLuaAppUnifiedLoggingDialogContentType then
	v8[ContentType.Dialog] = v7
end

return function(object, eventContext: string, p: string, customFields)
	local v9 = v8[p] or intersection

	if v9 then
		local v10, v11 = v9(customFields)

		if not v10 then
			DiscoveryEventErrorLogger.reportError("ItemActionEventInvalidInterface", v11)
		end
	end

	if not customFields.interactionUuid then
		customFields.interactionUuid = HttpService:GenerateGUID(false)
	end

	if FFlagLuaAppMigrateItemEventsTelemetryService then
		for k, v10 in customFields do
			if type(v10) == "boolean" then
				customFields[k] = v10 == true and "true" or v10 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(eventContext, "itemAction", customFields)
	end

	if FFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(customFields)

		for k, v10 in clone do
			if type(v10) == "boolean" then
				clone[k] = v10 == true and "true" or v10 == false and "false" or nil
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
