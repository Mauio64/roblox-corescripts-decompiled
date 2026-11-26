local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local icon = Foundation.Icon
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local useTokens = Foundation.Hooks.useTokens

local v5 = {
	{ key = "Chat", icon = iconName.Nebula },
	{ key = "Select", icon = iconName.CursorStars },
	{ key = "Capture", icon = iconName.FrameCameraCenter, isHighlighted = true },
	{ key = "Publish", icon = iconName.ArrowUpRightFromSquare }
}

local v6 = {
	bottomBar = Vector2.new(124, 220),
	sideRail = Vector2.new(220, 124),
	floating = Vector2.new(240, 170)
}

local function renderButtons()
	local children = {}

	for k, v7 in v5 do
		children[v7.key] = React.createElement(view, {
			LayoutOrder = k,
			tag = {
				["row align-x-center align-y-center size-600-600 radius-small"] = true,
				["bg-action-emphasis"] = v7.isHighlighted == true
			},
			testId = `ChatCaptureToolbarIllustration.{v7.key}`
		}, {
			Icon = React.createElement(icon, {
				name = v7.icon,
				size = iconSize.XSmall,
				tag = {
					["auto-xy"] = true,
					["content-action-emphasis"] = v7.isHighlighted == true,
					["content-default"] = v7.isHighlighted ~= true
				}
			})
		})
	end

	return children
end

local function renderEdgeBar(p2)
	local v7 = p2 == "bottomBar"
	local createElement = React.createElement

	local children = {
		RoundedBackground = React.createElement(view, {
			tag = "size-full radius-large bg-surface-100"
		}),
		SquareBackground = 0,
		Buttons = 0
	}

	local createElement2 = React.createElement
	local v12 = if v7 then UDim2.fromScale(1, 0.5) else UDim2.fromScale(0.5, 1)
	children.SquareBackground = createElement2(view, {
		Size = v12,
		tag = "position-top-left anchor-top-left bg-surface-100"
	})

	children.Buttons = React.createElement(view, {
		ZIndex = 2,
		tag = {
			["align-x-center align-y-center gap-xxsmall padding-xsmall"] = true,
			["row size-full-0 auto-y"] = v7,
			["col size-0-full auto-x"] = not v7
		}
	}, renderButtons())
	return createElement(view, {
		tag = {
			["position-bottom-center anchor-bottom-center size-full-0 auto-y"] = v7,
			["position-center-right anchor-center-right size-0-full auto-x"] = not v7
		},
		testId = v7 and "ChatCaptureToolbarIllustration.BottomBar" or "ChatCaptureToolbarIllustration.SideRail"
	}, children)
end

local function renderToolbar(p2)
	if p2 == "floating" then
		return React.createElement(
			view,
			{
				tag = "col align-x-center gap-xxsmall position-center-right anchor-center-right auto-xy padding-xxsmall radius-small bg-surface-100",
				testId = "ChatCaptureToolbarIllustration.Floating"
			},
			renderButtons()
		)
	end

	return renderEdgeBar(p2)
end

local function ChatCaptureToolbarIllustration(p2)
	local v7 = useTokens()
	local v8 = v6[p2.layout] * v7.Config.UI.Scale

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = p2.LayoutOrder,
		tag = "row align-x-center size-full-0 auto-y",
		testId = "ChatCaptureToolbarIllustration"
	}

	local createElement2 = React.createElement
	local v13 = {
		Size = UDim2.fromOffset(v8.X, v8.Y),
		tag = "stroke-thick stroke-emphasis radius-large clip bg-shift-200",
		testId = "ChatCaptureToolbarIllustration.Device"
	}

	local createElement3 = React.createElement
	local v16 = {
		tag = {
			["size-full"] = true,
			["padding-small"] = p2.layout == "floating"
		}
	}

	local layout = p2.layout
	local v18 = if layout == "floating" then React.createElement(
		view,
		{
			tag = "col align-x-center gap-xxsmall position-center-right anchor-center-right auto-xy padding-xxsmall radius-small bg-surface-100",
			testId = "ChatCaptureToolbarIllustration.Floating"
		},
		renderButtons()
	) else renderEdgeBar(layout)

	return createElement(view, v10, {
		Device = createElement2(view, v13, {
			ToolbarArea = createElement3(view, v16, { Toolbar = v18 })
		})
	})
end

return ChatCaptureToolbarIllustration
