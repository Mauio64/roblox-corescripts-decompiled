local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").Text

local function DescriptionTextBlock(p2)
	return React.createElement(text, {
		Text = p2.text,
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
		LayoutOrder = p2.LayoutOrder
	})
end

return DescriptionTextBlock
