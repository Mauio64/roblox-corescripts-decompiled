local ReactionTrigger = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionTrigger")
local thumbsUp = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType").ThumbsUp

local function getSoleReaction(items)
	for k, item in items do
		if item then
			return k
		end
	end

	return nil
end

local function applyReactionTrigger(p2, p3, p4, p5)
	local v5 = not (p5 == nil) and p5.allowMultiple == true
	local v6

	if not v5 then
		for k, selectedReaction in p2.selectedReactions do
			if selectedReaction then
				v6 = k
				break
			end
		end
	end

	local v7

	if p3 == ReactionTrigger.PickerSelect then
		v7 = p4 or thumbsUp
	else
		v7 = if p3 == ReactionTrigger.ButtonTap then p4 or v6 or thumbsUp else v6 or thumbsUp
	end

	local v8 = p2.selectedReactions[v7] == true

	if v8 and p3 == ReactionTrigger.DoubleTap then
		return { state = p2, added = nil, removed = nil, celebratedReaction = v7 }
	end

	local v9 = not v5 and {} or table.clone(p2.selectedReactions)
	local clone = table.clone(p2.reactionCounts)
	local function decrement(p6)
		local v10 = (clone[p6] or 0) - 1

		if v10 > 0 then
			clone[p6] = v10
		else
			clone[p6] = nil
		end
	end

	if v8 then
		v9[v7] = nil
		local v10 = (clone[v7] or 0) - 1

		if v10 > 0 then
			clone[v7] = v10
		else
			clone[v7] = nil
		end

		return {
			state = { selectedReactions = v9, reactionCounts = clone },
			added = nil,
			removed = v7,
			celebratedReaction = nil
		}
	end

	if v6 ~= nil then
		local v10 = (clone[v6] or 0) - 1

		if v10 > 0 then
			clone[v6] = v10
		else
			clone[v6] = nil
		end
	end

	v9[v7] = true
	clone[v7] = (clone[v7] or 0) + 1

	return {
		state = { selectedReactions = v9, reactionCounts = clone },
		added = v7,
		removed = v6,
		celebratedReaction = v7
	}
end

return applyReactionTrigger
