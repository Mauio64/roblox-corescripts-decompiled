local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("GameCollections").Parent
local Cryo = require(parent.Cryo)
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local t = require(parent.t)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UnifiedLogging = require(parent.UnifiedLogging)
local ContentType = UnifiedLogging.ContentType
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGameImpressionsMobileAdsId = SharedFlags.FFlagLuaAppGameImpressionsMobileAdsId
local SharedFlags2 = require(parent.SharedFlags)
local FFlagTraversalHistoryDiscoveryTelemetry = SharedFlags2.FFlagTraversalHistoryDiscoveryTelemetry

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameEventsTelemetryService = SharedFlags3.FFlagLuaAppMigrateGameEventsTelemetryService

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = SharedFlags4.FFlagLuaAppGameEventsTelemetryServiceShadowTraffic

local defineFastInt = game:DefineFastInt("LuaAppGameImpressionsEventThrottlingHundredthsPercent", 10000)

local defineFastInt2 = game:DefineFastInt("LuaAppGameImpressionsShadowThrottlingHundredthsPercent", 10000)

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppGameImpressionsAddUnifiedFields = SharedFlags5.FFlagLuaAppGameImpressionsAddUnifiedFields
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSduiLandingPageEnabled = SharedFlags6.FFlagLuaAppSduiLandingPageEnabled

local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppAddAnalyticsDataToSeeAllImpressions = SharedFlags7.FFlagLuaAppAddAnalyticsDataToSeeAllImpressions
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiSearchResultsPageEnabled = SharedFlags8.FFlagSduiSearchResultsPageEnabled

local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppSearchResultsPageGameTileVideo = SharedFlags9.FFlagLuaAppSearchResultsPageGameTileVideo
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags10.FFlagLuaAppDiscoveryMomentVideoTelemetry

local v = FFlagLuaAppMigrateGameEventsTelemetryService and {
	eventName = "gameImpressions",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 2, 4 },
	description = "Fires when game tiles become visible to the user"
} or nil

local v2 = FFlagLuaAppGameEventsTelemetryServiceShadowTraffic and {
	eventName = "gameImpressionsShadow",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 26, 3, 4 },
	description = "Shadow traffic for gameImpressions event recovery percentage"
} or nil

local strictInterface = t.strictInterface
local v3 = {
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
local videoIsMoment_arr

if FFlagLuaAppDiscoveryMomentVideoTelemetry then
	videoIsMoment_arr = t.optional(t.string)
end

v3.videoIsMoment_arr = videoIsMoment_arr
v3.componentType = t.optional(t.string)
v3.gameSetTargetId = t.optional(t.number)
v3.pageId = t.optional(t.string)
v3.adFlags = t.optional(t.string)
v3.adIds = t.optional(t.string)
v3.rows = t.optional(t.string)
v3.rowsOnPage = t.optional(t.string)
v3.positionsInRows = t.optional(t.string)
v3.tileBadgeContexts = t.optional(t.string)
v3.appliedFilters = t.optional(t.string)
local mobileAdvertisingId

if FFlagLuaAppGameImpressionsMobileAdsId then
	mobileAdvertisingId = t.optional(t.string)
end

v3.mobileAdvertisingId = mobileAdvertisingId
v3.footerTextLiterals = t.optional(t.string)
v3.footerLocalizationKeys = t.optional(t.string)
v3.loadSource = t.optional(t.string)
v3.tileTypes = t.optional(t.string)
v3.sortSubId = t.optional(t.string)
v3.analyticsData = t.optional(t.table)
local contentType

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	contentType = t.optional(t.string)
end

v3.contentType = contentType
local interactionUuid

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	interactionUuid = t.optional(t.string)
end

v3.interactionUuid = interactionUuid
local hasSponsoredContent

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	hasSponsoredContent = t.optional(t.boolean)
end

v3.hasSponsoredContent = hasSponsoredContent
local v4 = strictInterface(v3)

local strictInterface2 = t.strictInterface
local v5 = {
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
local videoIsMoment_arr2

if FFlagLuaAppDiscoveryMomentVideoTelemetry then
	videoIsMoment_arr2 = t.optional(t.string)
end

v5.videoIsMoment_arr = videoIsMoment_arr2
v5.tileBadgeContexts = t.optional(t.string)
local mobileAdvertisingId2

if FFlagLuaAppGameImpressionsMobileAdsId then
	mobileAdvertisingId2 = t.optional(t.string)
end

v5.mobileAdvertisingId = mobileAdvertisingId2
v5.appliedFilters = t.optional(t.string)
v5.footerTextLiterals = t.optional(t.string)
v5.footerLocalizationKeys = t.optional(t.string)
v5.tileTypes = t.optional(t.string)
local analyticsData2

if FFlagLuaAppAddAnalyticsDataToSeeAllImpressions then
	analyticsData2 = t.optional(t.table)
end

v5.analyticsData = analyticsData2
local contentType2

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	contentType2 = t.optional(t.string)
end

v5.contentType = contentType2
local interactionUuid2

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	interactionUuid2 = t.optional(t.string)
end

v5.interactionUuid = interactionUuid2
local hasSponsoredContent2

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	hasSponsoredContent2 = t.optional(t.boolean)
end

v5.hasSponsoredContent = hasSponsoredContent2
local deeplink = strictInterface2(v5)

local strictInterface3 = t.strictInterface
local v6 = {
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
local mobileAdvertisingId3

if FFlagLuaAppGameImpressionsMobileAdsId then
	mobileAdvertisingId3 = t.optional(t.string)
end

v6.mobileAdvertisingId = mobileAdvertisingId3
v6.thumbnailAssetIds = t.optional(t.string)
v6.thumbnailListIds = t.optional(t.string)
local videoThumbnailAssetIds

if FFlagLuaAppSearchResultsPageGameTileVideo then
	videoThumbnailAssetIds = t.optional(t.string)
end

v6.videoThumbnailAssetIds = videoThumbnailAssetIds
local videoIsMoment_arr3

if FFlagLuaAppDiscoveryMomentVideoTelemetry then
	videoIsMoment_arr3 = t.optional(t.string)
end

v6.videoIsMoment_arr = videoIsMoment_arr3
v6.footerTextLiterals = t.optional(t.string)
v6.footerLocalizationKeys = t.optional(t.string)
v6.tileBadgeContexts = t.optional(t.string)
v6.componentType = t.optional(t.string)
v6.tileTypes = t.optional(t.string)
local analyticsData3

if FFlagSduiSearchResultsPageEnabled then
	analyticsData3 = t.optional(t.table)
end

v6.analyticsData = analyticsData3
local contentType3

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	contentType3 = t.optional(t.string)
end

v6.contentType = contentType3
local interactionUuid3

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	interactionUuid3 = t.optional(t.string)
end

v6.interactionUuid = interactionUuid3
local hasSponsoredContent3

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	hasSponsoredContent3 = t.optional(t.boolean)
end

v6.hasSponsoredContent = hasSponsoredContent3
local v7 = strictInterface3(v6)

local strictInterface4 = t.strictInterface
local v8 = {
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
local mobileAdvertisingId4

if FFlagLuaAppGameImpressionsMobileAdsId then
	mobileAdvertisingId4 = t.optional(t.string)
end

v8.mobileAdvertisingId = mobileAdvertisingId4
v8.tileTypes = t.optional(t.string)
local contentType4

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	contentType4 = t.optional(t.string)
end

v8.contentType = contentType4
local interactionUuid4

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	interactionUuid4 = t.optional(t.string)
end

v8.interactionUuid = interactionUuid4
local hasSponsoredContent4

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	hasSponsoredContent4 = t.optional(t.boolean)
end

v8.hasSponsoredContent = hasSponsoredContent4
local recommended = strictInterface4(v8)

local strictInterface5 = t.strictInterface
local v9 = {
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
local videoIsMoment_arr4

if FFlagLuaAppDiscoveryMomentVideoTelemetry then
	videoIsMoment_arr4 = t.optional(t.string)
end

v9.videoIsMoment_arr = videoIsMoment_arr4
v9.componentType = t.optional(t.string)
v9.rowsOnPage = t.optional(t.string)
v9.positionsInRows = t.optional(t.string)
local mobileAdvertisingId5

if FFlagLuaAppGameImpressionsMobileAdsId then
	mobileAdvertisingId5 = t.optional(t.string)
end

v9.mobileAdvertisingId = mobileAdvertisingId5

v9.gameSetTargetId = t.optional(t.number)
v9.adFlags = t.optional(t.string)
v9.adIds = t.optional(t.string)
v9.tileBadgeContexts = t.optional(t.string)
v9.thumbnailListIds = t.optional(t.string)
v9.tileTypes = t.optional(t.string)
local contentType5

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	contentType5 = t.optional(t.string)
end

v9.contentType = contentType5
local interactionUuid5

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	interactionUuid5 = t.optional(t.string)
end

v9.interactionUuid = interactionUuid5
local hasSponsoredContent5

if FFlagLuaAppGameImpressionsAddUnifiedFields then
	hasSponsoredContent5 = t.optional(t.boolean)
end

v9.hasSponsoredContent = hasSponsoredContent5
local v10 = strictInterface5(v9)
local inExpHistoryPage

if FFlagTraversalHistoryDiscoveryTelemetry then
	local strictInterface6 = t.strictInterface
	local v11 = {
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
	local contentType6

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		contentType6 = t.optional(t.string)
	end

	v11.contentType = contentType6
	local interactionUuid6

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		interactionUuid6 = t.optional(t.string)
	end

	v11.interactionUuid = interactionUuid6
	local hasSponsoredContent6

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		hasSponsoredContent6 = t.optional(t.boolean)
	end

	v11.hasSponsoredContent = hasSponsoredContent6
	inExpHistoryPage = strictInterface6(v11)
end

local v11 = { [AppPage.Home] = v4, [AppPage.Games] = v4 }
local SduiLandingPage = AppPage.SduiLandingPage

if not FFlagLuaAppSduiLandingPageEnabled then
	v4 = nil
end

v11[SduiLandingPage] = v4

v11[AppPage.SearchPage] = v7
v11[AppPage.SearchLandingPage] = v10
v11.recommended = recommended
v11.Deeplink = deeplink
v11.InExpHistoryPage = inExpHistoryPage

return function(object, eventContext, customFields)
	local v12

	if customFields.seeAllFlag and (eventContext == AppPage.Home or eventContext == AppPage.Games) then
		v12 = deeplink
	else
		v12 = v11[eventContext]
	end

	if v12 then
		local v13, v14 = v12(customFields)

		if not v13 then
			DiscoveryEventErrorLogger.reportError("GameImpressionsEventInvalidInterface", v14)
		end
	else
		DiscoveryEventErrorLogger.reportError(
			"GameImpressionsEventMissingInterface",
			`Missing interface for eventContext {eventContext} to type check gameImpressions event parameters`,
			{ eventContext = eventContext }
		)
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		customFields = Cryo.Dictionary.join(
			{
				interactionUuid = HttpService:GenerateGUID(false),
				contentType = ContentType.Game
			},
			customFields
		)
	end

	if customFields.analyticsData then
		local analyticsData = customFields.analyticsData
		customFields = Cryo.Dictionary.join(analyticsData, customFields, {
			analyticsData = Cryo.None
		})
	end

	if FFlagLuaAppMigrateGameEventsTelemetryService then
		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	else
		object:sendEventDeferred(eventContext, "gameImpressions", customFields)
	end

	if FFlagLuaAppGameEventsTelemetryServiceShadowTraffic then
		TelemetryService:LogEvent(v2, {
			eventContext = eventContext,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields,
			legacyOverrideTargetForEventIngest = getPlatformTarget()
		})
	end
end
