local Reactions = script:FindFirstAncestor("Reactions")

local Constants = require(Reactions.Constants)
local ReactionType = require(Reactions.Enums.ReactionType)

local possibleReactionsByPossibleReaction = { crying = ReactionType.Cry }

for _, possibleReaction in Constants.PossibleReactions do
	possibleReactionsByPossibleReaction[possibleReaction] = possibleReaction
end

local function reactionTypeFromEmojiName(value: string)
	return possibleReactionsByPossibleReaction[string.gsub(string.lower(value), "%-", "")]
end

return reactionTypeFromEmojiName
