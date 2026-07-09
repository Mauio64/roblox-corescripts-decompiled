local TelemetryService = game:GetService("TelemetryService")
local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local UnifiedLoggingParent = UnifiedLogging.Parent
local Cryo = require(UnifiedLoggingParent.Cryo)
local getPlatformTarget = require(UnifiedLoggingParent.Analytics).getPlatformTarget
local t = require(UnifiedLoggingParent.t)
local DiscoveryEventErrorLogger = require(UnifiedLoggingParent.DiscoveryUtils).DiscoveryEventErrorLogger
local ContentType = require(UnifiedLogging.ContentType)
local FFlagLuaAppLoosenCollectionIdTypeInterface = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppLoosenCollectionIdTypeInterface
local FFlagProfilePlatformEnableImpressions = require(UnifiedLoggingParent.SharedFlags).FFlagProfilePlatformEnableImpressions
local FFlagItemImpressionsAddGameMetadata = require(UnifiedLoggingParent.SharedFlags).FFlagItemImpressionsAddGameMetadata
local FFlagEnableTopSongsSort = require(UnifiedLoggingParent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppMigrateItemEventsTelemetryService = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppMigrateItemEventsTelemetryService
local FFlagLuaAppItemEventsTelemetryServiceShadowTraffic = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppItemEventsTelemetryServiceShadowTraffic
local FFlagLuaAppGameItemTelemetryServiceTarget = require(UnifiedLoggingParent.SharedFlags).FFlagLuaAppGameItemTelemetryServiceTarget
local v16 = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)
local v17 = game:DefineFastInt("LuaAppItemImpressionsShadowThrottlingHundredthsPercent", 10000)
local t1 = nil

if FFlagLuaAppMigrateItemEventsTelemetryService then
	t1 = {
		eventName = "itemImpressions",
		description = "Fires when items become visible to the user, primarily through SDUI",
		backends = { "EventIngest" },
		throttlingPercentage = v16,
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
		eventName = "itemImpressionsShadow",
		description = "Shadow traffic for itemImpressions event recovery percentage",
		backends = { "EventIngest" },
		throttlingPercentage = v17,
		lastUpdated = {
			26,
			3,
			4
		}
	}
end

local v20 = nil
local v21 = t.union(t.interface({
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
	itemIds = t.string,
	itemPositions = t.string,
	rowNumbers = t.optional(t.string),
	feedRowNumbers = t.optional(t.string),
	positionsInRow = t.optional(t.string),
	positionsInTopic = t.optional(t.string)
}
local u23 = t.intersection(v21, t.interface(t3))
local v24 = t.intersection(v21, t.interface(Cryo.Dictionary.join(t3, {
	sourceCarousel = t.string,
	friendStatuses = t.string,
	presences = t.string,
	presenceUniverseIds = t.string
})))

if FFlagItemImpressionsAddGameMetadata then
	v20 = t.intersection(v21, t.interface(Cryo.Dictionary.join(t3, {
		universeId_arr = t.string,
		placeId_arr = t.string
	})))
end

local t4 = {
	[ContentType.User] = v24,
	[ContentType.Game] = if not FFlagItemImpressionsAddGameMetadata or not FFlagProfilePlatformEnableImpressions then if not FFlagProfilePlatformEnableImpressions then nil else u23 else v20,
	[ContentType.Song] = if not FFlagEnableTopSongsSort then nil else u23,
	[ContentType.Badge] = u23
}

return function(p1, s1: string, s2: string, t5: {[any]: any}) -- line: 119
	-- upvalues: t4 (copy), u23 (ref), DiscoveryEventErrorLogger (copy), FFlagLuaAppMigrateItemEventsTelemetryService (copy), TelemetryService (copy), t1 (ref), FFlagLuaAppGameItemTelemetryServiceTarget (copy), getPlatformTarget (copy), FFlagLuaAppItemEventsTelemetryServiceShadowTraffic (copy), t2 (ref)
	local v30 = t4[s2] or u23

	if v30 then
		local v31, v32 = v30(t5)

		if not v31 then
			DiscoveryEventErrorLogger.reportError("ItemImpressionsEventInvalidInterface", v32)
		end
	end

	if FFlagLuaAppMigrateItemEventsTelemetryService then
		for v33, v34 in t5 do
			if type(v34) == "boolean" then
				t5[v33] = if v34 ~= true then if v34 ~= false then nil else "false" else "true"
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
		p1:sendEventDeferred(s1, "itemImpressions", t5)
	end

	if FFlagLuaAppItemEventsTelemetryServiceShadowTraffic then
		local v35 = table.clone(t5)

		for v36, v37 in v35 do
			if type(v37) == "boolean" then
				v35[v36] = if v37 ~= true then if v37 ~= false then nil else "false" else "true"
			end
		end

		TelemetryService:LogEvent(t2, {
			eventContext = s1,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = v35,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	end
end
