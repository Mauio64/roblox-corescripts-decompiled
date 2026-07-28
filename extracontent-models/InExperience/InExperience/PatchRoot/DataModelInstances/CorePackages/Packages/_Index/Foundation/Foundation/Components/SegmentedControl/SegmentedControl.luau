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
local t1 = {
	testId = "--foundation-segmented-control",
	ZIndex = 1,
	size = InputSize.Medium
}

local function SegmentedControl(p1, p2) -- line: 42
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useSegmentedControlVariants (copy), React (copy), useAnimatedHighlight (copy), View (copy), withCommonProps (copy), Dash (copy), Segment (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = useTokens()
	local v19 = useSegmentedControlVariants(v18, v17.size, v17.isCircular)
	local u20 = React.useRef(nil)
	local v21 = React.useRef({})
	local u22 = React.useMemo(function() -- line: 60
		-- upvalues: v21 (copy), v17 (copy), React (copy)
		local current = v21.current

		for _, v35 in v17.segments do
			if v35.ref then
				current[v35.id] = v35.ref
			elseif not current[v35.id] then
				current[v35.id] = React.createRef()
			end
		end

		return current
	end, { v17.segments })
	local v23 = useAnimatedHighlight(v17.value, p2 or u20, u22)
	local activeItemHeight = v23.activeItemHeight
	local highlightPosition = v23.highlightPosition
	local highlightWidth = v23.highlightWidth
	local v27, v28 = React.useBinding(Vector2.new(0, 0))
	local u29 = v28
	local u30 = React.useCallback(function(p3) -- line: 77
		-- upvalues: u29 (ref)
		u29(p3.AbsoluteSize)
	end, { v19.container.tag })
	local v31 = React.useCallback(function(p4) -- line: 81
		-- upvalues: v17 (copy), u30 (ref)
		if v17.onAbsoluteSizeChanged then
			v17.onAbsoluteSizeChanged(p4)
		end

		u30(p4)
	end, {
		v17.onAbsoluteSizeChanged,
		u30
	})
	local u32 = React.useCallback(function(t2: {[any]: any}) -- line: 88
		-- upvalues: u22 (ref), v17 (copy)
		local n1 = 0

		if t2.current then
			local current = u22[v17.value].current

			if current then
				n1 = current.AbsolutePosition.Y - t2.current.AbsolutePosition.Y
			end
		end

		return n1
	end, { v17.value })

	return React.createElement(View, withCommonProps(v17, {
		Size = v27:map(function(vector2: Vector2) -- line: 104
			return UDim2.fromOffset(vector2.X, vector2.Y)
		end)
	}), {
		SegmentsContainer = React.createElement(View, withDefaults({
			tag = v19.container.tag,
			ref = p2 or u20
		}, {
			onAbsoluteSizeChanged = v31
		}), Dash.map(v17.segments, function(p5, n2: number) -- line: 117
			-- upvalues: React (copy), Segment (copy), v17 (copy), u22 (ref)
			local v44 = (n2 - 1) * 2 + 1

			return React.createElement(React.Fragment, {
				key = tostring(p5.id)
			}, {
				Segment = React.createElement(Segment, {
					id = p5.id,
					size = v17.size,
					isCircular = v17.isCircular,
					text = p5.text,
					icon = p5.icon,
					isActive = p5.id == v17.value,
					onActivated = v17.onActivated,
					LayoutOrder = v44,
					testId = `{ v17.testId }--segment-{ p5.id }`,
					ref = u22[p5.id]
				})
			})
		end)),
		Overlay = React.createElement(View, {
			testId = "--foundation-segmented-control--animated-overlay",
			backgroundStyle = v18.Color.Shift.Shift_400,
			tag = v19.segment.tag,
			Size = React.joinBindings({
				highlightWidth,
				activeItemHeight
			}):map(function(p6) -- line: 140
				return UDim2.fromOffset(p6[1], p6[2])
			end),
			Position = highlightPosition:map(function(n3: number) -- line: 143
				-- upvalues: u32 (ref), p2 (copy), u20 (ref)
				local v47 = u32(p2 or u20)

				return UDim2.fromOffset(n3, v47)
			end),
			ZIndex = v17.ZIndex + 1
		})
	})
end

return React.memo(React.forwardRef(SegmentedControl))
