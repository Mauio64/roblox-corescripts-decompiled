local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local SectionTitle = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitle")
local SectionTitleWithAction = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitleWithAction")

local function SectionHeader(props)
	if props.onBack then
		return React.createElement(SectionTitleWithAction, {
			title = props.title,
			leadingIconName = props.leadingIconName,
			variant = "back",
			onActivated = props.onBack
		})
	end

	return React.createElement(SectionTitle, {
		title = props.title,
		leadingIconName = props.leadingIconName
	})
end

return SectionHeader
