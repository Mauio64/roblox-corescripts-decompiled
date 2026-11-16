local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local parent = PlayerFeedback.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local PostGamePlayerFeedback = require(PlayerFeedback.Utils.PostGamePlayerFeedback)
local FeedbackChannel = require(PlayerFeedback.Enums.FeedbackChannel)

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.asset-review-api.channels.reviews" .. p
end

local SubmitGamePlayerFeedback = {}

function SubmitGamePlayerFeedback.Post(p, p2: string, p3: string, p4, p5: string)
	return PerformFetch.Single(fetchKeymapper(p2), function(_) -- inferred equivalent call
		return PostGamePlayerFeedback(p, FeedbackChannel.ExperienceDiscoveryPage, p2, p3, p4, p5):andThen(function(p6)
			return Promise.resolve(p6)
		end, function(p6)
			return Promise.reject(p6)
		end)
	end)
end

function SubmitGamePlayerFeedback.GetPostingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return SubmitGamePlayerFeedback
