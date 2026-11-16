local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local ChipSize = require(Foundation.Enums.ChipSize)
local Divider = require(Foundation.Components.Divider)
local Icon = require(Foundation.Components.Icon)
local Orientation = require(Foundation.Enums.Orientation)
local RatingValue = require(Foundation.Enums.RatingValue)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useRatingVariants = require(script.Parent.useRatingVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local icon = BuilderIcons.Icon
local IconVariant = BuilderIcons.IconVariant

local v = {
	size = ChipSize.Medium,
	value = RatingValue.None,
	Selectable = true,
	testId = "--foundation-rating"
}

local function Rating(p, ref3)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useRatingVariants(v3, v2.size)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local cursor = React.useMemo(function()
		local thicker = math.floor(v3.Stroke.Thicker)
		return {
			radius = UDim.new(0, v3.Radius.Circle),
			offset = thicker * 2,
			borderWidth = thicker
		}
	end, { v3 })

	local v5 = v2.value == RatingValue.ThumbUp
	local v6 = v2.value == RatingValue.ThumbDown

	local createElement = React.createElement

	local v7 = withCommonProps(v2, {
		tag = v4.container.tag,
		backgroundStyle = v4.container.backgroundStyle,
		ref = ref3
	})

	local createElement2 = React.createElement
	local v8 = {
		tag = v4.thumbUpSegment.tag,
		ref = ref,
		LayoutOrder = 1,
		onActivated = v2.onThumbUp,
		cursor = cursor,
		selection = {
			Selectable = v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = ref2
		},
		testId = `{v2.testId}--thumb-up`
	}

	local createElement3 = React.createElement
	local v9 = { tag = v4.thumbUpIcon.tag, LayoutOrder = 1 }

	local createElement4 = React.createElement
	local v10 = {
		name = icon.ThumbUp,
		variant = 0,
		size = 0,
		style = 0,
		testId = 0
	}
	local variant

	if v5 then
		variant = IconVariant.Filled
	else
		variant = IconVariant.Regular
	end

	v10.variant = variant
	v10.size = v4.iconSize
	v10.style = v4.text.contentStyle
	v10.testId = `{v2.testId}--thumb-up-icon`
	local children = {
		ThumbUp = createElement2(View, v8, {
			Icon = createElement3(View, v9, { Icon = createElement4(Icon, v10) }),
			Text = React.createElement(Text, {
				Text = v2.text,
				textStyle = v4.text.contentStyle,
				tag = v4.text.tag,
				LayoutOrder = 2,
				testId = `{v2.testId}--text`
			})
		}),
		Divider = React.createElement(
			View,
			{ tag = v4.dividerContainer.tag, LayoutOrder = 2, testId = `{v2.testId}--divider` },
			{
				Line = React.createElement(Divider, { orientation = Orientation.Vertical })
			}
		),
		ThumbDown = 0
	}

	local createElement5 = React.createElement
	local v11 = {
		tag = v4.thumbDownSegment.tag,
		ref = ref2,
		LayoutOrder = 3,
		onActivated = v2.onThumbDown,
		cursor = cursor,
		selection = {
			Selectable = v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = ref,
			NextSelectionRight = v2.NextSelectionRight
		},
		testId = `{v2.testId}--thumb-down`
	}

	local createElement6 = React.createElement
	local v12 = { tag = v4.thumbDownIcon.tag, LayoutOrder = 1 }

	local createElement7 = React.createElement
	local v13 = {
		name = icon.ThumbDown,
		variant = 0,
		size = 0,
		style = 0,
		testId = 0
	}
	local variant2

	if v6 then
		variant2 = IconVariant.Filled
	else
		variant2 = IconVariant.Regular
	end

	v13.variant = variant2
	v13.size = v4.iconSize
	v13.style = v4.text.contentStyle
	v13.testId = `{v2.testId}--thumb-down-icon`
	children.ThumbDown = createElement5(View, v11, {
		Icon = createElement6(View, v12, { Icon = createElement7(Icon, v13) })
	})
	return createElement(View, v7, children)
end

return React.memo(React.forwardRef(Rating))
