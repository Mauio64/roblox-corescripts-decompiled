local Moments = script:FindFirstAncestor("Moments")
require(Moments.Components.Feed.FeedTypes)

local function createCommentsRecommendationSession(callback, p, momentsSessionId: string, callback2)
	local v = callback2 or os.clock
	local clone = table.clone(p)
	local v2 = nil
	local v3 = false

	return {
		startView = function()
			if not v3 and v2 == nil then
				v2 = v()
			end
		end,
		finishView = function()
			local v4 = v2
			v2 = nil

			if v4 == nil or v3 then
				return
			end

			callback("CommentSectionOpen", clone, {
				momentsSessionId = momentsSessionId,
				commentSectionOpenDurationSeconds = math.max(0, v() - v4)
			})
		end,
		cancel = function()
			v3 = true
			v2 = nil
		end,
		logComment = function(commentText: string?)
			if not v3 then
				callback("Comment", clone, {
					momentsSessionId = momentsSessionId,
					commentText = commentText
				})
			end
		end,
		logCommentDelete = function()
			if not v3 then
				callback("CommentDelete", clone, { momentsSessionId = momentsSessionId })
			end
		end
	}
end

return createCommentsRecommendationSession
