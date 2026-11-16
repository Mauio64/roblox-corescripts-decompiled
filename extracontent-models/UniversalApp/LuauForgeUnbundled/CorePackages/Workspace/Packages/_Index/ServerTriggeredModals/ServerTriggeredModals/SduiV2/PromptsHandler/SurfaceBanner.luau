local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Foundation")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/AppNavBar")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppHooks")

local view = Foundation.View
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local useComponentConfig = SduiSharedUtilities.useComponentConfig
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local visibilityControl = AppNavBar.VisibilityControl
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")

local function noopGetter(): nil
	return nil
end

local function SurfaceBanner(props)
	local v5 = useStatusBarHeight()
	local v6 = useTopBarHeight()
	local state, setState = React.useState(0)
	local headerBinding = visibilityControl.getHeaderBinding()

	local v7 = props.identifier ~= nil
	local v8 = useComponentConfig(props.configKey, props.identifier)

	if not v7 then
		v8 = nil
	end

	local v9 = if v8 and v8.props then v8.props.backgroundStyle else nil
	local v10

	if v8 and v8.propSignals and v8.propSignals.backgroundStyle then
		v10 = v8.propSignals.backgroundStyle
	else
		v10 = noopGetter
	end

	local v11 = SignalsReact.useSignalState(v10)

	if v9 == nil then
		v9 = if v11 ~= nil then v11.data else nil
	end

	local mapped = headerBinding:map(function(p2)
		return UDim2.new(0, 0, 0, (math.max(v5, p2 * v6)))
	end)

	local mapped2 = headerBinding:map(function(p2)
		return UDim2.new(1, 0, 0, (math.max(0, v5 - p2 * v6)))
	end)

	local surfaceBannerContent = props.surfaceBannerContent
	local canvasTopPadding = surfaceBannerContent
		and surfaceBannerContent.props
		and surfaceBannerContent.props.canvasTopPadding
		or 0
	local v12

	if surfaceBannerContent then
		v12 = React.cloneElement(surfaceBannerContent, {
			canvasTopPadding = canvasTopPadding + state
		})
	end

	local createElement = React.createElement

	local v16 = if v7 then React.createElement(view, {
		backgroundStyle = v9,
		AnchorPoint = Vector2.new(0, 1),
		Position = mapped,
		Size = mapped2,
		ZIndex = 2
	}) else nil

	local createElement2 = React.createElement
	local v18 = {
		Position = mapped,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 2,
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize.Y)
		end
	}
	local v20

	if v7 then
		local createElement3 = React.createElement
		local v22 = {
			configKey = props.configKey,
			identifier = props.identifier,
			appPage = props.appPage,
			additionalAnalyticsData = 0,
			shouldDisplayLoading = false,
			shouldDisplayError = false
		}
		local v23

		if FFlagPromptsActionEventLogging then
			v23 = { promptInstanceId = 0 }
			local v24 = if props.identifier then props.identifier else nil
			v23.promptInstanceId = v24
		end

		v22.additionalAnalyticsData = v23
		v20 = createElement3(sduiFeatureEntryPoint, v22)
	end

	return createElement(view, { tag = "size-full" }, {
		Content = v12,
		Filler = v16,
		Banner = createElement2(view, v18, { SurfaceBanner = v20 })
	})
end

return React.memo(SurfaceBanner)
