local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)

require(SduiSharedUtilitiesParent.Foundation)

local DataHydration = require(SduiSharedUtilitiesParent.DataHydration)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiComponentWrapper = require(SduiSharedUtilitiesParent.SduiCoreSystem).getSduiComponentWrapper
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)

require(SduiSharedUtilities.SduiLoadTimer)

local useCreateClientBindingSduiContext = require(SduiSharedUtilities.useCreateClientBindingSduiContext)
local DataHydrationTypes = DataHydration.DataHydrationTypes
local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useComponentLifecycleTiming = require(SduiSharedUtilities.hooks.useComponentLifecycleTiming)
local useDataUpdatedTimestamp = require(SduiSharedUtilities.hooks.useDataUpdatedTimestamp)
local useLocalAnalyticsData = require(SduiSharedUtilities.hooks.useLocalAnalyticsData)
local useUiStatus = require(SduiSharedUtilities.hooks.useUiStatus)

require(SduiSharedUtilities.SduiIntegrationTypes)

local useStatefulRef = require(SduiSharedUtilities.hooks.useStatefulRef)
local SduiFeatureEntryPointUi = require(SduiSharedUtilities.ui.SduiFeatureEntryPointUi)
local SharedFlags = require(SduiSharedUtilitiesParent.SharedFlags)
local FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = SharedFlags.FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler
local FFlagSduiUseSharedUiStatusHook = SharedFlags.FFlagSduiUseSharedUiStatusHook
local FFlagSduiClientPageScope = SharedFlags.FFlagSduiClientPageScope

local function useUiStatusLegacy(p1) -- line: 32
	-- upvalues: SignalsReact (copy), getSduiApiStore (copy), DataHydrationTypes (copy)
	local v24 = SignalsReact.useSignalState(getSduiApiStore().getData(p1).status)

	if v24 == DataHydrationTypes.DataStatus.NotReady then
		return "Loading"
	end

	if v24 == DataHydrationTypes.DataStatus.Failed then
		return "Error"
	end

	return "Resolved"
end
local function SduiFeatureEntryPoint(t1: {[any]: any}, p2) -- line: 82
	-- upvalues: useComponentConfig (copy), useComponentLifecycleTiming (copy), useDataUpdatedTimestamp (copy), FFlagSduiUseSharedUiStatusHook (copy), useUiStatus (copy), SignalsReact (copy), getSduiApiStore (copy), DataHydrationTypes (copy), useStatefulRef (copy), useCreateClientBindingSduiContext (copy), FFlagSduiClientPageScope (copy), useLocalAnalyticsData (copy), React (copy), SduiFeatureEntryPointUi (copy), getSduiComponentWrapper (copy), FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler (copy)
	local configKey = t1.configKey
	local appPage = t1.appPage
	local v29 = t1.shouldDisplayLoading == nil or t1.shouldDisplayLoading
	local v30 = t1.shouldDisplayError == nil or t1.shouldDisplayError
	local v31 = useComponentConfig(configKey, t1.identifier)

	useComponentLifecycleTiming(t1.loadTimer, typeof(v31) == "table")

	local v32 = useDataUpdatedTimestamp(configKey, t1.identifier)
	local v33

	if FFlagSduiUseSharedUiStatusHook then
		v33 = useUiStatus(configKey)
	else
		local v34 = SignalsReact.useSignalState(getSduiApiStore().getData(configKey).status)

		v33 = if v34 ~= DataHydrationTypes.DataStatus.NotReady then v34 ~= DataHydrationTypes.DataStatus.Failed and "Resolved" or "Error" else "Loading"
	end

	local v35, v36 = useStatefulRef(p2)
	local v37 = useCreateClientBindingSduiContext(appPage, v35, nil, v32, if not FFlagSduiClientPageScope then nil else configKey, t1.appCompositionEnabledOverride, t1.routeName)
	local v38 = useLocalAnalyticsData(configKey, appPage, t1.additionalAnalyticsData)

	return React.createElement(SduiFeatureEntryPointUi, {
		onRetry = t1.onRetry,
		contentSlot = if not v31 then nil else React.createElement(getSduiComponentWrapper(v31), {
			debugName = `SduiFeatureEntryPoint-{ configKey }`,
			componentConfig = v31,
			sduiContext = v37,
			localAnalyticsData = v38,
			extraLocalProps = t1.extraLocalProps
		}),
		uiStatus = v33,
		errorSlot = t1.errorSlot,
		loadingSlot = t1.loadingSlot,
		shouldDisplayLoading = v29,
		shouldDisplayError = v30,
		onAbsoluteSizeChange = if not FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then nil else t1.onAbsoluteSizeChange,
		Size = if not t1.Size then UDim2.new(1, 0, 0, 0) else t1.Size,
		AutomaticSize = if not t1.AutomaticSize then Enum.AutomaticSize.Y else t1.AutomaticSize,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder,
		ref = v36
	})
end

return React.memo(React.forwardRef(SduiFeatureEntryPoint))
