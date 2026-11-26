local fFlagLuaAppRfySignalApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppRfySignalApportioning
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local v5 = {
	SduiComponent = SduiCoreSystem.SduiComponent,
	SduiComponentType = SduiCoreSystem.SduiComponentType,
	SduiOmniFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiOmniFeedItem"),
	SduiV2OmniFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiV2OmniFeedItem"),
	SduiV2OmniFeedConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiV2OmniFeedConstants"),
	SduiSeeAllGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiSeeAllGrid"),
	AddSduiRootConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/AddSduiRootConfig"),
	RemoveSduiRootConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/RemoveSduiRootConfig"),
	SduiConfigReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/SduiConfigReducer"),
	useSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiContext"),
	isSduiGameOmniFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/isSduiGameOmniFeedItem"),
	useSduiContextFromRoduxAndProcessConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/useSduiContextFromRoduxAndProcessConfigs"),
	useApportioningPreprocessingFromOmniRecommendations = 0,
	seedHomeOmniSduiV2Payload = 0,
	validateSduiComponentConfig = 0,
	useSduiContextFromSignalAndProcessConfigs = 0,
	getSduiFeedStore = 0,
	useSduiEdpFeedItemConfigs = 0,
	SduiErrors = 0,
	SduiLogger = 0,
	SduiDiscoveryDependencyUpdater = 0,
	registerDiscoveryActions = 0,
	registerDiscoveryActionTelemetryHandlers = 0,
	registerDiscoveryImpressions = 0,
	registerDiscoveryUiComponents = 0,
	SearchPageTabSwitchBridge = 0,
	OpenSearchResultsWithQueryBridge = 0,
	ItemHeightMode = 0
}

local v6 = if fFlagLuaAppRfySignalApportioning then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/useApportioningPreprocessingFromOmniRecommendations") else nil
v5.useApportioningPreprocessingFromOmniRecommendations = v6

v5.seedHomeOmniSduiV2Payload = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/seedHomeOmniSduiV2Payload")
v5.validateSduiComponentConfig = SduiCoreSystem.validateSduiComponentConfig
v5.useSduiContextFromSignalAndProcessConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/useSduiContextFromSignalAndProcessConfigs")
v5.getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")
v5.useSduiEdpFeedItemConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/useSduiEdpFeedItemConfigs")
v5.SduiErrors = SduiCoreSystem.SduiErrors
v5.SduiLogger = SduiCoreSystem.SduiLogger
v5.SduiDiscoveryDependencyUpdater = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/SduiDiscoveryDependencyUpdater")
v5.registerDiscoveryActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/registerDiscoveryActions")
v5.registerDiscoveryActionTelemetryHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/registerDiscoveryActionTelemetryHandlers")

v5.registerDiscoveryImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/registerDiscoveryImpressions")
v5.registerDiscoveryUiComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/registerDiscoveryUiComponents")
v5.SearchPageTabSwitchBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/SearchPageTabSwitchBridge")
v5.OpenSearchResultsWithQueryBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/OpenSearchResultsWithQueryBridge")
v5.ItemHeightMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/ItemHeightMode")
return v5
