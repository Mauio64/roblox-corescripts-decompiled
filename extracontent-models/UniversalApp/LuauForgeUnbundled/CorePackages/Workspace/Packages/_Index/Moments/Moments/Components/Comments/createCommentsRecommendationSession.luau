require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function createCommentsRecommendationSession(callback, p2, p3, p4)
	local v5 = p4 or os.clock
	local clone = table.clone(p2)
	local v6 = nil
	local v7 = false

	return {
		startView = function()
			if not v7 and v6 == nil then
				v6 = v5()
			end
		end,
		finishView = function()
			local v8 = v6
			v6 = nil

			if v8 == nil or v7 then
				return
			end

			callback("CommentSectionOpen", clone, {
				momentsSessionId = p3,
				commentSectionOpenDurationSeconds = math.max(0, v5() - v8)
			})
		end,
		cancel = function()
			v7 = true
			v6 = nil
		end,
		logComment = function(p5)
			if not v7 then
				callback("Comment", clone, { momentsSessionId = p3, commentText = p5 })
			end
		end,
		logCommentDelete = function()
			if not v7 then
				callback("CommentDelete", clone, { momentsSessionId = p3 })
			end
		end
	}
end

return createCommentsRecommendationSession
