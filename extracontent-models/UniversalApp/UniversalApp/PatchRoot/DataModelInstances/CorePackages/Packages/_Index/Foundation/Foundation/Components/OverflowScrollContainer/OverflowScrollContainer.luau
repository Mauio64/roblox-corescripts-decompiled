local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local ControlState = require(Foundation.Enums.ControlState)
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)
local Scrim = require(script.Parent.Scrim)
local ScrollView = require(Foundation.Components.ScrollView)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local Visibility = require(Foundation.Enums.Visibility)
local useClippingRect = require(script.Parent.useClippingRect)
local usePreferredInput = require(Foundation.Utility.usePreferredInput)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	size = InputSize.Medium,
	scrimBottomInset = 0,
	testId = "--foundation-overflow-scroll-container"
}

local function OverflowScrollContainer(p, ref2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local forceHovered = v2.forceHovered or state3 or state4 or state5
	local v4 = usePreferredInput()
	local forcePreferredInput = v2.forcePreferredInput or v4
	local ref = React.useRef(nil)
	local v5, v6 = useClippingRect(ref)

	local rowHeight, v7 = React.useBinding(0)

	local v8 = ReactOtter.useMotor(0, function(p2)
		local current = ref.current

		if not current then
			return
		end

		current.CanvasPosition = Vector2.new(p2, 0)
	end)

	local v9 = React.useCallback(function(data)
		v7(data.AbsoluteWindowSize.Y)

		if data.AbsoluteWindowSize.X == 0 then
			return
		end

		setState2(data.CanvasPosition.X > 0)
		setState(data.AbsoluteWindowSize.X + data.CanvasPosition.X < data.AbsoluteCanvasSize.X - 1)
	end, {})

	local v10 = React.useCallback(function(p2: number)
		local current = ref.current

		if not current then
			return
		end

		local v10 = math.max(current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X, 0)
		local v11 = current.AbsoluteWindowSize.X * 0.8
		local v12 = current.AbsoluteWindowSize.X * 0.19999999999999996
		local v13 = current.CanvasPosition.X + p2 * v11
		local v14

		if p2 > 0 and v10 - v13 <= v12 then
			v14 = v10
		else
			v14 = p2 < 0 and v13 <= v12 and 0 or v13
		end

		local v15 = math.clamp(v14, 0, v10)
		v8(Otter.ease(v15, {
			duration = v3.Time.Time_200,
			easingStyle = Enum.EasingStyle.Quad,
			startingValue = current.CanvasPosition.X
		}))
	end, { v3 })

	local onActivated = React.useCallback(function()
		v10(-1)
	end, { v10 })

	local onActivated2 = React.useCallback(function()
		v10(1)
	end, { v10 })

	local onStateChanged = React.useCallback(function(p2)
		setState3(p2 == ControlState.Hover or p2 == ControlState.Pressed)
	end, {})

	local onStateChanged2 = React.useCallback(function(p2)
		setState4(p2 == ControlState.Hover or p2 == ControlState.Pressed)
	end, {})

	local onStateChanged3 = React.useCallback(function(p2)
		setState5(p2 == ControlState.Hover or p2 == ControlState.Pressed)
	end, {})

	React.useEffect(function()
		if ref.current then
			v9(ref.current)
		end
	end, {})

	local createElement = React.createElement

	local v11 = withCommonProps(v2, { ref = ref2, tag = "size-full-0 auto-y" })

	local createElement2 = React.createElement
	local clipsDescendants

	if Flags.FoundationUnifiedScrimScrolling then
		clipsDescendants = not v6
	else
		clipsDescendants = false
	end

	return createElement(View, v11, {
		Scroll = createElement2(ScrollView, {
			tag = "size-full-0 auto-y",
			ClipsDescendants = clipsDescendants,
			onStateChanged = onStateChanged,
			stateLayer = { affordance = StateLayerAffordance.None },
			onCanvasPositionChanged = v9,
			onAbsoluteCanvasSizeChanged = v9,
			onAbsoluteWindowSizeChanged = v9,
			scrollingFrameRef = ref,
			selection = { Selectable = false },
			layout = { FillDirection = Enum.FillDirection.Horizontal },
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromScale(0, 1),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Visibility.None
			},
			testId = `{v2.testId}--scroll`
		}, v2.children),
		ScrimLayer = React.createElement(View, {
			tag = "row flex-between",
			Position = v5:map(function(rect: Rect)
				return UDim2.fromOffset(rect.Min.X, 0)
			end),
			Size = v5:map(function(rect: Rect)
				return UDim2.new(0, rect.Max.X - rect.Min.X, 1, -v2.scrimBottomInset)
			end),
			ZIndex = 2,
			testId = `{v2.testId}--scrim-layer`
		}, {
			ScrimStart = React.createElement(Scrim, {
				LayoutOrder = 1,
				size = v2.size,
				rowHeight = rowHeight,
				alignment = Enum.HorizontalAlignment.Left,
				isHovered = forceHovered,
				preferredInput = forcePreferredInput,
				isVisible = v2.forceScrimsVisible or state2,
				onActivated = onActivated,
				onStateChanged = onStateChanged2,
				testId = `{v2.testId}--scrim-start`
			}),
			ScrimEnd = React.createElement(Scrim, {
				LayoutOrder = 2,
				size = v2.size,
				rowHeight = rowHeight,
				alignment = Enum.HorizontalAlignment.Right,
				isHovered = forceHovered,
				preferredInput = forcePreferredInput,
				isVisible = v2.forceScrimsVisible or state,
				onActivated = onActivated2,
				onStateChanged = onStateChanged3,
				testId = `{v2.testId}--scrim-end`
			})
		})
	})
end

return React.memo(React.forwardRef(OverflowScrollContainer))
