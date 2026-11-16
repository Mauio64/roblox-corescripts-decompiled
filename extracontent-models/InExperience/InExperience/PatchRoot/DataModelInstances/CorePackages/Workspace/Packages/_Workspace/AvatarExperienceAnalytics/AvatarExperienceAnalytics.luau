local parent = script.Parent

local AnalyticsService = require(script.AnalyticsService)
local AvatarExperienceAnalyticsService = require(script.AvatarExperienceAnalyticsService)
local AXUnifiedEventFilter = require(script.AXUnifiedEventFilter)
local addUnifiedEventLogging = require(script.addUnifiedEventLogging)
local useUnifiedEventListener = require(script.useUnifiedEventListener)
local sendUnifiedEventLog = require(script.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.sendUnifiedEventLogForInstance)
local sendPassthroughUnifiedEventLog = require(script.sendPassthroughUnifiedEventLog)
local logWidgetLoaded = require(script.logWidgetLoaded)
local flushDeferredWidgetLoaded = require(script.flushDeferredWidgetLoaded)
local sendUnifiedEventForDeferredAction = require(script.sendUnifiedEventForDeferredAction)
local normalizeDiscoveryPurchaseEntity = require(script.normalizeDiscoveryPurchaseEntity)
local buildDiscoveryPurchaseAttempt = require(script.buildDiscoveryPurchaseAttempt)
local sendUnifiedClickItemDetailsEvent = require(script.sendUnifiedClickItemDetailsEvent)
local sendUnifiedEventsForMultiItemShopping = require(script.sendUnifiedEventsForMultiItemShopping)
local UnifiedEventLogConstants = require(script.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.UnifiedEventLogEnums)
require(script.Generated.UnifiedEventTypes)
local TagBasedImpressionsDetector = require(script.TagBasedImpressionsDetector)

local AvatarExperienceAnalytics = {}
AvatarExperienceAnalytics.AnalyticsService = AnalyticsService
AvatarExperienceAnalytics.AvatarExperienceAnalyticsService = AvatarExperienceAnalyticsService
AvatarExperienceAnalytics.AXUnifiedEventFilter = AXUnifiedEventFilter
AvatarExperienceAnalytics.addUnifiedEventLogging = addUnifiedEventLogging
AvatarExperienceAnalytics.useUnifiedEventListener = useUnifiedEventListener
AvatarExperienceAnalytics.sendUnifiedEventLog = sendUnifiedEventLog
AvatarExperienceAnalytics.sendUnifiedEventLogForInstance = sendUnifiedEventLogForInstance
AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog = sendPassthroughUnifiedEventLog.send
AvatarExperienceAnalytics.sendPassthroughUnifiedEventLogForInstance = sendPassthroughUnifiedEventLog.sendForInstance
AvatarExperienceAnalytics.logWidgetLoaded = logWidgetLoaded
AvatarExperienceAnalytics.flushDeferredWidgetLoaded = flushDeferredWidgetLoaded
AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction = sendUnifiedEventForDeferredAction
AvatarExperienceAnalytics.normalizeDiscoveryPurchaseEntity = normalizeDiscoveryPurchaseEntity
AvatarExperienceAnalytics.buildDiscoveryPurchaseAttempt = buildDiscoveryPurchaseAttempt
AvatarExperienceAnalytics.sendUnifiedClickItemDetailsEvent = sendUnifiedClickItemDetailsEvent
AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping = sendUnifiedEventsForMultiItemShopping
AvatarExperienceAnalytics.UnifiedEventLogConstants = UnifiedEventLogConstants
AvatarExperienceAnalytics.UnifiedEventLogEnums = UnifiedEventLogEnums
AvatarExperienceAnalytics.useUnifiedEventImpressionsReporter = require(script.useUnifiedEventImpressionsReporter)
AvatarExperienceAnalytics.useRequestImpressionsOnTagAdded = require(script.useRequestImpressionsOnTagAdded)
AvatarExperienceAnalytics.useUnifiedEventTagging = require(script.useUnifiedEventTagging)
AvatarExperienceAnalytics.TagBasedImpressionsDetector = TagBasedImpressionsDetector
AvatarExperienceAnalytics.AvatarExperienceImpressionsDetector = require(script.AvatarExperienceImpressionsDetector)
AvatarExperienceAnalytics.AvatarExperienceScreenSizeImpressionsDetector = require(script.AvatarExperienceScreenSizeImpressionsDetector)
AvatarExperienceAnalytics.sendAXStat = require(script.sendAXStat)
AvatarExperienceAnalytics.sendAXCounterV2 = require(script.sendAXCounterV2)
AvatarExperienceAnalytics.UnifiedEventCounterAggregator = require(script.Lib.UnifiedEventCounterAggregator)
AvatarExperienceAnalytics.getAvatarEventCounterNameWithPlatform = require(script.getAvatarEventCounterNameWithPlatform)
AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument = require(script.reportAvatarEventCounterNoAnalyticsArgument)
AvatarExperienceAnalytics.reportAvatarEventCounterV1 = require(script.reportAvatarEventCounterV1)
AvatarExperienceAnalytics.reportAvatarEditorServiceCounter = require(script.reportAvatarEditorServiceCounter)
local flags = {
	FFlagAllowCustomUnifiedEventFilter = require(script.FFlagAllowCustomUnifiedEventFilter),
	FFlagAXAvatarEditorServiceTelemetryV2 = 0,
	FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = 0,
	FFlagAXUnifiedEventCounters = 0,
	FFlagAXUnifiedEventStrictPayloads = 0
}
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
flags.FFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags2.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
flags.FFlagAXUnifiedEventCounters = AvatarExperienceFlags3.FFlagAXUnifiedEventCounters
local AvatarExperienceFlags4 = require(parent.AvatarExperienceFlags)
flags.FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags4.FFlagAXUnifiedEventStrictPayloads
AvatarExperienceAnalytics.Flags = flags

AvatarExperienceAnalytics.reportBackgroundUserActionCounter = require(script.reportBackgroundUserActionCounter)
AvatarExperienceAnalytics.Enums = {
	ImpressionEnums = require(script.Enums.ImpressionEnums),
	UnifiedLoggingElementNameEnums = require(script.Enums.UnifiedLoggingElementNameEnums),
	UnifiedLoggingSectionEnums = require(script.Enums.UnifiedLoggingSectionEnums)
}

AvatarExperienceAnalytics.Lib = {
	CartIdService = require(script.Lib.CartIdService)
}

AvatarExperienceAnalytics.Store = {
	SeenImpressionsStore = require(script.Store.SeenImpressionsStore),
	UnifiedEventPageStore = require(script.Store.UnifiedEventPageStore),
	UnifiedSelectionListStore = require(script.Store.UnifiedSelectionListStore)
}

AvatarExperienceAnalytics.Surfaces = {
	SlotBasedEditorAnalytics = require(script.Surfaces.SlotBasedEditorAnalytics),
	SupportRegionAvatarOverlayAnalytics = require(script.Surfaces.SupportRegionAvatarOverlayAnalytics)
}

AvatarExperienceAnalytics.Utils = {
	UnifiedEventLoggingUtils = require(script.Utils.UnifiedEventLoggingUtils),
	aliasSortAndFiltersToLegacyKeys = require(script.Utils.aliasSortAndFiltersToLegacyKeys),
	getMarketplaceUnifiedItemType = require(script.Utils.getMarketplaceUnifiedItemType),
	getMarketplaceUnifiedAssetType = require(script.Utils.getMarketplaceUnifiedAssetType),
	getMarketplaceUnifiedBundleType = require(script.Utils.getMarketplaceUnifiedBundleType),
	getMarketplaceUnifiedLookType = require(script.Utils.getMarketplaceUnifiedLookType),
	getWidgetAttributionFields = require(script.Utils.getWidgetAttributionFields),
	getTimedOptionForItemData = require(script.Utils.getTimedOptionForItemData),
	getUnifiedEventsForMIS = require(script.Utils.getUnifiedEventsForMIS),
	getUnifiedLoggingSurface = require(script.Utils.getUnifiedLoggingSurface),
	getUnifiedLoggingSurfaceForAppPage = require(script.Utils.getUnifiedLoggingSurfaceForAppPage),
	getUnifiedLoggingSurfaceForRoute = require(script.Utils.getUnifiedLoggingSurfaceForRoute),
	mapAnalyticsMetadataFields = require(script.Utils.mapAnalyticsMetadataFields),
	mapMarketplaceSurfaceToUnifiedLoggingSurface = require(script.Utils.mapMarketplaceSurfaceToUnifiedLoggingSurface),
	getItemSelectionAction = require(script.Utils.getItemSelectionAction),
	getCatalogItemUnifiedLoggingFields = require(script.Utils.getCatalogItemUnifiedLoggingFields)
}

AvatarExperienceAnalytics.Constants = require(script.Constants)
AvatarExperienceAnalytics.ImpressionsReporter = {
	ImpressionsUtil = require(script.ImpressionsReporter.ImpressionsUtil),
	OrganicEventImpressionsSchema = require(script.ImpressionsReporter.OrganicEventImpressionsSchema)
}

AvatarExperienceAnalytics.Events = {
	BulkPurchaseMissingPurchaseOptionsCounter = require(script.Events.BulkPurchaseMissingPurchaseOptionsCounter)
}

AvatarExperienceAnalytics["jest.config"] = script["jest.config"]
return AvatarExperienceAnalytics
