local SduiActionType = require(script.SduiActionType)
local SduiImpressionEventType = require(script.SduiImpressionEventType)
local SduiBuilderTypes = require(script.SduiBuilderTypes)
local SduiComponentType = require(script.SduiComponentType)
local SduiConfigTypes = require(script.SduiConfigTypes)
local SduiContentTypes = require(script.SduiContentTypes)
require(script.SduiDataStoreTypes)
require(script.SduiFocusNavigationTypes)
require(script.ClientBinding.SduiPoolStoreTypes)
local SduiErrors = require(script.SduiErrors)

return {
	["jest.config"] = script["jest.config"],
	executeAction = require(script.executeAction),
	createSduiErrorLogger = require(script.createSduiErrorLogger),
	addSduiErrorContextFields = require(script.addSduiErrorContextFields),
	findAnalyticsField = require(script.findAnalyticsField),
	findAnalyticsFieldInAncestors = require(script.findAnalyticsFieldInAncestors),
	getActionTelemetryFieldValue = require(script.getActionTelemetryFieldValue),
	getSduiComponentWrapper = require(script.getSduiComponentWrapper),
	reportUnifiedLoggingAction = require(script.Analytics.reportUnifiedLoggingAction),
	reportUnifiedLoggingImpressions = require(script.Analytics.reportUnifiedLoggingImpressions),
	parseProps = require(script.parseProps),
	SduiActionParams = require(script.SduiActionParams),
	SduiActionType = SduiActionType,
	SduiImpressionEventType = SduiImpressionEventType,
	SduiBuilder = require(script.SduiBuilder),
	SduiBuilderTypes = SduiBuilderTypes,
	SduiCollectionAnalyticsBuilder = require(script.Analytics.SduiCollectionAnalyticsBuilder),
	SduiComponent = require(script.SduiComponent),
	SduiComponentType = SduiComponentType,
	SduiConfigTypes = SduiConfigTypes,
	SduiContentTypes = SduiContentTypes,
	SduiErrors = SduiErrors,
	SduiInstrumentation = require(script.SduiInstrumentation),
	SduiLogger = require(script.SduiLogger),
	SduiMockUtils = require(script.ClientBinding.SduiMockUtils),
	SduiParseHelpers = require(script.SduiParseHelpers),
	SduiPoolStore = require(script.ClientBinding.SduiPoolStore),
	SduiParsers = require(script.SduiParsers),
	SduiResponsiveHelpers = require(script.SduiResponsiveHelpers),
	SduiTemplateRegistry = require(script.SduiTemplateRegistry),
	SduiUsageRecorder = require(script.Analytics.SduiUsageRecorder),
	recordTemplateUsage = require(script.Analytics.recordTemplateUsage),
	recordV1ComponentUsage = require(script.Analytics.recordV1ComponentUsage),
	recordV1RegisteredTemplates = require(script.Analytics.recordV1RegisteredTemplates),
	useUidRefString = require(script.useUidRefString),
	validateInterface = require(script.validateInterface),
	validateSduiComponentConfig = require(script.validateSduiComponentConfig),
	getSduiClientBindingBuilder = function()
		return require(script.ClientBinding.SduiClientBindingBuilder)
	end,
	getSduiDataBinder = function()
		return require(script.ClientBinding.SduiDataBinder)
	end,
	getProtoVariableMapper = function()
		return require(script.ClientBinding.ProtoVariableMapper)
	end,
	getDefaultHydrationIdPaths = function()
		return require(script.ClientBinding.defaultHydrationIdPaths)
	end,
	createBuilderConfig = function(p)
		local createBuilderConfig = require(script.ClientBinding.createBuilderConfig)
		return createBuilderConfig(p)
	end,
	getSduiActionHandlerRegistry = function()
		local getSduiActionHandlerRegistry = require(script.getSduiActionHandlerRegistry)
		return getSduiActionHandlerRegistry()
	end,
	getSduiImpressionHandlerRegistry = function()
		local getSduiImpressionHandlerRegistry = require(script.getSduiImpressionHandlerRegistry)
		return getSduiImpressionHandlerRegistry()
	end,
	getSduiTelemetryHandlerNameRegistry = function()
		local getSduiTelemetryHandlerNameRegistry = require(script.getSduiTelemetryHandlerNameRegistry)
		return getSduiTelemetryHandlerNameRegistry()
	end,
	getSduiServiceDependenciesStore = function()
		local getSduiServiceDependenciesStore = require(script.ClientBinding.getSduiServiceDependenciesStore)
		return getSduiServiceDependenciesStore()
	end,
	getOneByTwoTileFlowIdsFromPools = function(p)
		local SduiPoolEntryHelpers = require(script.ClientBinding.PropBuilder.SduiPoolEntryHelpers)
		return SduiPoolEntryHelpers.getOneByTwoTileFlowIdsFromPools(p)
	end,
	getSduiTokensStore = function()
		local getSduiTokensStore = require(script.ClientBinding.getSduiTokensStore)
		return getSduiTokensStore()
	end,
	getSduiPolicyStore = function()
		local getSduiPolicyStore = require(script.ClientBinding.getSduiPolicyStore)
		return getSduiPolicyStore()
	end,
	getSduiComponentRegistry = require(script.getSduiComponentRegistry),
	getSduiClientPageScope = require(script.ClientBinding.getSduiClientPageScope),
	usePageScopeRef = require(script.ClientBinding.usePageScopeRef),
	SduiCapabilities = require(script.ClientBinding.SduiCapabilities)
}
