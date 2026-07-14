local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ChipGroupVariant = require(Foundation.Enums.ChipGroupVariant)
local ChipSize = require(Foundation.Enums.ChipSize)

require(Foundation.Enums.ChipVariant)
require(Foundation.Components.Chip.Accessory)

local Visibility = require(Foundation.Enums.Visibility)
local useBackgroundStyle = require(Foundation.Providers.Style.BackgroundStyleContext).useBackgroundStyle
local Chip = require(Foundation.Components.Chip)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useChipGroupVariants = require(Foundation.Components.ChipGroup.useChipGroupVariants)
local useClippingRect = require(Foundation.Components.ChipGroup.useClippingRect)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 1)
})
local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0)
})
local t1 = {
	testId = "--foundation-chip-group",
	size = ChipSize.Medium,
	variant = ChipGroupVariant.Row
}

local function Scrim(t2: {[any]: any}) -- line: 81
	-- upvalues: useBackgroundStyle (copy), React (copy), View (copy)
	local v22 = useBackgroundStyle()

	return React.createElement(View, {
		LayoutOrder = t2.LayoutOrder,
		Size = UDim2.new(0, t2.width, 1, 0),
		backgroundStyle = v22,
		testId = t2.testId
	}, {
		UIGradient = React.createElement("UIGradient", {
			Transparency = t2.gradient
		})
	})
end
local function ChipGroup(p1, p2) -- line: 101
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useChipGroupVariants (copy), React (copy), useClippingRect (copy), Chip (copy), withCommonProps (copy), View (copy), ScrollView (copy), Visibility (copy), Scrim (copy), numberSequence (copy), numberSequence2 (copy)
	local v25 = withDefaults(p1, t1)
	local v26 = useTokens()
	local v27 = useChipGroupVariants(v26, v25.variant, v25.size)
	local v28, v29 = React.useBinding(false)
	local v30, v31 = React.useBinding(false)
	local v32 = React.useRef(nil)
	local v33 = useClippingRect(v32)
	local v34 = React.useCallback(function(p3) -- line: 111
		-- upvalues: v27 (copy), v29 (copy), v31 (copy)
		if not v27.hasScrim or p3.AbsoluteWindowSize.X == 0 then
			return
		end

		v29(p3.CanvasPosition.X ~= 0)
		v31(p3.AbsoluteWindowSize.X + p3.CanvasPosition.X < p3.AbsoluteCanvasSize.X - 1)
	end, { v27.hasScrim })
	local v35 = React.useCallback(function() -- line: 123
		-- upvalues: v32 (copy), v34 (copy)
		if v32.current then
			v34(v32.current)
		end
	end, {
		v25.onAbsoluteSizeChanged,
		v34
	})
	local v36 = React.useCallback(function() -- line: 129
		-- upvalues: v32 (copy), v34 (copy)
		if v32.current then
			v34(v32.current)
		end
	end, {
		v25.onAbsolutePositionChanged,
		v34
	})
	local size = v25.size
	local scrimWidth = v27.scrimWidth
	local t3 = {}

	for v40, v41 in v25.chips do
		t3[`Chip{ v40 }`] = React.createElement(Chip, {
			text = v41.text,
			leading = v41.leading,
			trailing = v41.trailing,
			onActivated = v41.onActivated,
			isChecked = v41.isChecked,
			variant = v41.variant,
			size = size,
			LayoutOrder = v40,
			testId = `{ v25.testId }--chip-{ v40 }`
		})
	end

	local v42 = withCommonProps(v25, {
		tag = "size-full-0 auto-y",
		ref = p2
	})

	v42.onAbsoluteSizeChanged = v35
	v42.onAbsolutePositionChanged = v36

	return React.createElement(View, v42, {
		ScrollView = React.createElement(ScrollView, {
			tag = "size-full-0 auto-y",
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromScale(0, 1),
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollingEnabled = not v27.isWrapped,
				scrollBarVisibility = Visibility.None
			},
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v27.gap),
				Wraps = v27.isWrapped
			},
			ClipsDescendants = v27.isWrapped,
			scrollingFrameRef = v32,
			onCanvasPositionChanged = if not v27.hasScrim then nil else v34,
			onAbsoluteCanvasSizeChanged = if not v27.hasScrim then nil else v34,
			onAbsoluteWindowSizeChanged = if not v27.hasScrim then nil else v34
		}, t3),
		ScrimWrapper = if not v27.hasScrim then nil else React.createElement(View, {
			tag = "row flex-between",
			ZIndex = 2,
			Size = v33:map(function(rect: Rect) -- line: 185
				-- upvalues: scrimWidth (copy)
				return UDim2.fromOffset(rect.Max.X - rect.Min.X, scrimWidth)
			end),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0)
		}, {
			ScrimStart = v28 and React.createElement(Scrim, {
				LayoutOrder = 1,
				gradient = numberSequence,
				width = scrimWidth,
				testId = `{ v25.testId }--scrim-start`
			}),
			ScrimEnd = v30 and React.createElement(Scrim, {
				LayoutOrder = 2,
				gradient = numberSequence2,
				width = scrimWidth,
				testId = `{ v25.testId }--scrim-end`
			})
		})
	})
end

return React.memo(React.forwardRef(ChipGroup))
