local Parent = script:FindFirstAncestor("Moments").Parent
local ThumbsUp = require(Parent.MomentsCommon).Enums.ReactionType.ThumbsUp

return {
	DEFAULT_REACTION = ThumbsUp,
	decide = function(p1, s1: string, p2) -- line: 40
		-- upvalues: ThumbsUp (copy)
		local v6 = p1 ~= nil

		if s1 == "tapButton" then
			if v6 then
				return {
					action = "clear",
					reaction = nil,
					effectReaction = nil
				}
			end

			return {
				action = "commit",
				reaction = ThumbsUp,
				effectReaction = ThumbsUp
			}
		end

		if s1 == "doubleTap" then
			if v6 then
				return {
					action = "none",
					reaction = nil,
					effectReaction = p1
				}
			end

			return {
				action = "commit",
				reaction = ThumbsUp,
				effectReaction = ThumbsUp
			}
		end

		local v7 = p2 or ThumbsUp

		if v6 and v7 == p1 then
			return {
				action = "clear",
				reaction = nil,
				effectReaction = nil
			}
		end

		return {
			action = "commit",
			reaction = v7,
			effectReaction = v7
		}
	end
}
