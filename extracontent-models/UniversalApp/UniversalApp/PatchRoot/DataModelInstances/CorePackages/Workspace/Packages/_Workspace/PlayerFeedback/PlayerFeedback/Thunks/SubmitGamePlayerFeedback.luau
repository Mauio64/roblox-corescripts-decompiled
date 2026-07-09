local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local PlayerFeedbackParent = PlayerFeedback.Parent
local Promise = require(PlayerFeedbackParent.Promise)
local PerformFetch = require(PlayerFeedbackParent.Http).PerformFetch
local PostGamePlayerFeedback = require(PlayerFeedback.Utils.PostGamePlayerFeedback)
local FeedbackChannel = require(PlayerFeedback.Enums.FeedbackChannel)

local function fetchKeymapper(p1) -- line: 8
	return "luaapp.asset-review-api.channels.reviews" .. p1
end

return {
	Post = function(p2, s1: string, s2: string, t1: {[any]: any}, s3: string) -- line: 14
		-- upvalues: PerformFetch (copy), PostGamePlayerFeedback (copy), FeedbackChannel (copy), Promise (copy)
		return PerformFetch.Single("luaapp.asset-review-api.channels.reviews" .. s1, function(_) -- line: 21
			-- upvalues: PostGamePlayerFeedback (copy), p2 (copy), FeedbackChannel (copy), s1 (copy), s2 (copy), t1 (copy), s3 (copy), Promise (copy)
			return PostGamePlayerFeedback(p2, FeedbackChannel.ExperienceDiscoveryPage, s1, s2, t1, s3):andThen(function(p4) -- line: 29
				-- upvalues: Promise (copy)
				return Promise.resolve(p4)
			end, function(p5) -- line: 31
				-- upvalues: Promise (copy)
				return Promise.reject(p5)
			end)
		end)
	end,
	GetPostingStatus = function(p6, p7) -- line: 36
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p6, "luaapp.asset-review-api.channels.reviews" .. p7)
	end
}
