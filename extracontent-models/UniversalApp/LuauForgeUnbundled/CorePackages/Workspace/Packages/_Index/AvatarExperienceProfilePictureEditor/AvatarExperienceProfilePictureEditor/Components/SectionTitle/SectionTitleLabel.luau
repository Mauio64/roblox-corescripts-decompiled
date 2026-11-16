local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

local function SectionTitleLabel(props)
	local v5 = {
		Title = React.createElement(text, {
			tag = "auto-xy text-heading-small content-emphasis",
			Text = props.title,
			LayoutOrder = props.leadingIconName and 2 or 1
		})
	}

	if props.leadingIconName then
		v5.LeadingIcon = React.createElement(icon, {
			name = props.leadingIconName,
			size = iconSize.Medium,
			LayoutOrder = 1
		})
	end

	return React.createElement(view, {
		tag = props.leadingIconName and "row align-y-center gap-xsmall auto-xy" or "auto-xy",
		LayoutOrder = props.layoutOrder
	}, v5)
end

return SectionTitleLabel
