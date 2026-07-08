local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)

require(Parent.DataHydration)

local VerifiedBadges = require(Parent.VerifiedBadges)
local Text = require(Parent.Foundation).Text

local function InExperienceDetailsPromptSubtitle(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), VerifiedBadges (copy), Text (copy)
	if t1.creator.hasVerifiedBadge then
		return React.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = VerifiedBadges.emoji.verified,
			layoutOrder = t1.layoutOrder
		}, {
			CreatorName = React.createElement(Text, {
				tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall",
				Text = t1.creator.name
			})
		})
	end

	return React.createElement(Text, {
		tag = "text-body-large content-default auto-xy text-truncate-split padding-right-xxsmall",
		Text = t1.creator.name,
		LayoutOrder = t1.layoutOrder
	})
end

return InExperienceDetailsPromptSubtitle
