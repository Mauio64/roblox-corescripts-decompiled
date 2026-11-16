local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)

local ThumbsUp = MomentsCommon.Enums.ReactionType.ThumbsUp

return {
	DEFAULT_REACTION = ThumbsUp,
	decide = function(effectReaction, p: string, p2)
		local v = effectReaction ~= nil

		if p == "tapButton" then
			if v then
				return { action = "clear", reaction = nil, effectReaction = nil }
			end

			return { action = "commit", reaction = ThumbsUp, effectReaction = ThumbsUp }
		elseif p == "doubleTap" then
			if v then
				return { action = "none", reaction = nil, effectReaction = effectReaction }
			end

			return { action = "commit", reaction = ThumbsUp, effectReaction = ThumbsUp }
		else
			local v2 = p2 or ThumbsUp

			if v and v2 == effectReaction then
				return { action = "clear", reaction = nil, effectReaction = nil }
			end

			return { action = "commit", reaction = v2, effectReaction = v2 }
		end
	end
}
