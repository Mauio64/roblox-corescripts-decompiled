local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/t")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local contentType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UnifiedLogging").ContentType
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppGameImpressionsMobileAdsId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameImpressionsMobileAdsId
local fFlagTraversalHistoryDiscoveryTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagTraversalHistoryDiscoveryTelemetry

local fFlagLuaAppMigrateGameEventsTelemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppMigrateGameEventsTelemetryService

local fFlagLuaAppGameEventsTelemetryServiceShadowTraffic = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppGameImpressionsEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppGameImpressionsShadowThrottlingHundredthsPercent", 10000)

local fFlagLuaAppGameImpressionsAddUnifiedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameImpressionsAddUnifiedFields
local fFlagLuaAppSduiLandingPageEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSduiLandingPageEnabled

local fFlagLuaAppAddAnalyticsDataToSeeAllImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppAddAnalyticsDataToSeeAllImpressions
local fFlagSduiSearchResultsPageEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagSduiSearchResultsPageEnabled

local fFlagLuaAppSearchResultsPageGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSearchResultsPageGameTileVideo
local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local v5 = fFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gameImpressions",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when game tiles become visible to the user"
} or nil

local v6 = fFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
	eventName = "gameImpressionsShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for gameImpressions event recovery percentage"
} or nil

local strictInterface = t.strictInterface
local v7 = {
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
	videoIsMoment_arr = 0,
	componentType = 0,
	gameSetTargetId = 0,
	pageId = 0,
	adFlags = 0,
	adIds = 0,
	rows = 0,
	rowsOnPage = 0,
	positionsInRows = 0,
	tileBadgeContexts = 0,
	appliedFilters = 0,
	mobileAdvertisingId = 0,
	footerTextLiterals = 0,
	footerLocalizationKeys = 0,
	loadSource = 0,
	tileTypes = 0,
	sortSubId = 0,
	analyticsData = 0,
	contentType = 0,
	interactionUuid = 0,
	hasSponsoredContent = 0
}
local v8 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then t.optional(t.string) else nil
v7.videoIsMoment_arr = v8
v7.componentType = t.optional(t.string)
v7.gameSetTargetId = t.optional(t.number)
v7.pageId = t.optional(t.string)
v7.adFlags = t.optional(t.string)
v7.adIds = t.optional(t.string)
v7.rows = t.optional(t.string)
v7.rowsOnPage = t.optional(t.string)
v7.positionsInRows = t.optional(t.string)
v7.tileBadgeContexts = t.optional(t.string)
v7.appliedFilters = t.optional(t.string)
local v9 = if fFlagLuaAppGameImpressionsMobileAdsId then t.optional(t.string) else nil
v7.mobileAdvertisingId = v9
v7.footerTextLiterals = t.optional(t.string)
v7.footerLocalizationKeys = t.optional(t.string)
v7.loadSource = t.optional(t.string)
v7.tileTypes = t.optional(t.string)
v7.sortSubId = t.optional(t.string)
v7.analyticsData = t.optional(t.table)

local v10 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v7.contentType = v10
local v11 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v7.interactionUuid = v11
local v12 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
v7.hasSponsoredContent = v12
local v13 = strictInterface(v7)

local strictInterface2 = t.strictInterface
local v14 = {
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
	videoIsMoment_arr = 0,
	tileBadgeContexts = 0,
	mobileAdvertisingId = 0,
	appliedFilters = 0,
	footerTextLiterals = 0,
	footerLocalizationKeys = 0,
	tileTypes = 0,
	analyticsData = 0,
	contentType = 0,
	interactionUuid = 0,
	hasSponsoredContent = 0
}
local v15 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then t.optional(t.string) else nil
v14.videoIsMoment_arr = v15
v14.tileBadgeContexts = t.optional(t.string)
local v16 = if fFlagLuaAppGameImpressionsMobileAdsId then t.optional(t.string) else nil
v14.mobileAdvertisingId = v16
v14.appliedFilters = t.optional(t.string)
v14.footerTextLiterals = t.optional(t.string)
v14.footerLocalizationKeys = t.optional(t.string)
v14.tileTypes = t.optional(t.string)
local v17 = if fFlagLuaAppAddAnalyticsDataToSeeAllImpressions then t.optional(t.table) else nil
v14.analyticsData = v17

local v18 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v14.contentType = v18
local v19 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v14.interactionUuid = v19
local v20 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
v14.hasSponsoredContent = v20
local v21 = strictInterface2(v14)

local strictInterface3 = t.strictInterface
local v22 = {
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
	mobileAdvertisingId = 0,
	thumbnailAssetIds = 0,
	thumbnailListIds = 0,
	videoThumbnailAssetIds = 0,
	videoIsMoment_arr = 0,
	footerTextLiterals = 0,
	footerLocalizationKeys = 0,
	tileBadgeContexts = 0,
	componentType = 0,
	tileTypes = 0,
	analyticsData = 0,
	contentType = 0,
	interactionUuid = 0,
	hasSponsoredContent = 0
}
local v23 = if fFlagLuaAppGameImpressionsMobileAdsId then t.optional(t.string) else nil
v22.mobileAdvertisingId = v23
v22.thumbnailAssetIds = t.optional(t.string)
v22.thumbnailListIds = t.optional(t.string)
local v24 = if fFlagLuaAppSearchResultsPageGameTileVideo then t.optional(t.string) else nil
v22.videoThumbnailAssetIds = v24
local v25 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then t.optional(t.string) else nil
v22.videoIsMoment_arr = v25
v22.footerTextLiterals = t.optional(t.string)
v22.footerLocalizationKeys = t.optional(t.string)
v22.tileBadgeContexts = t.optional(t.string)
v22.componentType = t.optional(t.string)
v22.tileTypes = t.optional(t.string)
local v26 = if fFlagSduiSearchResultsPageEnabled then t.optional(t.table) else nil
v22.analyticsData = v26

local v27 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v22.contentType = v27
local v28 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v22.interactionUuid = v28
local v29 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
v22.hasSponsoredContent = v29
local v30 = strictInterface3(v22)

local strictInterface4 = t.strictInterface
local v31 = {
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	refId = t.string,
	adFlags = t.optional(t.string),
	adIds = t.optional(t.string),
	locale = t.optional(t.string),
	tileBadgeContexts = t.optional(t.string),
	mobileAdvertisingId = 0,
	tileTypes = 0,
	contentType = 0,
	interactionUuid = 0,
	hasSponsoredContent = 0
}
local v32 = if fFlagLuaAppGameImpressionsMobileAdsId then t.optional(t.string) else nil
v31.mobileAdvertisingId = v32
v31.tileTypes = t.optional(t.string)

local v33 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v31.contentType = v33
local v34 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v31.interactionUuid = v34
local v35 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
v31.hasSponsoredContent = v35
local v36 = strictInterface4(v31)

local strictInterface5 = t.strictInterface
local v37 = {
	absPositions = t.string,
	topicDataPositions = t.string,
	rootPlaceIds = t.string,
	universeIds = t.string,
	sortPos = t.number,
	gameSetTypeId = t.optional(t.string),
	locale = t.optional(t.string),
	thumbnailAssetIds = t.optional(t.string),
	videoThumbnailAssetIds = t.optional(t.string),
	videoIsMoment_arr = 0,
	componentType = 0,
	rowsOnPage = 0,
	positionsInRows = 0,
	mobileAdvertisingId = 0,
	gameSetTargetId = 0,
	adFlags = 0,
	adIds = 0,
	tileBadgeContexts = 0,
	thumbnailListIds = 0,
	tileTypes = 0,
	contentType = 0,
	interactionUuid = 0,
	hasSponsoredContent = 0
}
local v38 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then t.optional(t.string) else nil
v37.videoIsMoment_arr = v38
v37.componentType = t.optional(t.string)
v37.rowsOnPage = t.optional(t.string)
v37.positionsInRows = t.optional(t.string)
local v39 = if fFlagLuaAppGameImpressionsMobileAdsId then t.optional(t.string) else nil
v37.mobileAdvertisingId = v39

v37.gameSetTargetId = t.optional(t.number)
v37.adFlags = t.optional(t.string)
v37.adIds = t.optional(t.string)
v37.tileBadgeContexts = t.optional(t.string)
v37.thumbnailListIds = t.optional(t.string)
v37.tileTypes = t.optional(t.string)

local v40 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v37.contentType = v40
local v41 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
v37.interactionUuid = v41
local v42 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
v37.hasSponsoredContent = v42
local v43 = strictInterface5(v37)
local v44

if fFlagTraversalHistoryDiscoveryTelemetry then
	local strictInterface6 = t.strictInterface
	local v45 = {
		absPositions = t.string,
		positionsInRows = t.optional(t.string),
		rootPlaceIds = t.string,
		rows = t.string,
		rowsOnPage = t.string,
		topicDataPositions = t.string,
		universeIds = t.string,
		locale = t.optional(t.string),
		tileBadgeContexts = t.optional(t.string),
		contentType = 0,
		interactionUuid = 0,
		hasSponsoredContent = 0
	}

	local v46 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
	v45.contentType = v46
	local v47 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.string) else nil
	v45.interactionUuid = v47
	local v48 = if fFlagLuaAppGameImpressionsAddUnifiedFields then t.optional(t.boolean) else nil
	v45.hasSponsoredContent = v48
	v44 = strictInterface6(v45)
end

local v45 = { [appPage.Home] = v13, [appPage.Games] = v13 }
local sduiLandingPage = appPage.SduiLandingPage

if not fFlagLuaAppSduiLandingPageEnabled then
	v13 = nil
end

v45[sduiLandingPage] = v13

v45[appPage.SearchPage] = v30
v45[appPage.SearchLandingPage] = v43
v45.recommended = v36
v45.Deeplink = v21
v45.InExpHistoryPage = v44

return function(object, p2, p3)
	local v46 = if p3.seeAllFlag and (p2 == appPage.Home or p2 == appPage.Games) then v21 else v45[p2]

	if v46 then
		local v47, v48 = v46(p3)

		if not v47 then
			discoveryEventErrorLogger.reportError("GameImpressionsEventInvalidInterface", v48)
		end
	else
		discoveryEventErrorLogger.reportError(
			"GameImpressionsEventMissingInterface",
			`Missing interface for eventContext {p2} to type check gameImpressions event parameters`,
			{ eventContext = p2 }
		)
	end

	if fFlagLuaAppGameImpressionsAddUnifiedFields then
		p3 = Cryo.Dictionary.join(
			{
				interactionUuid = HttpService:GenerateGUID(false),
				contentType = contentType.Game
			},
			p3
		)
	end

	if p3.analyticsData then
		local analyticsData = p3.analyticsData
		p3 = Cryo.Dictionary.join(analyticsData, p3, { analyticsData = Cryo.None })
	end

	if fFlagLuaAppMigrateGameEventsTelemetryService then
		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = p3,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(p2, "gameImpressions", p3)
	end

	if fFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		TelemetryService:LogEvent(v6, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = p3,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
