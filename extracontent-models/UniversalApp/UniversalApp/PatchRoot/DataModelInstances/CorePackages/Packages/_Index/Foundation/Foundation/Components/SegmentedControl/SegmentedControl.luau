local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

require(Foundation.Enums.ControlState)

local InputSize = require(Foundation.Enums.InputSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)
local withDefaults = require(Foundation.Utility.withDefaults)
local Segment = require(script.Parent.Segment)
local useSegmentedControlVariants = require(script.Parent.useSegmentedControlVariants)
local Flags = require(Foundation.Utility.Flags)
local t1 = {
	testId = "--foundation-segmented-control",
	ZIndex = 1,
	size = InputSize.Medium
}

local function SegmentedControl(p1, p2) -- line: 44
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useSegmentedControlVariants (copy), Flags (copy), React (copy), useAnimatedHighlight (copy), View (copy), withCommonProps (copy), Dash (copy), Segment (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useTokens()
	local v20 = useSegmentedControlVariants(v19, v18.size, if not Flags.FoundationSegmentedControlCircular then nil else v18.isCircular)
	local u21 = React.useRef(nil)
	local u23

	if Flags.FoundationFixStaleAnimatedHighlightRefs then
		local v22 = React.useRef({})

		u23 = React.useMemo(function() -- line: 67
			-- upvalues: v22 (copy), v18 (copy), React (copy)
			local current = v22.current

			for _, v36 in v18.segments do
				if v36.ref then
					current[v36.id] = v36.ref
				elseif not current[v36.id] then
					current[v36.id] = React.createRef()
				end
			end

			return current
		end, { v18.segments })
	else
		u23 = React.useMemo(function() -- line: 79
			-- upvalues: v18 (copy), React (copy)
			local t2 = {}

			for _, v39 in v18.segments do
				t2[v39.id] = v39.ref or React.createRef()
			end

			return t2
		end, { v18.segments })
	end

	local v24 = useAnimatedHighlight(v18.value, p2 or u21, u23)
	local activeItemHeight = v24.activeItemHeight
	local highlightPosition = v24.highlightPosition
	local highlightWidth = v24.highlightWidth
	local v28, v29 = React.useBinding(Vector2.new(0, 0))
	local u30 = v29
	local u31 = React.useCallback(function(p3) -- line: 93
		-- upvalues: u30 (ref)
		u30(p3.AbsoluteSize)
	end, { v20.container.tag })
	local v32 = React.useCallback(function(p4) -- line: 97
		-- upvalues: v18 (copy), u31 (ref)
		if v18.onAbsoluteSizeChanged then
			v18.onAbsoluteSizeChanged(p4)
		end

		u31(p4)
	end, {
		v18.onAbsoluteSizeChanged,
		u31
	})
	local u33 = React.useCallback(function(t3: {[any]: any}) -- line: 104
		-- upvalues: u23 (ref), v18 (copy)
		local n1 = 0

		if t3.current then
			local current = u23[v18.value].current

			if current then
				n1 = current.AbsolutePosition.Y - t3.current.AbsolutePosition.Y
			end
		end

		return n1
	end, { v18.value })

	return React.createElement(View, withCommonProps(v18, {
		Size = v28:map(function(vector2: Vector2) -- line: 120
			return UDim2.fromOffset(vector2.X, vector2.Y)
		end)
	}), {
		SegmentsContainer = React.createElement(View, withDefaults({
			tag = v20.container.tag,
			ref = p2 or u21
		}, {
			onAbsoluteSizeChanged = v32
		}), Dash.map(v18.segments, function(p5, n2: number) -- line: 133
			-- upvalues: React (copy), Segment (copy), v18 (copy), Flags (copy), u23 (ref)
			local v48 = (n2 - 1) * 2 + 1

			return React.createElement(React.Fragment, {
				key = tostring(p5.id)
			}, {
				Segment = React.createElement(Segment, {
					id = p5.id,
					size = v18.size,
					isCircular = if not Flags.FoundationSegmentedControlCircular then nil else v18.isCircular,
					text = p5.text,
					icon = p5.icon,
					isActive = p5.id == v18.value,
					onActivated = v18.onActivated,
					LayoutOrder = v48,
					testId = `{ v18.testId }--segment-{ p5.id }`,
					ref = u23[p5.id]
				})
			})
		end)),
		Overlay = React.createElement(View, {
			testId = "--foundation-segmented-control--animated-overlay",
			backgroundStyle = v19.Color.Shift.Shift_400,
			tag = v20.segment.tag,
			Size = React.joinBindings({
				highlightWidth,
				activeItemHeight
			}):map(function(p6) -- line: 156
				return UDim2.fromOffset(p6[1], p6[2])
			end),
			Position = highlightPosition:map(function(n3: number) -- line: 159
				-- upvalues: u33 (ref), p2 (copy), u21 (ref)
				local v51 = u33(p2 or u21)

				return UDim2.fromOffset(n3, v51)
			end),
			ZIndex = v18.ZIndex + 1
		})
	})
end

return React.memo(React.forwardRef(SegmentedControl))
