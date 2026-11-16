local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Http").PerformFetch
local PostGamePlayerFeedback = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Utils/PostGamePlayerFeedback")
local FeedbackChannel = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Enums/FeedbackChannel")

local function fetchKeymapper(p2)
	return "luaapp.asset-review-api.channels.reviews" .. p2
end

return {
	Post = function(p2, p3, p4, p5, p6)
		return performFetch.Single("luaapp.asset-review-api.channels.reviews" .. p3, function(p7)
			return PostGamePlayerFeedback(p2, FeedbackChannel.ExperienceDiscoveryPage, p3, p4, p5, p6):andThen(function(p8)
				return Promise.resolve(p8)
			end, function(p8)
				return Promise.reject(p8)
			end)
		end)
	end,
	GetPostingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.asset-review-api.channels.reviews" .. p3)
	end
}
