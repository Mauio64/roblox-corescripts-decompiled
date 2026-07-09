local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function SectionTitle(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), View (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy)
	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		TitleRow = React.createElement(View, {
			tag = "row align-y-center size-full-0 auto-y",
			LayoutOrder = 1,
			onActivated = t1.onActivated
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-emphasis",
				LayoutOrder = 1,
				Text = t1.title
			}),
			Chevron = React.createElement(Icon, {
				LayoutOrder = 2,
				name = IconName.ChevronLargeRight,
				size = IconSize.Small
			})
		})
	})
end

return SectionTitle
