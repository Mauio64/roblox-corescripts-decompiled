local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function BuildMaturityBanner(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local text = t1.text

	return React.createElement(View, {
		LayoutOrder = 2,
		tag = "col size-full-0 auto-y padding-medium radius-medium bg-shift-200",
		testId = "build-maturity-banner"
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-y-xxsmall"
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				tag = "auto-xy content-emphasis",
				testId = "build-maturity-banner-icon",
				name = IconName.ShieldCheck,
				size = IconSize.Small
			}),
			Description = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
				Text = text
			})
		})
	})
end

return BuildMaturityBanner
