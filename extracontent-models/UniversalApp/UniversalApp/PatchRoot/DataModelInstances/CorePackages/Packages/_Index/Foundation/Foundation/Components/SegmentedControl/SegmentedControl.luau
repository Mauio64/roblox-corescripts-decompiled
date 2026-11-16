local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.ControlState)

local FillBehavior = require(Foundation.Enums.FillBehavior)

local InputSize = require(Foundation.Enums.InputSize)

local SegmentedControlVariant = require(Foundation.Enums.SegmentedControlVariant)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)
local withDefaults = require(Foundation.Utility.withDefaults)

local Segment = require(script.Parent.Segment)
local useSegmentedControlVariants = require(script.Parent.useSegmentedControlVariants)

local Flags = require(Foundation.Utility.Flags)

local v = {
	size = InputSize.Medium,
	variant = SegmentedControlVariant.Filled,
	fillBehavior = FillBehavior.Fit,
	testId = "--foundation-segmented-control",
	ZIndex = 1
}

local function SegmentedControl(p, p2)
	local v2 = withDefaults(p, v)
	local variant

	if Flags.FoundationSegmentedControlBeta then
		variant = v2.variant
	else
		variant = nil
	end

	local fillBehavior

	if Flags.FoundationSegmentedControlBeta then
		fillBehavior = v2.fillBehavior
	else
		fillBehavior = nil
	end

	local v3 = useTokens()

	local size = v2.size
	local v4

	if Flags.FoundationSegmentedControlBeta then
		v4 = variant
	end

	local v5

	if Flags.FoundationSegmentedControlBeta then
		v5 = fillBehavior
	end

	local v6 = useSegmentedControlVariants(v3, size, v4, v5, v2.isCircular)
	local v7

	if Flags.FoundationSegmentedControlBeta then
		v7 = fillBehavior == FillBehavior.Fill
	end

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})
	local v8 = React.useMemo(function()
		local current = ref2.current

		for _, segment in v2.segments do
			if segment.ref then
				current[segment.id] = segment.ref
			elseif not current[segment.id] then
				current[segment.id] = React.createRef()
			end
		end

		return current
	end, { v2.segments })

	local value = v2.value
	local size2

	if Flags.FoundationSegmentedControlBeta then
		size2 = v2.size
	end

	local v9

	if Flags.FoundationSegmentedControlBeta then
		v9 = fillBehavior
	end

	local v10 = useAnimatedHighlight(value, p2 or ref, v8, size2, v9)

	local activeItemHeight = v10.activeItemHeight
	local highlightPosition = v10.highlightPosition
	local highlightWidth = v10.highlightWidth
	local v11, v12 = React.useBinding(Vector2.new(0, 0))

	local v13 = React.useCallback(function(p3)
		v12(p3.AbsoluteSize)
	end, { v6.container.tag })

	local onAbsoluteSizeChanged = React.useCallback(function(p3)
		if v2.onAbsoluteSizeChanged then
			v2.onAbsoluteSizeChanged(p3)
		end

		v13(p3)
	end, { v2.onAbsoluteSizeChanged, v13 })

	local v14 = React.useCallback(function(p3)
		local v14 = 0

		if p3.current then
			local current = v8[v2.value].current

			if current then
				return current.AbsolutePosition.Y - p3.current.AbsolutePosition.Y
			end
		end

		return v14
	end, { v2.value })

	local createElement = React.createElement

	local v15 = {
		tag = Flags.FoundationSegmentedControlBeta and v7 and "size-full-0 auto-y" or nil,
		Size = 0
	}
	local size3

	if Flags.FoundationSegmentedControlBeta then
		if not v7 then
			size3 = v11:map(function(vector2: Vector2)
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end)
		end
	else
		size3 = v11:map(function(vector2: Vector2)
			return UDim2.fromOffset(vector2.X, vector2.Y)
		end)
	end

	v15.Size = size3
	local v16 = withCommonProps(v2, v15)

	local createElement2 = React.createElement

	local v17 = { tag = v6.container.tag, stroke = 0, ref = 0, testId = 0 }
	local stroke

	if Flags.FoundationSegmentedControlBeta then
		stroke = v6.container.stroke
	end

	v17.stroke = stroke
	v17.ref = p2 or ref
	v17.testId = `{v2.testId}--segments-container`
	local children = {
		SegmentsContainer = createElement2(
			View,
			withDefaults(v17, { onAbsoluteSizeChanged = onAbsoluteSizeChanged }),
			Dash.map(v2.segments, function(props, p3: number)
				local layoutOrder = (p3 - 1) * 2 + 1
				local createElement3 = React.createElement
				local fragment = React.Fragment
				local v18 = { key = tostring(props.id) }

				local createElement4 = React.createElement
				local v19 = {
					id = props.id,
					size = v2.size,
					variant = 0,
					fillBehavior = 0,
					isCircular = 0,
					text = 0,
					icon = 0,
					isActive = 0,
					onActivated = 0,
					LayoutOrder = 0,
					testId = 0,
					ref = 0
				}
				local variant2

				if Flags.FoundationSegmentedControlBeta then
					variant2 = variant
				end

				v19.variant = variant2
				local fillBehavior2

				if Flags.FoundationSegmentedControlBeta then
					fillBehavior2 = fillBehavior
				end

				v19.fillBehavior = fillBehavior2
				v19.isCircular = v2.isCircular
				v19.text = props.text
				v19.icon = props.icon
				v19.isActive = props.id == v2.value
				v19.onActivated = v2.onActivated
				v19.LayoutOrder = layoutOrder
				v19.testId = `{v2.testId}--segment-{props.id}`
				v19.ref = v8[props.id]
				return createElement3(fragment, v18, { Segment = createElement4(Segment, v19) })
			end)
		),
		Overlay = 0
	}

	local createElement3 = React.createElement
	local v18 = {
		tag = v6.segment.tag,
		backgroundStyle = 0,
		Size = 0,
		Position = 0,
		ZIndex = 0,
		testId = 0
	}
	local backgroundStyle

	if Flags.FoundationSegmentedControlBeta then
		backgroundStyle = v3.Color.Shift.Shift_300
	else
		backgroundStyle = v3.Color.Shift.Shift_400
	end

	v18.backgroundStyle = backgroundStyle

	v18.Size = React.joinBindings({ highlightWidth, activeItemHeight }):map(function(list)
		return UDim2.fromOffset(list[1], list[2])
	end)

	v18.Position = highlightPosition:map(function(p3: number)
		local v19 = v14(p2 or ref)
		return UDim2.fromOffset(p3, v19)
	end)

	v18.ZIndex = v2.ZIndex + 1
	v18.testId = `{v2.testId}--animated-overlay`
	children.Overlay = createElement3(View, v18)
	return createElement(View, v16, children)
end

return React.memo(React.forwardRef(SegmentedControl))
