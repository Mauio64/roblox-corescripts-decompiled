local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Constants")
local possibleReactionsByPossibleReaction = { crying = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType").Cry }

for k, possibleReaction in Constants.PossibleReactions do
	possibleReactionsByPossibleReaction[possibleReaction] = possibleReaction
end

local function reactionTypeFromEmojiName(value)
	return possibleReactionsByPossibleReaction[string.gsub(string.lower(value), "%-", "")]
end

return reactionTypeFromEmojiName
