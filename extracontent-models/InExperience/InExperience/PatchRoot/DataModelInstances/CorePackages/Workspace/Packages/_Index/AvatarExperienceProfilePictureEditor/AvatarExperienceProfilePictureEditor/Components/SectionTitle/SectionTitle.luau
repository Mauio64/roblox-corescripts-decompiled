local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local SectionTitleLabel = require(script.Parent.SectionTitleLabel)

local function SectionTitle(props)
	return React.createElement(View, { tag = "auto-xy", LayoutOrder = props.layoutOrder }, {
		TitleRow = React.createElement(View, { tag = "auto-xy padding-y-xsmall" }, {
			Label = React.createElement(SectionTitleLabel, {
				title = props.title,
				leadingIconName = props.leadingIconName
			})
		})
	})
end

return SectionTitle
