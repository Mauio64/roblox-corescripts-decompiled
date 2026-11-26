local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local view = Foundation.View
local icon = Foundation.Icon
local enums = Foundation.Enums

local function VerifiedBadge(props)
	return React.createElement(
		view,
		{
			tag = "auto-xy",
			LayoutOrder = props.LayoutOrder,
			testId = "tilt-verified-badge"
		},
		{
			Backplate = React.createElement(icon, {
				name = "verified-backplate",
				variant = enums.IconVariant.Filled,
				size = enums.IconSize.Small,
				style = props.backplateStyle,
				ZIndex = 1
			}),
			Check = React.createElement(icon, {
				name = "verified-check",
				variant = enums.IconVariant.Filled,
				size = enums.IconSize.Small,
				style = props.checkStyle,
				ZIndex = 2
			})
		}
	)
end

return VerifiedBadge
