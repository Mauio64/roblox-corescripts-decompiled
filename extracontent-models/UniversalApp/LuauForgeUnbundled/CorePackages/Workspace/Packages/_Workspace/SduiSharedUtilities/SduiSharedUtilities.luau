local sduiResponseType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").SduiResponseType
local sduiRequestConcurrencyPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").SduiRequestConcurrencyPolicy
local SduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local SduiSurfaceLoadTimeTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiSurfaceLoadTimeTracker")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")

local fFlagHomePageRefetchOnDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagHomePageRefetchOnDataHydrationAccountReset
local fFlagSduiApiStoreUpdateInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiApiStoreUpdateInputData

local v5 = {}

v5.SduiFocusTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/SduiFocusTags")
v5.OnNavigateBackWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/NavigateBackBindings").OnNavigateBackWrapper
function v5.useOnNavigateBack(p2, p3)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/NavigateBackBindings").useOnNavigateBack(p2, p3)
end

function v5.useInitialFocusOnTag(p2, p3)
	require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/useInitialFocusOnTag")(p2, p3)
end
function v5.useSelectionOrderTracking(p2)
	require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/useSelectionOrderTracking")(p2)
end
function v5.usePageButtonBindings(p2, p3, p4)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/usePageButtonBindings")(p2, p3, p4)
end

function v5.useBackButtonBinding(p2)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/useBackButtonBinding")(p2)
end

function v5.createSduiFocusActivationStore()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/createSduiFocusActivationStore")()
end

function v5.getSduiFocusActivationStore()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/getSduiFocusActivationStore")()
end

function v5.useSduiFocusActivation(p2, p3)
	require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/useSduiFocusActivation")(p2, p3)
end
v5.createSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createSduiApiStore")
v5.getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")

local v6 = if fFlagSduiApiStoreUpdateInputData then require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiInputDataUpdates") else nil
v5.SduiInputDataUpdates = v6

local v7 = if fFlagHomePageRefetchOnDataHydrationAccountReset then require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useDataHydrationAccountGeneration") else nil
v5.useDataHydrationAccountGeneration = v7

function v5.fetchSduiTemplates(p2, p3)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/fetchSduiTemplates")(p2, p3)
end

function v5.createTemplateApiRequestConfig(p2)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createTemplateApiRequestConfig")(p2)
end

v5.handleSduiApiResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/handleSduiApiResponse")
function v5.prewarmAppTemplatesOnLaunch()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/prewarmAppTemplatesOnLaunch")()
end

v5.SduiLoadTimer = SduiLoadTimer
v5.SduiSurfaceLoadTimeTracker = SduiSurfaceLoadTimeTracker
v5.SduiPageEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageEntryPoint")
v5.SduiPageWrapperEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageWrapperEntryPoint")
v5.SduiPageNavigationHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageNavigationHeader")
v5.useScrollAwayHeaderPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/useScrollAwayHeaderPosition")
v5.SduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiFeatureEntryPoint")
v5.getSduiTemplateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiTemplateStore")
v5.getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiPageEntrySnackbarStore")
v5.usePageEntrySnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/usePageEntrySnackbar")
v5.useComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentConfig")
v5.usePreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/usePreferredTextSizeLineBudget")
v5.usePublishContainerWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/usePublishContainerWidth")
v5.useEntrySurfacing = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useEntrySurfacing")
v5.useInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useInputData")
v5.useSduiPageScopeField = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useSduiPageScopeField")
v5.useUiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useUiStatus")
v5.UiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").UiStatus
v5.SduiProtobufResponseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiProtobufResponseHelpers")
v5.SduiPageAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageAnalytics")
v5.SduiRequestConcurrencyPolicy = sduiRequestConcurrencyPolicy
v5.SduiResponseType = sduiResponseType
v5.SduiApiStorePostConfigContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiStorePostConfig").SduiApiStorePostConfigContentType
v5.SduiOverlayEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiOverlayEntryPoint")
v5.getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiClientPageScope
v5.usePageScopeRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").usePageScopeRef
v5.SduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").SduiCapabilities
v5.getSduiDataBinder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiDataBinder
v5.streamingFeedMergeStrategy = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/streamingFeedMergeStrategy")
v5.buildSduiCollectionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/buildSduiCollectionInfo")
v5.getPreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getPreferredTextSizeLineBudget")
return v5
