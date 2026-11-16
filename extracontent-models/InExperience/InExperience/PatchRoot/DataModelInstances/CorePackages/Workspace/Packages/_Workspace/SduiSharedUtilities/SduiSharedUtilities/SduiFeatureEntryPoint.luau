local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

require(SduiSharedUtilities.SduiLoadTimer)
local useCreateClientBindingSduiContext = require(SduiSharedUtilities.useCreateClientBindingSduiContext)
local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useComponentLifecycleTiming = require(SduiSharedUtilities.hooks.useComponentLifecycleTiming)
local useDataUpdatedTimestamp = require(SduiSharedUtilities.hooks.useDataUpdatedTimestamp)
local useLocalAnalyticsData = require(SduiSharedUtilities.hooks.useLocalAnalyticsData)
local useUiStatus = require(SduiSharedUtilities.hooks.useUiStatus)
require(SduiSharedUtilities.SduiIntegrationTypes)
local useStatefulRef = require(SduiSharedUtilities.hooks.useStatefulRef)
local SduiFeatureEntryPointUi = require(SduiSharedUtilities.ui.SduiFeatureEntryPointUi)

local SharedFlags = require(parent.SharedFlags)

local FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = SharedFlags.FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler

local function SduiFeatureEntryPoint(props, p)
	local configKey = props.configKey
	local appPage = props.appPage
	local shouldDisplayLoading = props.shouldDisplayLoading == nil or props.shouldDisplayLoading
	local shouldDisplayError = props.shouldDisplayError == nil or props.shouldDisplayError

	local componentConfig = useComponentConfig(configKey, props.identifier)

	useComponentLifecycleTiming(props.loadTimer, typeof(componentConfig) == "table")

	local v = useDataUpdatedTimestamp(configKey, props.identifier)

	local uiStatus = useUiStatus(configKey)

	local v2, ref = useStatefulRef(p)

	local sduiContext = useCreateClientBindingSduiContext(
		appPage,
		v2,
		nil,
		v,
		configKey,
		props.appCompositionEnabledOverride,
		props.routeName
	)

	local localAnalyticsData = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)

	local createElement = React.createElement
	local v3 = {
		onRetry = props.onRetry,
		contentSlot = 0,
		uiStatus = 0,
		errorSlot = 0,
		loadingSlot = 0,
		shouldDisplayLoading = 0,
		shouldDisplayError = 0,
		onAbsoluteSizeChange = 0,
		Size = 0,
		AutomaticSize = 0,
		Position = 0,
		LayoutOrder = 0,
		ref = 0
	}
	local contentSlot

	if componentConfig then
		contentSlot = React.createElement(getSduiComponentWrapper(componentConfig), {
			debugName = `SduiFeatureEntryPoint-{configKey}`,
			componentConfig = componentConfig,
			sduiContext = sduiContext,
			localAnalyticsData = localAnalyticsData,
			extraLocalProps = props.extraLocalProps
		})
	end

	v3.contentSlot = contentSlot

	v3.uiStatus = uiStatus
	v3.errorSlot = props.errorSlot
	v3.loadingSlot = props.loadingSlot
	v3.shouldDisplayLoading = shouldDisplayLoading
	v3.shouldDisplayError = shouldDisplayError
	local onAbsoluteSizeChange

	if FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then
		onAbsoluteSizeChange = props.onAbsoluteSizeChange
	end

	v3.onAbsoluteSizeChange = onAbsoluteSizeChange
	local size

	if props.Size then
		size = props.Size
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	v3.Size = size
	local automaticSize

	if props.AutomaticSize then
		automaticSize = props.AutomaticSize
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	v3.AutomaticSize = automaticSize
	v3.Position = props.Position
	v3.LayoutOrder = props.LayoutOrder
	v3.ref = ref
	return createElement(SduiFeatureEntryPointUi, v3)
end

return React.memo(React.forwardRef(SduiFeatureEntryPoint))
