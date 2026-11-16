local Reactions = script:FindFirstAncestor("Reactions")

local Constants = require(Reactions.Constants)
require(Reactions.Enums.ReactionType)
require(Reactions.Utils.applyReactionTrigger)
local StoryUtils = {}

function StoryUtils.describeSelection(p)
	local possibleReactions = {}

	for _, possibleReaction in Constants.PossibleReactions do
		if p[possibleReaction] then
			table.insert(possibleReactions, possibleReaction)
		end
	end

	if #possibleReactions > 0 then
		return (table.concat(possibleReactions, ", "))
	end

	return "none"
end

function StoryUtils.describeChange(p)
	local v = {}

	if p.added then
		table.insert(v, `added {p.added}`)
	end

	if p.removed then
		table.insert(v, `removed {p.removed}`)
	end

	if #v > 0 then
		return (table.concat(v, ", "))
	end

	return "none"
end

return StoryUtils
