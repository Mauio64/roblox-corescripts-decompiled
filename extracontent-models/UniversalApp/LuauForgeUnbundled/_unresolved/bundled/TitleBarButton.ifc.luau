local module = require("@luauforge/bundled/ieR")
local module2 = require("@luauforge/bundled/ieN")

local view = module.View
local icon = module.Icon

local iconVariant = module.Enums.IconVariant
local controlState = module.Enums.ControlState
local useTokens = module.Hooks.useTokens

local function TitleBarButton(props)
	local v5 = useTokens()
	local state, setState = module2.useState(controlState.Default)

	local v6 = module2.useCallback(function(p2)
		setState(p2)
	end, {})

	local v7 = if state == controlState.Hover or state == controlState.Pressed then props.hoveredBackgroundStyle else props.backgroundStyle

	return module2.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(0, 0, 1, 0),
		backgroundStyle = v7,
		tag = "row align-x-center align-y-center",
		onActivated = props.onActivated,
		onStateChanged = v6,
		testId = props.testId
	}, {
		IconContainer = module2.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				ButtonIcon = module2.createElement(icon, {
					name = props.icon,
					variant = iconVariant.Regular,
					Rotation = props.iconRotation,
					size = props.iconSize,
					tag = "auto-xy content-emphasis",
					stroke = {
						Color = v5.Color.Content.Default.Color3,
						Transparency = v5.Color.Content.Default.Transparency,
						Thickness = 0.1,
						LineJoinMode = Enum.LineJoinMode.Round
					}
				})
			}
		)
	})
end

return TitleBarButton
