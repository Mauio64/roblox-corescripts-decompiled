local thumbsUp = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Enums.ReactionType.ThumbsUp

return {
	DEFAULT_REACTION = thumbsUp,
	decide = function(p2, p3, p4)
		local v5 = p2 ~= nil

		if p3 == "tapButton" then
			if v5 then
				return { action = "clear", reaction = nil, effectReaction = nil }
			end

			return { action = "commit", reaction = thumbsUp, effectReaction = thumbsUp }
		elseif p3 == "doubleTap" then
			if v5 then
				return { action = "none", reaction = nil, effectReaction = p2 }
			end

			return { action = "commit", reaction = thumbsUp, effectReaction = thumbsUp }
		else
			local v6 = p4 or thumbsUp

			if v5 and v6 == p2 then
				return { action = "clear", reaction = nil, effectReaction = nil }
			end

			return { action = "commit", reaction = v6, effectReaction = v6 }
		end
	end
}
