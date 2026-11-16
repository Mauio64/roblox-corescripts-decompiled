local Reactions = script:FindFirstAncestor("Reactions")

local Constants = require(Reactions.Constants)
require(Reactions.Enums.ReactionType)

local function getTopReactions(p, p2: number)
	local v = {}
	local total = 0

	for k, possibleReaction in Constants.PossibleReactions do
		local count = p[possibleReaction] or 0

		if not (count > 0) then
			continue
		end

		table.insert(v, { reactionType = possibleReaction, count = count, displayOrder = k })

		total += count
	end

	table.sort(v, function(a, b): boolean
		if a.count == b.count then
			return a.displayOrder < b.displayOrder
		end

		return a.count > b.count
	end)

	local reactionTypes = {}

	for i = 1, math.min(p2, #v) do
		reactionTypes[i] = v[i].reactionType
	end

	return { reactions = reactionTypes, totalCount = total }
end

return getTopReactions
