local parent = script:FindFirstAncestor("AppChat").Parent

local Reactions = require(parent.Reactions)

local ReactionType = Reactions.Enums.ReactionType

return {
	PICKER_REACTION_ORDER = {
		ReactionType.ThumbsUp,
		ReactionType.Heart,
		ReactionType.LaughJoy,
		ReactionType.Wow,
		ReactionType.Cry,
		ReactionType.Fire,
		ReactionType.Skull
	}
}
