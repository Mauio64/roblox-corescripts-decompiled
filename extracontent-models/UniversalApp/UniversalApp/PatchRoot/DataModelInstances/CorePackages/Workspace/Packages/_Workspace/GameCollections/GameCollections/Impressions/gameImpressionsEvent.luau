local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("GameCollections").Parent
local Cryo = require(Parent.Cryo)
local getPlatformTarget = require(Parent.Analytics).getPlatformTarget
local t = require(Parent.t)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local ContentType = require(Parent.UnifiedLogging).ContentType
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagLuaAppGameImpressionsMobileAdsId = require(Parent.SharedFlags).FFlagLuaAppGameImpressionsMobileAdsId
local FFlagEnableInGameExitModalNextUpUi = require(Parent.SharedFlags).FFlagEnableInGameExitModalNextUpUi
local FFlagTraversalHistoryDiscoveryTelemetry = require(Parent.SharedFlags).FFlagTraversalHistoryDiscoveryTelemetry
local FFlagLuaAppTileBadgeAnalyticsFix = require(Parent.SharedFlags).FFlagLuaAppTileBadgeAnalyticsFix
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppMigrateGameEventsTelemetryService = require(Parent.SharedFlags).FFlagLuaAppMigrateGameEventsTelemetryService
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require(Parent.SharedFlags).FFlagLuaAppGameEventsTelemetryServiceShadowTraffic
local v19 = game:DefineFastInt("LuaAppGameImpressionsEventThrottlingHundredthsPercent", 10000)
local v20 = game:DefineFastInt("LuaAppGameImpressionsShadowThrottlingHundredthsPercent", 10000)
local v21 = game:DefineFastFlag("LuaAppFixRecommendedImpressionsInterface", false)
local FFlagLuaAppGameImpressionsAddUnifiedFields = require(Parent.SharedFlags).FFlagLuaAppGameImpressionsAddUnifiedFields
local FFlagLuaAppGameItemTelemetryServiceTarget = require(Parent.SharedFlags).FFlagLuaAppGameItemTelemetryServiceTarget
local FFlagLuaAppSduiLandingPageEnabled = require(Parent.SharedFlags).FFlagLuaAppSduiLandingPageEnabled
local t1 = nil

if FFlagLuaAppMigrateGameEventsTelemetryService then
	t1 = {
		eventName = "gameImpressions",
		description = "Fires when game tiles become visible to the user",
		backends = { "EventIngest" },
		throttlingPercentage = v19,
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
		eventName = "gameImpressionsShadow",
		description = "Shadow traffic for gameImpressions event recovery percentage",
		backends = { "EventIngest" },
		throttlingPercentage = v20,
		lastUpdated = {
			26,
			3,
			4
		}
	}
end

local v27 = t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	gameSetTypeId = t.string,
	sortPos = t.number,
	locale = t.string,
	thumbnailAssetIds = t.optional(t.string),
	thumbnailListIds = t.optional(t.string),
	videoThumbnailAssetIds = t.optional(t.string),
	componentType = t.optional(t.string),
	gameSetTargetId = t.optional(t.number),
	pageId = t.optional(t.string),
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	rows = t.optional(t.string),
	rowsOnPage = t.optional(t.string),
	positionsInRows = t.optional(t.string),
	tileBadgeContexts = t.optional(t.string),
	appliedFilters = t.optional(t.string),
	mobileAdvertisingId = if not FFlagLuaAppGameImpressionsMobileAdsId then nil else t.optional(t.string),
	footerTextLiterals = t.optional(t.string),
	footerLocalizationKeys = t.optional(t.string),
	loadSource = t.optional(t.string),
	tileTypes = t.optional(t.string),
	sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else t.optional(t.string),
	analyticsData = t.optional(t.table),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v28 = t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	gameSetTypeId = t.string,
	locale = t.string,
	seeAllFlag = t.number,
	gameSetTargetId = t.optional(t.number),
	pageId = t.optional(t.string),
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	thumbnailAssetIds = t.optional(t.string),
	thumbnailListIds = t.optional(t.string),
	videoThumbnailAssetIds = t.optional(t.string),
	tileBadgeContexts = t.optional(t.string),
	mobileAdvertisingId = if not FFlagLuaAppGameImpressionsMobileAdsId then nil else t.optional(t.string),
	appliedFilters = t.optional(t.string),
	footerTextLiterals = t.optional(t.string),
	footerLocalizationKeys = t.optional(t.string),
	tileTypes = t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v29 = t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	searchUuid = t.string,
	emphasisFlag = t.number,
	seeAllFlag = t.number,
	sortPos = t.optional(t.number),
	gameSetTypeId = t.optional(t.string),
	locale = t.optional(t.string),
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	rows = t.optional(t.string),
	rowsOnPage = t.optional(t.string),
	positionsInRows = t.optional(t.string),
	mobileAdvertisingId = if not FFlagLuaAppGameImpressionsMobileAdsId then nil else t.optional(t.string),
	thumbnailAssetIds = t.optional(t.string),
	thumbnailListIds = t.optional(t.string),
	footerTextLiterals = t.optional(t.string),
	footerLocalizationKeys = t.optional(t.string),
	tileBadgeContexts = t.optional(t.string),
	componentType = if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else t.optional(t.string),
	tileTypes = t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v30 = t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	refId = t.string,
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	locale = t.optional(t.string),
	tileBadgeContexts = if not FFlagLuaAppTileBadgeAnalyticsFix then nil else t.optional(t.string),
	mobileAdvertisingId = if not FFlagLuaAppGameImpressionsMobileAdsId then nil else t.optional(t.string),
	tileTypes = if not v21 then nil else t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v31 = if not FFlagSearchOmniAutocompletePage then nil else t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	sortPos = t.number,
	gameSetTypeId = t.optional(t.string),
	locale = t.optional(t.string),
	thumbnailAssetIds = t.optional(t.string),
	videoThumbnailAssetIds = t.optional(t.string),
	componentType = t.optional(t.string),
	rowsOnPage = t.optional(t.string),
	positionsInRows = t.optional(t.string),
	mobileAdvertisingId = if not FFlagLuaAppGameImpressionsMobileAdsId then nil else t.optional(t.string),
	gameSetTargetId = t.optional(t.number),
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	tileBadgeContexts = t.optional(t.string),
	thumbnailListIds = t.optional(t.string),
	tileTypes = t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v32 = if not FFlagEnableInGameExitModalNextUpUi then nil else t.strictInterface({
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	gameSetTypeId = t.string,
	locale = t.optional(t.string),
	tileBadgeContexts = if not FFlagLuaAppTileBadgeAnalyticsFix then nil else t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local v33 = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else t.strictInterface({
	absPositions = t.string,
	positionsInRows = t.optional(t.string),
	rootPlaceIds = t.string,
	rows = t.string,
	rowsOnPage = t.string,
	topicDataPositions = t.string,
	universeIds = t.string,
	locale = t.optional(t.string),
	tileBadgeContexts = if not FFlagLuaAppTileBadgeAnalyticsFix then nil else t.optional(t.string),
	contentType = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	interactionUuid = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.string),
	hasSponsoredContent = if not FFlagLuaAppGameImpressionsAddUnifiedFields then nil else t.optional(t.boolean)
})
local t3 = {
	[AppPage.Home] = v27,
	[AppPage.Games] = v27,
	[AppPage.SduiLandingPage] = if not FFlagLuaAppSduiLandingPageEnabled then nil else v27,
	[AppPage.SearchPage] = v29,
	[AppPage.SearchLandingPage] = if not FFlagSearchOmniAutocompletePage then nil else v31,
	recommended = v30,
	Deeplink = v28,
	InExpHistoryPage = v33,
	InGameExitPage = if not FFlagEnableInGameExitModalNextUpUi then nil else v32
}

return function(p1, p2, p3) -- line: 250
	-- upvalues: AppPage (copy), v28 (copy), t3 (copy), DiscoveryEventErrorLogger (copy), FFlagLuaAppGameImpressionsAddUnifiedFields (copy), Cryo (copy), HttpService (copy), ContentType (copy), FFlagLuaAppMigrateGameEventsTelemetryService (copy), TelemetryService (copy), t1 (ref), FFlagLuaAppGameItemTelemetryServiceTarget (copy), getPlatformTarget (copy), FFlagLuaAppGameEventsTelemetryServiceShadowTraffic (copy), t2 (ref)
	local v38 = if not p3.seeAllFlag or p2 ~= AppPage.Home and p2 ~= AppPage.Games then t3[p2] else v28

	if v38 then
		local v39, v40 = v38(p3)

		if not v39 then
			DiscoveryEventErrorLogger.reportError("GameImpressionsEventInvalidInterface", v40)
		end
	else
		DiscoveryEventErrorLogger.reportError("GameImpressionsEventMissingInterface", `Missing interface for eventContext { p2 } to type check gameImpressions event parameters`, {
			eventContext = p2
		})
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		p3 = Cryo.Dictionary.join({
			interactionUuid = HttpService:GenerateGUID(false),
			contentType = ContentType.Game
		}, p3)
	end

	if p3.analyticsData then
		local analyticsData = p3.analyticsData

		p3 = Cryo.Dictionary.join(analyticsData, p3, {
			analyticsData = Cryo.None
		})
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		TelemetryService:LogEvent(t1, {
			eventContext = p2,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = p3,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	else
		p1:sendEventDeferred(p2, "gameImpressions", p3)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		TelemetryService:LogEvent(t2, {
			eventContext = p2,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = p3,
			legacyOverrideTargetForEventIngest = if not FFlagLuaAppGameItemTelemetryServiceTarget then nil else getPlatformTarget()
		})
	end
end
