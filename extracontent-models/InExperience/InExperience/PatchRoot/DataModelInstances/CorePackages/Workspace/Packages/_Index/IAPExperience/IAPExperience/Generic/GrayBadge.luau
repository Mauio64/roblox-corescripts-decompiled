local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-xsmall size-600 auto-x padding-x-small radius-circle bg-shift-300",
		LayoutOrder = t1.LayoutOrder
	}, {
		Icon = if not t1.iconName then nil else React.createElement(Icon, {
			LayoutOrder = 1,
			tag = "content-emphasis",
			name = t1.iconName,
			size = IconSize.XSmall
		}),
		Text = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-caption-small text-align-x-center content-emphasis",
			Text = t1.Text
		})
	})
end
