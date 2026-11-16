local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function BuildMaturityBanner(p)
	local text = p.text
	return React.createElement(
		View,
		{
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y padding-medium radius-medium bg-shift-200",
			testId = "build-maturity-banner"
		},
		{
			Content = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-small size-full-0 auto-y padding-y-xxsmall"
				},
				{
					Icon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.ShieldCheck,
						size = IconSize.Small,
						tag = "auto-xy content-emphasis",
						testId = "build-maturity-banner-icon"
					}),
					Description = React.createElement(Text, {
						LayoutOrder = 2,
						Text = text,
						tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis"
					})
				}
			)
		}
	)
end

return BuildMaturityBanner
