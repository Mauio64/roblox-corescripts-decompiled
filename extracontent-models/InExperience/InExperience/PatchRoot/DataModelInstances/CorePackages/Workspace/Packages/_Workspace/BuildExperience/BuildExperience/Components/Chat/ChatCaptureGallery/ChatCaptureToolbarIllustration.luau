local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local useTokens = Foundation.Hooks.useTokens

local v = {
	{ key = "Chat", icon = IconName.Nebula },
	{ key = "Select", icon = IconName.CursorStars },
	{ key = "Capture", icon = IconName.FrameCameraCenter, isHighlighted = true },
	{ key = "Publish", icon = IconName.ArrowUpRightFromSquare }
}

local v2 = {
	bottomBar = Vector2.new(124, 220),
	sideRail = Vector2.new(220, 124),
	floating = Vector2.new(240, 170)
}

local function renderButtons()
	local children = {}

	for k, v3 in v do
		children[v3.key] = React.createElement(View, {
			LayoutOrder = k,
			tag = {
				["row align-x-center align-y-center size-600-600 radius-small"] = true,
				["bg-action-emphasis"] = v3.isHighlighted == true
			},
			testId = `ChatCaptureToolbarIllustration.{v3.key}`
		}, {
			Icon = React.createElement(Icon, {
				name = v3.icon,
				size = IconSize.XSmall,
				tag = {
					["auto-xy"] = true,
					["content-action-emphasis"] = v3.isHighlighted == true,
					["content-default"] = v3.isHighlighted ~= true
				}
			})
		})
	end

	return children
end

local function renderEdgeBar(p: string)
	local v3 = p == "bottomBar"
	local createElement = React.createElement

	local children = {
		RoundedBackground = React.createElement(View, {
			tag = "size-full radius-large bg-surface-100"
		}),
		SquareBackground = 0,
		Buttons = 0
	}

	local createElement2 = React.createElement
	local size

	if v3 then
		size = UDim2.fromScale(1, 0.5)
	else
		size = UDim2.fromScale(0.5, 1)
	end

	children.SquareBackground = createElement2(View, {
		Size = size,
		tag = "position-top-left anchor-top-left bg-surface-100"
	})

	children.Buttons = React.createElement(View, {
		ZIndex = 2,
		tag = {
			["align-x-center align-y-center gap-xxsmall padding-xsmall"] = true,
			["row size-full-0 auto-y"] = v3,
			["col size-0-full auto-x"] = not v3
		}
	}, renderButtons())
	return createElement(View, {
		tag = {
			["position-bottom-center anchor-bottom-center size-full-0 auto-y"] = v3,
			["position-center-right anchor-center-right size-0-full auto-x"] = not v3
		},
		testId = v3 and "ChatCaptureToolbarIllustration.BottomBar" or "ChatCaptureToolbarIllustration.SideRail"
	}, children)
end

local function renderToolbar(layout: string) -- 1 equivalent call inferred from this helper
	if layout == "floating" then
		return React.createElement(
			View,
			{
				tag = "col align-x-center gap-xxsmall position-center-right anchor-center-right auto-xy padding-xxsmall radius-small bg-surface-100",
				testId = "ChatCaptureToolbarIllustration.Floating"
			},
			renderButtons()
		)
	end

	return renderEdgeBar(layout)
end

local function ChatCaptureToolbarIllustration(p)
	local v3 = useTokens()
	local v4 = v2[p.layout] * v3.Config.UI.Scale

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "row align-x-center size-full-0 auto-y",
			testId = "ChatCaptureToolbarIllustration"
		},
		{
			Device = React.createElement(
				View,
				{
					Size = UDim2.fromOffset(v4.X, v4.Y),
					tag = "stroke-thick stroke-emphasis radius-large clip bg-shift-200",
					testId = "ChatCaptureToolbarIllustration.Device"
				},
				{
					ToolbarArea = React.createElement(View, {
						tag = {
							["size-full"] = true,
							["padding-small"] = p.layout == "floating"
						}
					}, { Toolbar = renderToolbar(p.layout) }) -- inferred equivalent call
				}
			)
		}
	)
end

return ChatCaptureToolbarIllustration
