local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation").View

local SectionTitleLabel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitleLabel")

local function SectionTitle(props)
	return React.createElement(view, {
		tag = "auto-xy",
		LayoutOrder = props.layoutOrder
	}, {
		TitleRow = React.createElement(view, { tag = "auto-xy padding-y-xsmall" }, {
			Label = React.createElement(SectionTitleLabel, {
				title = props.title,
				leadingIconName = props.leadingIconName
			})
		})
	})
end

return SectionTitle
