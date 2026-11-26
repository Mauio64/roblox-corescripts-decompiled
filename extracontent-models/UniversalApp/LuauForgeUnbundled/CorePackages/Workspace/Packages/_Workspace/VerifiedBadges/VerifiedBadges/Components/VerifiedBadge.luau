local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Foundation")

local icon = Foundation.Icon
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

local function VerifiedBadge(props)
	local v5 = useTokens()
	local size = props.size or iconSize.Small
	local backplateStyle = props.backplateStyle or v5.Color.System.Emphasis
	local checkStyle = props.checkStyle or v5.Color.Extended.White.White_100

	return React.createElement(
		view,
		{ tag = "auto-xy", LayoutOrder = props.LayoutOrder, testId = props.testId },
		{
			Backplate = React.createElement(icon, {
				name = iconName.VerifiedBackplate,
				variant = iconVariant.Filled,
				size = size,
				style = backplateStyle,
				ZIndex = 1
			}),
			Check = React.createElement(icon, {
				name = iconName.VerifiedCheck,
				variant = iconVariant.Filled,
				size = size,
				style = checkStyle,
				ZIndex = 2
			})
		}
	)
end

return VerifiedBadge
