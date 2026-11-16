local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AnalyticsService")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AvatarExperienceAnalyticsService")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AXUnifiedEventFilter")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/addUnifiedEventLogging")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/useUnifiedEventListener")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendPassthroughUnifiedEventLog")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/logWidgetLoaded")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/flushDeferredWidgetLoaded")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventForDeferredAction")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/normalizeDiscoveryPurchaseEntity")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/buildDiscoveryPurchaseAttempt")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedClickItemDetailsEvent")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventsForMultiItemShopping")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/TagBasedImpressionsDetector")

return {
	AnalyticsService = module,
	AvatarExperienceAnalyticsService = module2,
	AXUnifiedEventFilter = module3,
	addUnifiedEventLogging = module4,
	useUnifiedEventListener = module5,
	sendUnifiedEventLog = module6,
	sendUnifiedEventLogForInstance = module7,
	sendPassthroughUnifiedEventLog = module8.send,
	sendPassthroughUnifiedEventLogForInstance = module8.sendForInstance,
	logWidgetLoaded = module9,
	flushDeferredWidgetLoaded = module10,
	sendUnifiedEventForDeferredAction = module11,
	normalizeDiscoveryPurchaseEntity = module12,
	buildDiscoveryPurchaseAttempt = module13,
	sendUnifiedClickItemDetailsEvent = module14,
	sendUnifiedEventsForMultiItemShopping = module15,
	UnifiedEventLogConstants = module16,
	UnifiedEventLogEnums = module17,
	useUnifiedEventImpressionsReporter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/useUnifiedEventImpressionsReporter"),
	useRequestImpressionsOnTagAdded = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/useRequestImpressionsOnTagAdded"),
	useUnifiedEventTagging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/useUnifiedEventTagging"),
	TagBasedImpressionsDetector = module18,
	AvatarExperienceImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AvatarExperienceImpressionsDetector"),
	AvatarExperienceScreenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AvatarExperienceScreenSizeImpressionsDetector"),
	sendAXStat = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXStat"),
	sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2"),
	UnifiedEventCounterAggregator = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Lib/UnifiedEventCounterAggregator"),
	getAvatarEventCounterNameWithPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/getAvatarEventCounterNameWithPlatform"),
	reportAvatarEventCounterNoAnalyticsArgument = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportAvatarEventCounterNoAnalyticsArgument"),
	reportAvatarEventCounterV1 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportAvatarEventCounterV1"),
	reportAvatarEditorServiceCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportAvatarEditorServiceCounter"),
	Flags = {
		FFlagAllowCustomUnifiedEventFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/FFlagAllowCustomUnifiedEventFilter"),
		FFlagAXAvatarEditorServiceTelemetryV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXAvatarEditorServiceTelemetryV2,
		FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXDeprecateAvatarEditorServiceTelemetryV1,
		FFlagAXUnifiedEventCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventCounters,
		FFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads
	},
	reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportBackgroundUserActionCounter"),
	Enums = {
		ImpressionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/ImpressionEnums"),
		UnifiedLoggingElementNameEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/UnifiedLoggingElementNameEnums"),
		UnifiedLoggingSectionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/UnifiedLoggingSectionEnums")
	},
	Lib = { CartIdService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Lib/CartIdService") },
	Store = {
		SeenImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/SeenImpressionsStore"),
		UnifiedEventPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedEventPageStore"),
		UnifiedSelectionListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedSelectionListStore")
	},
	Surfaces = {
		SlotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Surfaces/SlotBasedEditorAnalytics"),
		SupportRegionAvatarOverlayAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Surfaces/SupportRegionAvatarOverlayAnalytics")
	},
	Utils = {
		UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils"),
		aliasSortAndFiltersToLegacyKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/aliasSortAndFiltersToLegacyKeys"),
		getMarketplaceUnifiedItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedItemType"),
		getMarketplaceUnifiedAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedAssetType"),
		getMarketplaceUnifiedBundleType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedBundleType"),
		getMarketplaceUnifiedLookType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedLookType"),
		getWidgetAttributionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getWidgetAttributionFields"),
		getTimedOptionForItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getTimedOptionForItemData"),
		getUnifiedEventsForMIS = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedEventsForMIS"),
		getUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedLoggingSurface"),
		getUnifiedLoggingSurfaceForAppPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedLoggingSurfaceForAppPage"),
		getUnifiedLoggingSurfaceForRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedLoggingSurfaceForRoute"),
		mapAnalyticsMetadataFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/mapAnalyticsMetadataFields"),
		mapMarketplaceSurfaceToUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/mapMarketplaceSurfaceToUnifiedLoggingSurface"),
		getItemSelectionAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getItemSelectionAction"),
		getCatalogItemUnifiedLoggingFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getCatalogItemUnifiedLoggingFields")
	},
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants"),
	ImpressionsReporter = {
		ImpressionsUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/ImpressionsReporter/ImpressionsUtil"),
		OrganicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/ImpressionsReporter/OrganicEventImpressionsSchema")
	},
	Events = { BulkPurchaseMissingPurchaseOptionsCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Events/BulkPurchaseMissingPurchaseOptionsCounter") }
}
