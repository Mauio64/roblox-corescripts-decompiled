local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
require(parent.Foundation)

local SectionTitle = require(script.Parent.SectionTitle)
local SectionTitleWithAction = require(script.Parent.SectionTitleWithAction)

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
