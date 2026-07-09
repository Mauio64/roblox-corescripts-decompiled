local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local UnifiedLoggingParent = UnifiedLogging.Parent
local Cryo = require(UnifiedLoggingParent.Cryo)
local getPlatformTarget = require(UnifiedLoggingParent.Analytics).getPlatformTarget
local t = require(UnifiedLoggingParent.t)
local DiscoveryEventErrorLogger = require(UnifiedLoggingParent.DiscoveryUtils).DiscoveryEventErrorLogger
local ContentType = require(UnifiedLogging.ContentType)
local FFlagLuaAppLoosenCollectionIdTypeInterface = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppLoosenCollectionIdTypeInterface
local FFlagLuaAppUnifiedLoggingDialogContentType = require(script.Parent.FFlagLuaAppUnifiedLoggingDialogContentType)
local FFlagLuaAppMigrateItemEventsTelemetryService = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppMigrateItemEventsTelemetryService
local FFlagLuaAppItemEventsTelemetryServiceShadowTraffic = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppItemEventsTelemetryServiceShadowTraffic
local FFlagLuaAppGameItemTelemetryServiceTarget = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppGameItemTelemetryServiceTarget
local v15 = game:DefineFastInt("LuaAppItemActionEventThrottlingHundredthsPercent", 10000)
local v16 = game:DefineFastInt("LuaAppItemActionShadowThrottlingHundredthsPercent", 10000)
local t1 = nil

if FFlagLuaAppMigrateItemEventsTelemetryService then
	t1 = {
		eventName = "itemAction",
		description = "Fires for default user actions, primarily through SDUI",
		backends = { "EventIngest" },
		throttlingPercentage = v15,
		lastUpdated = {
			26,
			2,
			4
		}
	}
end

local t2 = nil

if FFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
	t2 = {
		eventName = "itemActionShadow",
		description = "Shadow traffic for itemAction event recovery percentage",
		backends = { "EventIngest" },
		throttlingPercentage = v16,
		lastUpdated = {
			26,
			3,
			4
		}
	}
end

local v19 = t.union(t.interface({
	collectionId = if not FFlagLuaAppLoosenCollectionIdTypeInterface then t.number else t.union(t.string, t.number),
	collectionIdStr = t.optional(t.string)
}), t.interface({
	collectionId = t.optional(if not FFlagLuaAppLoosenCollectionIdTypeInterface then t.number else t.union(t.string, t.number)),
	collectionIdStr = t.string
}))
local t3 = {
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
local u21 = t.intersection(v19, t.interface(t3))
local v22 = t.intersection(v19, t.interface(Cryo.Dictionary.join(t3, {
	itemId = t.string,
	itemPosition = t.number,
	sourceCarousel = t.string,
	friendStatus = t.string,
	presence = t.string,
	presenceUniverseId = t.string
})))
local v23 = if not FFlagLuaAppUnifiedLoggingDialogContentType then nil else t.interface({
	contentType = t.string,
	actionType = t.string,
	interactionUuid = t.optional(t.string)
})
local t4 = {
	[ContentType.User] = v22
}

if FFlagLuaAppUnifiedLoggingDialogContentType then
	t4[ContentType.Dialog] = v23
end

return function(p1, s1: string, s2: string, t5: {[any]: any}) -- line: 117
	-- upvalues: t4 (copy), u21 (ref), DiscoveryEventErrorLogger (copy), HttpService (copy), FFlagLuaAppMigrateItemEventsTelemetryService (copy), TelemetryService (copy), t1 (ref), FFlagLuaAppGameItemTelemetryServiceTarget (copy), getPlatformTarget (copy), FFlagLuaAppItemEventsTelemetryServiceShadowTraffic (copy), t2 (ref)
	local v29 = t4[s2] or u21

	if v29 then
		local v30, v31 = v29(t5)

		if not v30 then
			DiscoveryEventErrorLogger.reportError("ItemActionEventInvalidInterface", v31)
		end
	end

	if not t5.interactionUuid then
		t5.interactionUuid = HttpService:GenerateGUID(false)
	end

	if FFlagLuaAppMigrateItemEventsTelemetryService then
		for v32, v33 in t5 do
			if type(v33) == "boolean" then
				t5[v32] = if v33 ~= true then if v33 ~= false then nil else "false" else "true"
			end
		end

		TelemetryService:LogEvent(t1, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = t5,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	else
		p1:sendEventDeferred(s1, "itemAction", t5)
	end

	if FFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local v34 = table.clone(t5)

		for v35, v36 in v34 do
			if type(v36) == "boolean" then
				v34[v35] = if v36 ~= true then if v36 ~= false then nil else "false" else "true"
			end
		end

		TelemetryService:LogEvent(t2, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = v34,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	end
end
