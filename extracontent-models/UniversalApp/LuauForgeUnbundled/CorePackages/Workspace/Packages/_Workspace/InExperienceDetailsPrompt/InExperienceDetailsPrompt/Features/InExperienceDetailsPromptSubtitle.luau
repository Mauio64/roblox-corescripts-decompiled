local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/VerifiedBadges")

local text = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation").Text

local function InExperienceDetailsPromptSubtitle(p2)
	if p2.creator.hasVerifiedBadge then
		return React.createElement(
			VerifiedBadges.EmojiWrapper,
			{ emoji = VerifiedBadges.emoji.verified, layoutOrder = p2.layoutOrder },
			{
				CreatorName = React.createElement(text, {
					Text = p2.creator.name,
					tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall"
				})
			}
		)
	end

	return React.createElement(text, {
		Text = p2.creator.name,
		tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall",
		LayoutOrder = p2.layoutOrder
	})
end

return InExperienceDetailsPromptSubtitle
