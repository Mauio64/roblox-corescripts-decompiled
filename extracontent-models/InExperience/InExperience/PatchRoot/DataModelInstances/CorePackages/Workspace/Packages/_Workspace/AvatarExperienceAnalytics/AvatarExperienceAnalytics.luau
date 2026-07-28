local AnalyticsService = require(script.AnalyticsService)
local AXUnifiedEventFilter = require(script.AXUnifiedEventFilter)
local addUnifiedEventLogging = require(script.addUnifiedEventLogging)
local useUnifiedEventListener = require(script.useUnifiedEventListener)
local sendUnifiedEventLog = require(script.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.sendUnifiedEventLogForInstance)
local logWidgetLoaded = require(script.logWidgetLoaded)
local sendUnifiedEventForDeferredAction = require(script.sendUnifiedEventForDeferredAction)
local sendUnifiedClickItemDetailsEvent = require(script.sendUnifiedClickItemDetailsEvent)
local sendUnifiedEventsForMultiItemShopping = require(script.sendUnifiedEventsForMultiItemShopping)
local UnifiedEventLogConstants = require(script.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.UnifiedEventLogEnums)

return {
	AnalyticsService = AnalyticsService,
	AXUnifiedEventFilter = AXUnifiedEventFilter,
	addUnifiedEventLogging = addUnifiedEventLogging,
	useUnifiedEventListener = useUnifiedEventListener,
	sendUnifiedEventLog = sendUnifiedEventLog,
	sendUnifiedEventLogForInstance = sendUnifiedEventLogForInstance,
	logWidgetLoaded = logWidgetLoaded,
	sendUnifiedEventForDeferredAction = sendUnifiedEventForDeferredAction,
	sendUnifiedClickItemDetailsEvent = sendUnifiedClickItemDetailsEvent,
	sendUnifiedEventsForMultiItemShopping = sendUnifiedEventsForMultiItemShopping,
	UnifiedEventLogConstants = UnifiedEventLogConstants,
	UnifiedEventLogEnums = UnifiedEventLogEnums,
	useUnifiedEventImpressionsReporter = require(script.useUnifiedEventImpressionsReporter),
	useUnifiedEventTagging = require(script.useUnifiedEventTagging),
	TagBasedImpressionsDetector = require(script.TagBasedImpressionsDetector),
	AvatarExperienceImpressionsDetector = require(script.AvatarExperienceImpressionsDetector),
	AvatarExperienceScreenSizeImpressionsDetector = require(script.AvatarExperienceScreenSizeImpressionsDetector),
	sendAXStat = require(script.sendAXStat),
	sendAXCounterV2 = require(script.sendAXCounterV2),
	getAvatarEventCounterNameWithPlatform = require(script.getAvatarEventCounterNameWithPlatform),
	reportAvatarEventCounterNoAnalyticsArgument = require(script.reportAvatarEventCounterNoAnalyticsArgument),
	reportAvatarEventCounterV1 = require(script.reportAvatarEventCounterV1),
	reportBackgroundUserActionCounter = require(script.reportBackgroundUserActionCounter),
	Flags = {},
	Enums = {
		ImpressionEnums = require(script.Enums.ImpressionEnums)
	},
	Lib = {
		CartIdService = require(script.Lib.CartIdService)
	},
	Store = {
		SeenImpressionsStore = require(script.Store.SeenImpressionsStore),
		UnifiedSelectionListStore = require(script.Store.UnifiedSelectionListStore)
	},
	Surfaces = {
		SlotBasedEditorAnalytics = require(script.Surfaces.SlotBasedEditorAnalytics)
	},
	Utils = {
		UnifiedEventLoggingUtils = require(script.Utils.UnifiedEventLoggingUtils),
		getMarketplaceUnifiedItemType = require(script.Utils.getMarketplaceUnifiedItemType),
		getTimedOptionForItemData = require(script.Utils.getTimedOptionForItemData),
		getUnifiedEventsForMIS = require(script.Utils.getUnifiedEventsForMIS),
		getUnifiedLoggingSurface = require(script.Utils.getUnifiedLoggingSurface),
		getUnifiedLoggingSurfaceForAppPage = require(script.Utils.getUnifiedLoggingSurfaceForAppPage),
		getItemSelectionAction = require(script.Utils.getItemSelectionAction),
		getCatalogItemUnifiedLoggingFields = require(script.Utils.getCatalogItemUnifiedLoggingFields)
	},
	Constants = require(script.Constants),
	ImpressionsReporter = {
		ImpressionsUtil = require(script.ImpressionsReporter.ImpressionsUtil),
		OrganicEventImpressionsSchema = require(script.ImpressionsReporter.OrganicEventImpressionsSchema)
	},
	Events = {
		BulkPurchaseMissingPurchaseOptionsCounter = require(script.Events.BulkPurchaseMissingPurchaseOptionsCounter)
	},
	["jest.config"] = script["jest.config"]
}
