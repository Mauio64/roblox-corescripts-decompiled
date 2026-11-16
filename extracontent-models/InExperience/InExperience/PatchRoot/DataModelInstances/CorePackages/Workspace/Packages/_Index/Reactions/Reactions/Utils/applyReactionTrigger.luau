local Reactions = script:FindFirstAncestor("Reactions")

local ReactionTrigger = require(Reactions.Enums.ReactionTrigger)
local ReactionType = require(Reactions.Enums.ReactionType)

local ThumbsUp = ReactionType.ThumbsUp

local function getSoleReaction(items)
	for k, item in items do
		if item then
			return k
		end
	end

	return nil
end

local function applyReactionTrigger(state, p, p2, p3)
	local v

	if p3 == nil then
		v = false
	else
		v = p3.allowMultiple == true
	end

	local removed

	if not v then
		for k, selectedReaction in state.selectedReactions do
			if selectedReaction then
				removed = k
				break
			end
		end
	end

	local v2

	if p == ReactionTrigger.PickerSelect then
		v2 = p2 or ThumbsUp
	elseif p == ReactionTrigger.ButtonTap then
		v2 = p2 or removed or ThumbsUp
	else
		v2 = removed or ThumbsUp
	end

	local v3 = state.selectedReactions[v2] == true

	if v3 and p == ReactionTrigger.DoubleTap then
		return { state = state, added = nil, removed = nil, celebratedReaction = v2 }
	end

	local selectedReactions = not v and {} or table.clone(state.selectedReactions)
	local clone = table.clone(state.reactionCounts)
	local function decrement(p4) -- 2 equivalent calls inferred from this helper
		local v4 = (clone[p4] or 0) - 1

		if v4 > 0 then
			clone[p4] = v4
		else
			clone[p4] = nil
		end
	end

	if v3 then
		selectedReactions[v2] = nil
		decrement(v2) -- inferred equivalent call
		return {
			state = { selectedReactions = selectedReactions, reactionCounts = clone },
			added = nil,
			removed = v2,
			celebratedReaction = nil
		}
	end

	if removed ~= nil then
		decrement(removed) -- inferred equivalent call
	end

	selectedReactions[v2] = true
	clone[v2] = (clone[v2] or 0) + 1

	return {
		state = { selectedReactions = selectedReactions, reactionCounts = clone },
		added = v2,
		removed = removed,
		celebratedReaction = v2
	}
end

return applyReactionTrigger
