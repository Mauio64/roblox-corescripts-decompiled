local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
require(parent.DataHydration)
local VerifiedBadges = require(parent.VerifiedBadges)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text

local function InExperienceDetailsPromptSubtitle(p)
	if p.creator.hasVerifiedBadge then
		return React.createElement(
			VerifiedBadges.EmojiWrapper,
			{ emoji = VerifiedBadges.emoji.verified, layoutOrder = p.layoutOrder },
			{
				CreatorName = React.createElement(Text, {
					Text = p.creator.name,
					tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall"
				})
			}
		)
	end

	return React.createElement(Text, {
		Text = p.creator.name,
		tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall",
		LayoutOrder = p.layoutOrder
	})
end

return InExperienceDetailsPromptSubtitle
