local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local function BuildMaturityBanner(p2)
	local text2 = p2.text
	return React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y padding-medium radius-medium bg-shift-200",
			testId = "build-maturity-banner"
		},
		{
			Content = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-small size-full-0 auto-y padding-y-xxsmall"
				},
				{
					Icon = React.createElement(icon, {
						LayoutOrder = 1,
						name = iconName.ShieldCheck,
						size = iconSize.Small,
						tag = "auto-xy content-emphasis",
						testId = "build-maturity-banner-icon"
					}),
					Description = React.createElement(text, {
						LayoutOrder = 2,
						Text = text2,
						tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis"
					})
				}
			)
		}
	)
end

return BuildMaturityBanner
