local parent = script:FindFirstAncestor("TiltLoadingScreen").Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local function VerifiedBadge(props)
	return React.createElement(
		View,
		{ tag = "auto-xy", LayoutOrder = props.LayoutOrder, testId = "tilt-verified-badge" },
		{
			Backplate = React.createElement(Icon, {
				name = "verified-backplate",
				variant = Enums.IconVariant.Filled,
				size = Enums.IconSize.Small,
				style = props.backplateStyle,
				ZIndex = 1
			}),
			Check = React.createElement(Icon, {
				name = "verified-check",
				variant = Enums.IconVariant.Filled,
				size = Enums.IconSize.Small,
				style = props.checkStyle,
				ZIndex = 2
			})
		}
	)
end

return VerifiedBadge
