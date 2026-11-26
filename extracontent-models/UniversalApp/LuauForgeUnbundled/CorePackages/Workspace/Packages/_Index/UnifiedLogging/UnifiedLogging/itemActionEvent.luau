local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Cryo")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local ContentType = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/ContentType")

local fFlagLuaAppLoosenCollectionIdTypeInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppLoosenCollectionIdTypeInterface
local FFlagLuaAppUnifiedLoggingDialogContentType = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/FFlagLuaAppUnifiedLoggingDialogContentType")

local fFlagLuaAppMigrateItemEventsTelemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppMigrateItemEventsTelemetryService

local fFlagLuaAppItemEventsTelemetryServiceShadowTraffic = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagLuaAppItemEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppItemActionEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppItemActionShadowThrottlingHundredthsPercent", 10000)

local v5 = fFlagLuaAppMigrateItemEventsTelemetryService and {
	eventName = "itemAction",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires for default user actions, primarily through SDUI"
} or nil

local v6 = fFlagLuaAppItemEventsTelemetryServiceShadowTraffic and {
	eventName = "itemActionShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for itemAction event recovery percentage"
} or nil

local union = t.union
local interface = t.interface
local v8 = if fFlagLuaAppLoosenCollectionIdTypeInterface then t.union(t.string, t.number) else t.number
local v9 = interface({
	collectionId = v8,
	collectionIdStr = t.optional(t.string)
})

local interface2 = t.interface
local optional = t.optional
local v11

if fFlagLuaAppLoosenCollectionIdTypeInterface then
	v11 = t.union(t.string, t.number)
else
	v11 = t.number
end

local v12 = union(v9, interface2({
	collectionId = optional(v11),
	collectionIdStr = t.string
}))

local v13 = {
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

local intersection = t.intersection(v12, t.interface(v13))
local intersection2 = t.intersection(v12, t.interface(Cryo.Dictionary.join(v13, {
	itemId = t.string,
	itemPosition = t.number,
	sourceCarousel = t.string,
	friendStatus = t.string,
	presence = t.string,
	presenceUniverseId = t.string
})))
local v14

if FFlagLuaAppUnifiedLoggingDialogContentType then
	v14 = t.interface({
		contentType = t.string,
		actionType = t.string,
		interactionUuid = t.optional(t.string)
	})
end

local v15 = { [ContentType.User] = intersection2 }

if FFlagLuaAppUnifiedLoggingDialogContentType then
	v15[ContentType.Dialog] = v14
end

return function(object, p2, p3, p4)
	local v16 = v15[p3] or intersection

	if v16 then
		local v17, v18 = v16(p4)

		if not v17 then
			discoveryEventErrorLogger.reportError("ItemActionEventInvalidInterface", v18)
		end
	end

	if not p4.interactionUuid then
		p4.interactionUuid = HttpService:GenerateGUID(false)
	end

	if fFlagLuaAppMigrateItemEventsTelemetryService then
		for k, v17 in p4 do
			if type(v17) == "boolean" then
				p4[k] = v17 == true and "true" or v17 == false and "false" or nil
			end
		end

		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = p4,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(p2, "itemAction", p4)
	end

	if fFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local clone = table.clone(p4)

		for k, v17 in clone do
			if type(v17) == "boolean" then
				clone[k] = v17 == true and "true" or v17 == false and "false" or nil
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
