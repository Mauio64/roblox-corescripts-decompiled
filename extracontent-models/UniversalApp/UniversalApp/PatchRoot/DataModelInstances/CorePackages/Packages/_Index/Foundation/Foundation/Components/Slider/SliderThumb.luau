local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)

local withCommonProps = require(Foundation.Utility.withCommonProps)

local Knob = require(Foundation.Components.Knob)
local View = require(Foundation.Components.View)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)

require(Foundation.Enums.InputSize)

local calculateSliderFraction = require(script.Parent.calculateSliderFraction)
local getGuiInputPosition = require(script.Parent.getGuiInputPosition)

local v = { colorNamespace = ColorNamespace.Inverse }

local function SliderThumb(props)
	local ref = React.useRef(props.fraction:getValue())

	local v2 = React.useCallback(function()
		ref.current = props.fraction:getValue()

		if props.onDragStarted then
			props.onDragStarted()
		end
	end, { props.fraction, props.onDragStarted })

	local v3 = React.useCallback(function(_, vector2: Vector2)
		local current = props.trackRef.current

		if not current then
			return
		end

		local v3 = calculateSliderFraction(getGuiInputPosition(vector2, current), current, props.isVertical)
		local bounds, v4 = props.getBounds()
		local current2 = math.clamp(v3, bounds, v4)

		if current2 ~= ref.current then
			ref.current = current2
			props.onSeek(current2)
		end
	end, { props.trackRef, props.isVertical, props.getBounds, props.onSeek })

	local v4 = React.useCallback(function()
		if props.onDragEnded then
			props.onDragEnded()
		end
	end, { props.onDragEnded })

	local mapped = props.fraction:map(function(p: number)
		if props.isVertical then
			return (UDim2.fromScale(0.5, 1 - p))
		end

		return (UDim2.fromScale(p, 0.5))
	end)
	local v5

	if props.isContained then
		v5 = props.fraction:map(function(p: number)
			if props.isVertical then
				return (Vector2.new(0.5, 1 - p))
			end

			return (Vector2.new(p, 0.5))
		end)
	else
		v5 = Vector2.new(0.5, 0.5)
	end

	local knob

	if props.knobAppearance then
		knob = React.createElement(Knob, {
			size = props.knobAppearance.size,
			style = props.knobAppearance.style,
			stroke = props.knobAppearance.stroke,
			hasShadow = props.knobAppearance.hasShadow,
			testId = `{props.testId}--knob`
		})
	end

	local v6 = {
		AnchorPoint = props.AnchorPoint or v5,
		Position = props.Position or mapped,
		ZIndex = props.ZIndex or 2,
		Visible = props.Visible,
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = props.onAbsolutePositionChanged,
		testId = props.testId
	}

	local createElement = React.createElement

	local v7 = withCommonProps(v6, { tag = "size-0-0 auto-xy" })

	local createElement2 = React.createElement
	local v8 = { tag = "size-full", ZIndex = 2, testId = `{props.testId}--drag-target` }
	local dragDetector

	if props.isDragEnabled ~= false then
		dragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v2,
			[React.Event.DragContinue] = v3,
			[React.Event.DragEnd] = v4,
			Enabled = not props.isDisabled
		})
	end

	local v9 = {
		DragTarget = createElement2(View, v8, { DragDetector = dragDetector }),
		Knob = 0
	}
	local knob2

	if props.knob then
		knob2 = React.createElement(
			View,
			{ tag = "size-0-0 auto-xy", testId = `{props.testId}--custom-knob` },
			props.knob
		)
	else
		knob2 = React.createElement(PresentationContext.Provider, { value = v }, { Knob = knob })
	end

	v9.Knob = knob2
	return createElement(View, v7, v9)
end

return SliderThumb
