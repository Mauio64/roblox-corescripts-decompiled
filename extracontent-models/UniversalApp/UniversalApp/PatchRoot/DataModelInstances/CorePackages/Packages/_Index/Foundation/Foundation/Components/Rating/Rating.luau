local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
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
local Icon2 = BuilderIcons.Icon
local IconVariant = BuilderIcons.IconVariant
local t1 = {
	Selectable = true,
	testId = "--foundation-rating",
	size = ChipSize.Medium,
	value = RatingValue.None
}

local function Rating(p1, p2) -- line: 41
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useRatingVariants (copy), React (copy), RatingValue (copy), View (copy), withCommonProps (copy), Icon (copy), Icon2 (copy), IconVariant (copy), Text (copy), Divider (copy), Orientation (copy)
	local v22 = withDefaults(p1, t1)
	local v23 = useTokens()
	local v24 = useRatingVariants(v23, v22.size)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27 = React.useMemo(function() -- line: 49
		-- upvalues: v23 (copy)
		local v30 = math.floor(v23.Stroke.Thicker)

		return {
			radius = UDim.new(0, v23.Radius.Circle),
			offset = v30 * 2,
			borderWidth = v30
		}
	end, { v23 })
	local v28 = v22.value == RatingValue.ThumbUp
	local v29 = v22.value == RatingValue.ThumbDown

	return React.createElement(View, withCommonProps(v22, {
		tag = v24.container.tag,
		backgroundStyle = v24.container.backgroundStyle,
		ref = p2
	}), {
		ThumbUp = React.createElement(View, {
			LayoutOrder = 1,
			tag = v24.thumbUpSegment.tag,
			ref = v25,
			onActivated = v22.onThumbUp,
			cursor = v27,
			selection = {
				Selectable = v22.Selectable,
				NextSelectionUp = v22.NextSelectionUp,
				NextSelectionDown = v22.NextSelectionDown,
				NextSelectionLeft = v22.NextSelectionLeft,
				NextSelectionRight = v26
			},
			testId = `{ v22.testId }--thumb-up`
		}, {
			Icon = React.createElement(View, {
				LayoutOrder = 1,
				tag = v24.thumbUpIcon.tag
			}, {
				Icon = React.createElement(Icon, {
					name = Icon2.ThumbUp,
					variant = if not v28 then IconVariant.Regular else IconVariant.Filled,
					size = v24.iconSize,
					style = v24.text.contentStyle,
					testId = `{ v22.testId }--thumb-up-icon`
				})
			}),
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v22.text,
				textStyle = v24.text.contentStyle,
				tag = v24.text.tag,
				testId = `{ v22.testId }--text`
			})
		}),
		Divider = React.createElement(View, {
			LayoutOrder = 2,
			tag = v24.dividerContainer.tag,
			testId = `{ v22.testId }--divider`
		}, {
			Line = React.createElement(Divider, {
				orientation = Orientation.Vertical
			})
		}),
		ThumbDown = React.createElement(View, {
			LayoutOrder = 3,
			tag = v24.thumbDownSegment.tag,
			ref = v26,
			onActivated = v22.onThumbDown,
			cursor = v27,
			selection = {
				Selectable = v22.Selectable,
				NextSelectionUp = v22.NextSelectionUp,
				NextSelectionDown = v22.NextSelectionDown,
				NextSelectionLeft = v25,
				NextSelectionRight = v22.NextSelectionRight
			},
			testId = `{ v22.testId }--thumb-down`
		}, {
			Icon = React.createElement(View, {
				LayoutOrder = 1,
				tag = v24.thumbDownIcon.tag
			}, {
				Icon = React.createElement(Icon, {
					name = Icon2.ThumbDown,
					variant = if not v29 then IconVariant.Regular else IconVariant.Filled,
					size = v24.iconSize,
					style = v24.text.contentStyle,
					testId = `{ v22.testId }--thumb-down-icon`
				})
			})
		})
	})
end

return React.memo(React.forwardRef(Rating))
