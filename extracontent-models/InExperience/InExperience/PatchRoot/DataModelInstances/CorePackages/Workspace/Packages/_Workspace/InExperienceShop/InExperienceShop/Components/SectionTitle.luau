local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function SectionTitle(props)
	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder
	}, {
		TitleRow = React.createElement(
			View,
			{
				tag = "row align-y-center size-full-0 auto-y",
				onActivated = props.onActivated,
				LayoutOrder = 1
			},
			{
				Title = React.createElement(Text, {
					tag = "auto-xy text-heading-small content-emphasis",
					Text = props.title,
					LayoutOrder = 1
				}),
				Chevron = React.createElement(Icon, {
					name = IconName.ChevronLargeRight,
					size = IconSize.Small,
					LayoutOrder = 2
				})
			}
		)
	})
end

return SectionTitle
