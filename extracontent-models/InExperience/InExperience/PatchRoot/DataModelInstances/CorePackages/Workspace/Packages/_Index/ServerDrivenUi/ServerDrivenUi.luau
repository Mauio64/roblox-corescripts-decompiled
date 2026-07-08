local scriptParent = script.Parent
local FFlagLuaAppRfySignalApportioning = require(scriptParent.SharedFlags).FFlagLuaAppRfySignalApportioning
local SduiCoreSystem = require(script.Parent.SduiCoreSystem)

return {
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
	useSduiContextFromRoduxAndProcessConfigs = require(script.Migration.useSduiContextFromRoduxAndProcessConfigs),
	useApportioningPreprocessingFromOmniRecommendations = if not FFlagLuaAppRfySignalApportioning then nil else require(script.Migration.useApportioningPreprocessingFromOmniRecommendations),
	seedHomeOmniSduiV2Payload = require(script.Migration.seedHomeOmniSduiV2Payload),
	validateSduiComponentConfig = SduiCoreSystem.validateSduiComponentConfig,
	useSduiContextFromSignalAndProcessConfigs = require(script.Migration.useSduiContextFromSignalAndProcessConfigs),
	getSduiFeedStore = require(script.DataStore.getSduiFeedStore),
	useSduiEdpFeedItemConfigs = require(script.Migration.useSduiEdpFeedItemConfigs),
	SduiErrors = SduiCoreSystem.SduiErrors,
	SduiLogger = SduiCoreSystem.SduiLogger,
	SduiDiscoveryDependencyUpdater = require(script.System.SduiDiscoveryDependencyUpdater),
	SearchPageTabSwitchBridge = require(script.System.SearchPageTabSwitchBridge),
	OpenSearchResultsWithQueryBridge = require(script.System.OpenSearchResultsWithQueryBridge),
	ItemHeightMode = require(script.Content.Collections.ItemHeightMode)
}
