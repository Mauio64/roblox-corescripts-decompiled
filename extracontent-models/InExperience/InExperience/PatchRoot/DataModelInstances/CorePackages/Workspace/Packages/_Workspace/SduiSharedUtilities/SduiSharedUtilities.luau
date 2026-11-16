local SduiIntegrationTypes = require(script.SduiIntegrationTypes)
local SduiResponseType = SduiIntegrationTypes.SduiResponseType
local SduiIntegrationTypes2 = require(script.SduiIntegrationTypes)
local SduiRequestConcurrencyPolicy = SduiIntegrationTypes2.SduiRequestConcurrencyPolicy
local SduiLoadTimer = require(script.SduiLoadTimer)
local SduiSurfaceLoadTimeTracker = require(script.SduiSurfaceLoadTimeTracker)
require(script.SduiIntegrationTypes)
local parent = script.Parent
require(parent.SduiCoreSystem)

local SharedFlags = require(parent.SharedFlags)
local FFlagHomePageRefetchOnDataHydrationAccountReset = SharedFlags.FFlagHomePageRefetchOnDataHydrationAccountReset
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiApiStoreUpdateInputData = SharedFlags2.FFlagSduiApiStoreUpdateInputData

local SduiSharedUtilities = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	SduiFocusTags = require(script.FocusNavigation.SduiFocusTags)
}
local NavigateBackBindings = require(script.FocusNavigation.NavigateBackBindings)
SduiSharedUtilities.OnNavigateBackWrapper = NavigateBackBindings.OnNavigateBackWrapper
function SduiSharedUtilities.useOnNavigateBack(callback, p)
	local NavigateBackBindings2 = require(script.FocusNavigation.NavigateBackBindings)
	return NavigateBackBindings2.useOnNavigateBack(callback, p)
end

function SduiSharedUtilities.useInitialFocusOnTag(p: string, p2)
	local useInitialFocusOnTag = require(script.FocusNavigation.useInitialFocusOnTag)
	useInitialFocusOnTag(p, p2)
end
function SduiSharedUtilities.useSelectionOrderTracking(p)
	local useSelectionOrderTracking = require(script.FocusNavigation.useSelectionOrderTracking)
	useSelectionOrderTracking(p)
end
function SduiSharedUtilities.usePageButtonBindings(p, p2, p3)
	local usePageButtonBindings = require(script.FocusNavigation.usePageButtonBindings)
	return usePageButtonBindings(p, p2, p3)
end

function SduiSharedUtilities.useBackButtonBinding(callback)
	local useBackButtonBinding = require(script.FocusNavigation.useBackButtonBinding)
	return useBackButtonBinding(callback)
end

function SduiSharedUtilities.createSduiFocusActivationStore()
	local createSduiFocusActivationStore = require(script.FocusNavigation.createSduiFocusActivationStore)
	return createSduiFocusActivationStore()
end

function SduiSharedUtilities.getSduiFocusActivationStore()
	local getSduiFocusActivationStore = require(script.FocusNavigation.getSduiFocusActivationStore)
	return getSduiFocusActivationStore()
end

function SduiSharedUtilities.useSduiFocusActivation(p: string?, callback)
	local useSduiFocusActivation = require(script.FocusNavigation.useSduiFocusActivation)
	useSduiFocusActivation(p, callback)
end
SduiSharedUtilities.createSduiApiStore = require(script.createSduiApiStore)
SduiSharedUtilities.getSduiApiStore = require(script.getSduiApiStore)
local sduiInputDataUpdates

if FFlagSduiApiStoreUpdateInputData then
	sduiInputDataUpdates = require(script.SduiInputDataUpdates)
end

SduiSharedUtilities.SduiInputDataUpdates = sduiInputDataUpdates
local useDataHydrationAccountGeneration

if FFlagHomePageRefetchOnDataHydrationAccountReset then
	useDataHydrationAccountGeneration = require(script.hooks.useDataHydrationAccountGeneration)
end

SduiSharedUtilities.useDataHydrationAccountGeneration = useDataHydrationAccountGeneration

function SduiSharedUtilities.fetchSduiTemplates(p, flag: boolean?)
	local fetchSduiTemplates = require(script.fetchSduiTemplates)
	return fetchSduiTemplates(p, flag)
end

function SduiSharedUtilities.createTemplateApiRequestConfig(p)
	local createTemplateApiRequestConfig = require(script.createTemplateApiRequestConfig)
	return createTemplateApiRequestConfig(p)
end

SduiSharedUtilities.handleSduiApiResponse = require(script.handleSduiApiResponse)
function SduiSharedUtilities.prewarmAppTemplatesOnLaunch()
	local prewarmAppTemplatesOnLaunch = require(script.prewarmAppTemplatesOnLaunch)
	return prewarmAppTemplatesOnLaunch()
end

SduiSharedUtilities.SduiLoadTimer = SduiLoadTimer
SduiSharedUtilities.SduiSurfaceLoadTimeTracker = SduiSurfaceLoadTimeTracker
SduiSharedUtilities.SduiPageEntryPoint = require(script.SduiPageEntryPoint)
SduiSharedUtilities.SduiPageWrapperEntryPoint = require(script.SduiPageWrapperEntryPoint)
SduiSharedUtilities.SduiPageNavigationHeader = require(script.SduiPageNavigationHeader)
SduiSharedUtilities.useScrollAwayHeaderPosition = require(script.useScrollAwayHeaderPosition)
SduiSharedUtilities.SduiFeatureEntryPoint = require(script.SduiFeatureEntryPoint)
SduiSharedUtilities.getSduiTemplateStore = require(script.getSduiTemplateStore)
SduiSharedUtilities.getSduiPageEntrySnackbarStore = require(script.getSduiPageEntrySnackbarStore)
SduiSharedUtilities.usePageEntrySnackbar = require(script.usePageEntrySnackbar)
SduiSharedUtilities.useComponentConfig = require(script.hooks.useComponentConfig)
SduiSharedUtilities.usePreferredTextSizeLineBudget = require(script.hooks.usePreferredTextSizeLineBudget)
SduiSharedUtilities.useEntrySurfacing = require(script.hooks.useEntrySurfacing)
SduiSharedUtilities.useInputData = require(script.hooks.useInputData)
SduiSharedUtilities.useSduiPageScopeField = require(script.hooks.useSduiPageScopeField)
SduiSharedUtilities.useUiStatus = require(script.hooks.useUiStatus)
local SduiIntegrationTypes3 = require(script.SduiIntegrationTypes)
SduiSharedUtilities.UiStatus = SduiIntegrationTypes3.UiStatus
SduiSharedUtilities.SduiProtobufResponseHelpers = require(script.SduiProtobufResponseHelpers)
SduiSharedUtilities.SduiPageAnalytics = require(script.SduiPageAnalytics)
SduiSharedUtilities.SduiRequestConcurrencyPolicy = SduiRequestConcurrencyPolicy
SduiSharedUtilities.SduiResponseType = SduiResponseType
local SduiApiStorePostConfig = require(script.SduiApiStorePostConfig)
SduiSharedUtilities.SduiApiStorePostConfigContentType = SduiApiStorePostConfig.SduiApiStorePostConfigContentType
SduiSharedUtilities.SduiOverlayEntryPoint = require(script.SduiOverlayEntryPoint)
local SduiCoreSystem = require(parent.SduiCoreSystem)
SduiSharedUtilities.getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SduiCoreSystem2 = require(parent.SduiCoreSystem)
SduiSharedUtilities.usePageScopeRef = SduiCoreSystem2.usePageScopeRef
local SduiCoreSystem3 = require(parent.SduiCoreSystem)
SduiSharedUtilities.SduiCapabilities = SduiCoreSystem3.SduiCapabilities
local SduiCoreSystem4 = require(parent.SduiCoreSystem)
SduiSharedUtilities.getSduiDataBinder = SduiCoreSystem4.getSduiDataBinder
SduiSharedUtilities.streamingFeedMergeStrategy = require(script.streamingFeedMergeStrategy)
SduiSharedUtilities.buildSduiCollectionInfo = require(script.buildSduiCollectionInfo)
SduiSharedUtilities.getPreferredTextSizeLineBudget = require(script.getPreferredTextSizeLineBudget)
return SduiSharedUtilities
