local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ChipGroupVariant = require(Foundation.Enums.ChipGroupVariant)

local Flags = require(Foundation.Utility.Flags)

local ChipSize = require(Foundation.Enums.ChipSize)

require(Foundation.Enums.ChipVariant)

require(Foundation.Components.Chip.Accessory)

local Visibility = require(Foundation.Enums.Visibility)

local BackgroundStyleContext = require(Foundation.Providers.Style.BackgroundStyleContext)
local useBackgroundStyle = BackgroundStyleContext.useBackgroundStyle

local Chip = require(Foundation.Components.Chip)
local OverflowScrollContainer = require(Foundation.Components.OverflowScrollContainer)
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

local v = {
	size = ChipSize.Medium,
	variant = ChipGroupVariant.Row,
	testId = "--foundation-chip-group"
}

local function Scrim(props)
	local backgroundStyle = useBackgroundStyle()

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(0, props.width, 1, 0),
			backgroundStyle = backgroundStyle,
			testId = props.testId
		},
		{
			UIGradient = React.createElement("UIGradient", { Transparency = props.gradient })
		}
	)
end

local function ChipGroup(p, ref2)
	local v2 = withDefaults(p, v)
	local v3 = useChipGroupVariants(useTokens(), v2.variant, v2.size)

	if Flags.FoundationUnifiedScrimScrolling then
		local size = v2.size
		local children = {}

		for k, chip in v2.chips do
			children[`Chip{k}`] = React.createElement(Chip, {
				text = chip.text,
				leading = chip.leading,
				trailing = chip.trailing,
				onActivated = chip.onActivated,
				isChecked = chip.isChecked,
				variant = chip.variant,
				size = size,
				LayoutOrder = k,
				testId = `{v2.testId}--chip-{k}`
			})
		end

		local element = React.createElement(View, {
			tag = "auto-xy",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v3.gap),
				Wraps = v3.isWrapped
			}
		}, children)

		if v3.isWrapped then
			return React.createElement(View, withCommonProps(v2, {
				tag = "size-full-0 auto-y",
				ref = ref2
			}), {
				ChipContainer = element
			})
		end

		return React.createElement(OverflowScrollContainer, withCommonProps(v2, {
			size = v2.size,
			ref = ref2
		}), {
			ChipContainer = element
		})
	else
		local v4, v5 = React.useBinding(false)
		local v6, v7 = React.useBinding(false)
		local ref = React.useRef(nil)
		local v8 = useClippingRect(ref)

		local v9 = React.useCallback(function(data)
			if not v3.hasScrim or data.AbsoluteWindowSize.X == 0 then
				return
			end

			v5(data.CanvasPosition.X ~= 0)
			v7(data.AbsoluteWindowSize.X + data.CanvasPosition.X < data.AbsoluteCanvasSize.X - 1)
		end, { v3.hasScrim })

		local onAbsoluteSizeChanged = React.useCallback(function()
			if ref.current then
				v9(ref.current)
			end
		end, { v2.onAbsoluteSizeChanged, v9 })

		local onAbsolutePositionChanged = React.useCallback(function()
			if ref.current then
				v9(ref.current)
			end
		end, { v2.onAbsolutePositionChanged, v9 })

		local size = v2.size
		local scrimWidth = v3.scrimWidth
		local children = {}

		for k, chip in v2.chips do
			children[`Chip{k}`] = React.createElement(Chip, {
				text = chip.text,
				leading = chip.leading,
				trailing = chip.trailing,
				onActivated = chip.onActivated,
				isChecked = chip.isChecked,
				variant = chip.variant,
				size = size,
				LayoutOrder = k,
				testId = `{v2.testId}--chip-{k}`
			})
		end

		local v10 = withCommonProps(v2, { ref = ref2, tag = "size-full-0 auto-y" })

		v10.onAbsoluteSizeChanged = onAbsoluteSizeChanged
		v10.onAbsolutePositionChanged = onAbsolutePositionChanged

		local createElement = React.createElement
		local createElement2 = React.createElement
		local v11 = {
			tag = "size-full-0 auto-y",
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromScale(0, 1),
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollingEnabled = not v3.isWrapped,
				scrollBarVisibility = Visibility.None
			},
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v3.gap),
				Wraps = v3.isWrapped
			},
			ClipsDescendants = v3.isWrapped,
			scrollingFrameRef = ref,
			onCanvasPositionChanged = 0,
			onAbsoluteCanvasSizeChanged = 0,
			onAbsoluteWindowSizeChanged = 0
		}
		local onCanvasPositionChanged

		if v3.hasScrim then
			onCanvasPositionChanged = v9
		end

		v11.onCanvasPositionChanged = onCanvasPositionChanged
		local onAbsoluteCanvasSizeChanged

		if v3.hasScrim then
			onAbsoluteCanvasSizeChanged = v9
		end

		v11.onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged
		local onAbsoluteWindowSizeChanged

		if v3.hasScrim then
			onAbsoluteWindowSizeChanged = v9
		end

		v11.onAbsoluteWindowSizeChanged = onAbsoluteWindowSizeChanged
		local v12 = {
			ScrollView = createElement2(ScrollView, v11, children),
			ScrimWrapper = 0
		}
		local scrimWrapper

		if v3.hasScrim then
			scrimWrapper = React.createElement(View, {
				tag = "row flex-between",
				Size = v8:map(function(rect: Rect)
					return UDim2.fromOffset(rect.Max.X - rect.Min.X, scrimWidth)
				end),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				ZIndex = 2
			}, {
				ScrimStart = v4 and React.createElement(Scrim, {
					LayoutOrder = 1,
					gradient = numberSequence,
					width = scrimWidth,
					testId = `{v2.testId}--scrim-start`
				}),
				ScrimEnd = v6 and React.createElement(Scrim, {
					LayoutOrder = 2,
					gradient = numberSequence2,
					width = scrimWidth,
					testId = `{v2.testId}--scrim-end`
				})
			})
		end

		v12.ScrimWrapper = scrimWrapper
		return createElement(View, v10, v12)
	end
end

return React.memo(React.forwardRef(ChipGroup))
