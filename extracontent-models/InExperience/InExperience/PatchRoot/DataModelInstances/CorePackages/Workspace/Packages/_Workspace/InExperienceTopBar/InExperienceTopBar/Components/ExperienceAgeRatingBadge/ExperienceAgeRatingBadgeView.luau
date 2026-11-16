local parent = script:FindFirstAncestor("InExperienceTopBar").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local View = Foundation.View

local function ExperienceAgeRatingBadgeView(props)
	return React.createElement(
		View,
		{
			tag = "row align-x-center align-y-center auto-xy",
			LayoutOrder = props.layoutOrder,
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = props.onAbsolutePositionChanged
		},
		{
			Rating = React.createElement(Badge, {
				text = `<b>{props.text}</b>`,
				variant = BadgeVariant.Contrast,
				shape = BadgeShape.Pill,
				size = BadgeSize.Small
			})
		}
	)
end

return ExperienceAgeRatingBadgeView
