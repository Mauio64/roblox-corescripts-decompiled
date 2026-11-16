local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Icon = BuilderIcons.Icon

local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local ScrollView = require(Foundation.Components.ScrollView)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local Visibility = require(Foundation.Enums.Visibility)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.8, 0),
	NumberSequenceKeypoint.new(1, 1)
})

local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.2, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function OverflowButton(props)
	local createElement = React.createElement

	local v = withCommonProps(props, {
		tag = `col align-y-center size-0-full auto-x bg-surface-0 {props.tag}`
	})

	local v2 = {
		UIGradient = React.createElement("UIGradient", { Transparency = props.gradient }),
		Button = 0
	}

	local createElement2 = React.createElement
	local v3 = { onActivated = props.onActivated, size = 0, icon = 0 }
	local size

	if props.size == InputSize.Large or props.size == InputSize.Medium then
		size = InputSize.Small
	else
		size = InputSize.XSmall
	end

	v3.size = size

	v3.icon = { name = props.icon }
	v2.Button = createElement2(IconButton, v3)
	return createElement(View, v, v2)
end

local function OverflowScrollContainer(props)
	local visible, v = React.useBinding(false)
	local visible2, v2 = React.useBinding(false)
	local ref = React.useRef(nil)
	local v3 = ReactOtter.useMotor(0, function(p)
		local current = ref.current

		if not current then
			return
		end

		current.CanvasPosition = Vector2.new(p, 0)
	end)

	local v4 = React.useCallback(Dash.throttle(function(data)
		if data.AbsoluteWindowSize.X == 0 then
			return
		end

		v(data.AbsoluteWindowSize.X + data.CanvasPosition.X < data.AbsoluteCanvasSize.X - 1)
		v2(data.CanvasPosition.X ~= 0)
	end, 0.2), {})

	local v5 = React.useCallback(function(p: number)
		local current = ref.current

		if not current then
			return
		end

		v3(Otter.ease(current.CanvasPosition.X + p, {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, {})

	React.useEffect(function()
		if ref.current then
			v4(ref.current)
		end
	end, {})

	local onActivated = React.useCallback(function()
		v5(-90)
	end, { v5 })

	local onActivated2 = React.useCallback(function()
		v5(90)
	end, { v5 })

	return React.createElement(View, withCommonProps(props, {
		tag = "auto-y",
		Size = UDim2.fromScale(1, 0)
	}), {
		Scroll = React.createElement(ScrollView, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			onCanvasPositionChanged = v4,
			onAbsoluteWindowSizeChanged = v4,
			scrollingFrameRef = ref,
			selection = { Selectable = false },
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Visibility.None
			}
		}, props.children),
		OverflowStart = React.createElement(OverflowButton, {
			LayoutOrder = 3,
			Position = UDim2.fromScale(0, 0),
			size = props.size,
			isStart = true,
			ZIndex = 2,
			Visible = visible2,
			onActivated = onActivated,
			gradient = numberSequence,
			tag = "padding-right-small",
			icon = Icon.ChevronLargeLeft,
			testId = `{props.testId}--overflow-start`
		}),
		OverflowEnd = React.createElement(OverflowButton, {
			LayoutOrder = 4,
			Position = UDim2.fromScale(1, 0),
			size = props.size,
			ZIndex = 2,
			Visible = visible,
			onActivated = onActivated2,
			gradient = numberSequence2,
			tag = "anchor-top-right padding-left-small",
			icon = Icon.ChevronLargeRight,
			testId = `{props.testId}--overflow-end`
		})
	})
end

return OverflowScrollContainer
