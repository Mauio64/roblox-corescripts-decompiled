local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiComponentWrapper

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local useCreateClientBindingSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/useCreateClientBindingSduiContext")
local useComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentConfig")
local useComponentLifecycleTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentLifecycleTiming")
local useDataUpdatedTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useDataUpdatedTimestamp")
local useLocalAnalyticsData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useLocalAnalyticsData")
local useUiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useUiStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
local useStatefulRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useStatefulRef")
local SduiFeatureEntryPointUi = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/ui/SduiFeatureEntryPointUi")

local fFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler

local function SduiFeatureEntryPoint(props, p2)
	local configKey = props.configKey
	local appPage = props.appPage
	local v5 = props.shouldDisplayLoading == nil or props.shouldDisplayLoading
	local v6 = props.shouldDisplayError == nil or props.shouldDisplayError

	local v7 = useComponentConfig(configKey, props.identifier)

	useComponentLifecycleTiming(props.loadTimer, typeof(v7) == "table")

	local v8 = useDataUpdatedTimestamp(configKey, props.identifier)

	local v9 = useUiStatus(configKey)

	local v10, v11 = useStatefulRef(p2)

	local v12 = useCreateClientBindingSduiContext(
		appPage,
		v10,
		nil,
		v8,
		configKey,
		props.appCompositionEnabledOverride,
		props.routeName
	)

	local v13 = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)

	local createElement = React.createElement
	local v15 = {
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

	local v16 = if v7 then React.createElement(getSduiComponentWrapper(v7), {
		debugName = `SduiFeatureEntryPoint-{configKey}`,
		componentConfig = v7,
		sduiContext = v12,
		localAnalyticsData = v13,
		extraLocalProps = props.extraLocalProps
	}) else nil
	v15.contentSlot = v16

	v15.uiStatus = v9
	v15.errorSlot = props.errorSlot
	v15.loadingSlot = props.loadingSlot
	v15.shouldDisplayLoading = v5
	v15.shouldDisplayError = v6

	local v17 = if fFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then props.onAbsoluteSizeChange else nil
	v15.onAbsoluteSizeChange = v17

	local v18 = if props.Size then props.Size else UDim2.new(1, 0, 0, 0)
	v15.Size = v18
	local v19 = if props.AutomaticSize then props.AutomaticSize else Enum.AutomaticSize.Y
	v15.AutomaticSize = v19
	v15.Position = props.Position
	v15.LayoutOrder = props.LayoutOrder
	v15.ref = v11
	return createElement(SduiFeatureEntryPointUi, v15)
end

return React.memo(React.forwardRef(SduiFeatureEntryPoint))
