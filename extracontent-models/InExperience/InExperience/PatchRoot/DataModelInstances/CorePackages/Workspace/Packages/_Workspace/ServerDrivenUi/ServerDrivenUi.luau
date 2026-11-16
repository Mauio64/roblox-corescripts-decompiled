local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppRfySignalApportioning = SharedFlags.FFlagLuaAppRfySignalApportioning
local SduiCoreSystem = require(script.Parent.SduiCoreSystem)

local ServerDrivenUi = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	SduiComponent = SduiCoreSystem.SduiComponent,
	SduiComponentType = SduiCoreSystem.SduiComponentType,
	SduiOmniFeedItem = require(script.Migration.SduiOmniFeedItem),
	SduiV2OmniFeedItem = require(script.Migration.SduiV2OmniFeedItem),
	SduiV2OmniFeedConstants = require(script.Migration.SduiV2OmniFeedConstants),
	SduiSeeAllGrid = require(script.Migration.SduiSeeAllGrid),
	AddSduiRootConfig = require(script.Rodux.AddSduiRootConfig),
	RemoveSduiRootConfig = require(script.Rodux.RemoveSduiRootConfig),
	SduiConfigReducer = require(script.Rodux.SduiConfigReducer),
	useSduiContext = require(script.System.useSduiContext),
	isSduiGameOmniFeedItem = require(script.Migration.isSduiGameOmniFeedItem),
	useSduiContextFromRoduxAndProcessConfigs = require(script.Migration.useSduiContextFromRoduxAndProcessConfigs)
}
local useApportioningPreprocessingFromOmniRecommendations

if FFlagLuaAppRfySignalApportioning then
	useApportioningPreprocessingFromOmniRecommendations = require(script.Migration.useApportioningPreprocessingFromOmniRecommendations)
end

ServerDrivenUi.useApportioningPreprocessingFromOmniRecommendations = useApportioningPreprocessingFromOmniRecommendations

ServerDrivenUi.seedHomeOmniSduiV2Payload = require(script.Migration.seedHomeOmniSduiV2Payload)
ServerDrivenUi.validateSduiComponentConfig = SduiCoreSystem.validateSduiComponentConfig
ServerDrivenUi.useSduiContextFromSignalAndProcessConfigs = require(script.Migration.useSduiContextFromSignalAndProcessConfigs)
ServerDrivenUi.getSduiFeedStore = require(script.DataStore.getSduiFeedStore)
ServerDrivenUi.useSduiEdpFeedItemConfigs = require(script.Migration.useSduiEdpFeedItemConfigs)
ServerDrivenUi.SduiErrors = SduiCoreSystem.SduiErrors
ServerDrivenUi.SduiLogger = SduiCoreSystem.SduiLogger
ServerDrivenUi.SduiDiscoveryDependencyUpdater = require(script.System.SduiDiscoveryDependencyUpdater)
ServerDrivenUi.registerDiscoveryActions = require(script.Actions.registerDiscoveryActions)
ServerDrivenUi.registerDiscoveryActionTelemetryHandlers = require(script.Actions.TelemetryHandlers.registerDiscoveryActionTelemetryHandlers)

ServerDrivenUi.registerDiscoveryImpressions = require(script.Impressions.registerDiscoveryImpressions)
ServerDrivenUi.registerDiscoveryUiComponents = require(script.Content.registerDiscoveryUiComponents)
ServerDrivenUi.SearchPageTabSwitchBridge = require(script.System.SearchPageTabSwitchBridge)
ServerDrivenUi.OpenSearchResultsWithQueryBridge = require(script.System.OpenSearchResultsWithQueryBridge)
ServerDrivenUi.ItemHeightMode = require(script.Content.Collections.ItemHeightMode)
return ServerDrivenUi
