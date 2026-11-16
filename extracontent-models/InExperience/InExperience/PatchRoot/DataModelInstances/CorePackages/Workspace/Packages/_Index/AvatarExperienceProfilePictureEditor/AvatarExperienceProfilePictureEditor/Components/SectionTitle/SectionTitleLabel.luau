local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function SectionTitleLabel(props)
	local v = {
		Title = React.createElement(Text, {
			tag = "auto-xy text-heading-small content-emphasis",
			Text = props.title,
			LayoutOrder = props.leadingIconName and 2 or 1
		})
	}

	if props.leadingIconName then
		v.LeadingIcon = React.createElement(Icon, {
			name = props.leadingIconName,
			size = IconSize.Medium,
			LayoutOrder = 1
		})
	end

	return React.createElement(View, {
		tag = props.leadingIconName and "row align-y-center gap-xsmall auto-xy" or "auto-xy",
		LayoutOrder = props.layoutOrder
	}, v)
end

return SectionTitleLabel
