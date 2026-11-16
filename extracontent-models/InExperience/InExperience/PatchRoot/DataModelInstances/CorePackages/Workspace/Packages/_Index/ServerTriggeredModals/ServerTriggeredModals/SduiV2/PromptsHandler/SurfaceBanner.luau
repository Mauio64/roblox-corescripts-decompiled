local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AppNavBar = require(parent.AppNavBar)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SignalsReact = require(parent.SignalsReact)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local View = Foundation.View
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local useComponentConfig = SduiSharedUtilities.useComponentConfig
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local VisibilityControl = AppNavBar.VisibilityControl
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)

local function noopGetter(): nil
	return nil
end

local function SurfaceBanner(props)
	local v = useStatusBarHeight()
	local v2 = useTopBarHeight()
	local state, setState = React.useState(0)
	local headerBinding = VisibilityControl.getHeaderBinding()

	local v3 = props.identifier ~= nil
	local v4 = useComponentConfig(props.configKey, props.identifier)

	if not v3 then
		v4 = nil
	end

	local backgroundStyle

	if v4 and v4.props then
		backgroundStyle = v4.props.backgroundStyle
	end

	local v5

	if v4 and v4.propSignals and v4.propSignals.backgroundStyle then
		v5 = v4.propSignals.backgroundStyle
	else
		v5 = noopGetter
	end

	local v6 = SignalsReact.useSignalState(v5)

	if backgroundStyle == nil then
		backgroundStyle = if v6 ~= nil then v6.data else nil
	end

	local mapped = headerBinding:map(function(p: number)
		return UDim2.new(0, 0, 0, (math.max(v, p * v2)))
	end)

	local mapped2 = headerBinding:map(function(p: number)
		return UDim2.new(1, 0, 0, (math.max(0, v - p * v2)))
	end)

	local surfaceBannerContent = props.surfaceBannerContent
	local canvasTopPadding = surfaceBannerContent
		and surfaceBannerContent.props
		and surfaceBannerContent.props.canvasTopPadding
		or 0
	local content

	if surfaceBannerContent then
		content = React.cloneElement(surfaceBannerContent, {
			canvasTopPadding = canvasTopPadding + state
		})
	end

	local createElement = React.createElement
	local filler

	if v3 then
		filler = React.createElement(View, {
			backgroundStyle = backgroundStyle,
			AnchorPoint = Vector2.new(0, 1),
			Position = mapped,
			Size = mapped2,
			ZIndex = 2
		})
	end

	local createElement2 = React.createElement
	local v7 = {
		Position = mapped,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 2,
		onAbsoluteSizeChanged = function(p)
			setState(p.AbsoluteSize.Y)
		end
	}
	local surfaceBanner

	if v3 then
		local createElement3 = React.createElement
		local v8 = {
			configKey = props.configKey,
			identifier = props.identifier,
			appPage = props.appPage,
			additionalAnalyticsData = 0,
			shouldDisplayLoading = false,
			shouldDisplayError = false
		}
		local additionalAnalyticsData

		if FFlagPromptsActionEventLogging then
			additionalAnalyticsData = { promptInstanceId = 0 }
			local promptInstanceId

			if props.identifier then
				promptInstanceId = props.identifier
			end

			additionalAnalyticsData.promptInstanceId = promptInstanceId
		end

		v8.additionalAnalyticsData = additionalAnalyticsData
		surfaceBanner = createElement3(SduiFeatureEntryPoint, v8)
	end

	return createElement(View, { tag = "size-full" }, {
		Content = content,
		Filler = filler,
		Banner = createElement2(View, v7, { SurfaceBanner = surfaceBanner })
	})
end

return React.memo(SurfaceBanner)
