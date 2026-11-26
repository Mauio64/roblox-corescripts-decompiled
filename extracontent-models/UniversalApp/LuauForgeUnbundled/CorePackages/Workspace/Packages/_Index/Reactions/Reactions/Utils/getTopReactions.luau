local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")

local function getTopReactions(p2, p3)
	local v5 = {}
	local total = 0

	for k, possibleReaction in Constants.PossibleReactions do
		local v6 = p2[possibleReaction] or 0

		if not (v6 > 0) then
			continue
		end

		table.insert(v5, {
			reactionType = possibleReaction,
			count = v6,
			displayOrder = k
		})

		total += v6
	end

	table.sort(v5, function(a, b): boolean
		if a.count == b.count then
			return a.displayOrder < b.displayOrder
		end

		return a.count > b.count
	end)

	local reactionTypes = {}

	for i = 1, math.min(p3, #v5) do
		reactionTypes[i] = v5[i].reactionType
	end

	return { reactions = reactionTypes, totalCount = total }
end

return getTopReactions
