local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local view = Foundation.View
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitle")
local SectionTitleLabel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitleLabel")

local function SectionTitleWithAction(props)
	local v5 = props.variant == "back"

	local createElement = React.createElement
	local v7 = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v10 = {
		tag = "row align-y-center gap-xsmall auto-xy padding-y-xsmall",
		onActivated = props.onActivated
	}
	local v11 = {
		Label = React.createElement(SectionTitleLabel, {
			title = props.title,
			leadingIconName = props.leadingIconName,
			layoutOrder = v5 and 2 or 1
		}),
		Chevron = 0
	}

	local createElement3 = React.createElement
	local v14 = if v5 then iconName.ChevronLargeLeft else iconName.ChevronLargeRight
	v11.Chevron = createElement3(icon, {
		name = v14,
		size = iconSize.Medium,
		variant = iconVariant.Filled,
		LayoutOrder = v5 and 1 or 2
	})
	return createElement(view, v7, { TitleRow = createElement2(view, v10, v11) })
end

return SectionTitleWithAction
