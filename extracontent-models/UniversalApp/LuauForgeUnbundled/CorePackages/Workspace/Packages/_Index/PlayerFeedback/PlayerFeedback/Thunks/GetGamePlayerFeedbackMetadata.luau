local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Http").PerformFetch
local GameGetPlayerFeedbackMetadata = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Utils/GameGetPlayerFeedbackMetadata")
local FeedbackChannel = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Enums/FeedbackChannel")
local voteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/GameVotesRodux").Enums.VoteStatus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/t")
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Loggers").flaggedMutedError
require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Types")

local function fetchKeymapper(p2)
	return "luaapp.asset-review-api.channels" .. p2
end

local v5 = { [voteStatus.VotedUp] = "Upvote", [voteStatus.VotedDown] = "Downvote" }

local function findCategoryByType(list, p2)
	for i, item in ipairs(list) do
		if item.type == p2 then
			return item
		end
	end

	return nil
end

local interface = t.interface({
	capabilities = t.interface({
		can_submit_review = t.boolean,
		can_submit_category_options = t.boolean,
		can_submit_comment = t.boolean
	}),
	categories = t.array(t.interface({
		type = t.string,
		label = t.string,
		allows_multiple_selections = t.boolean,
		options = t.array(t.interface({
			id = t.string,
			label = t.string
		}))
	})),
	comment = t.interface({
		label = t.string,
		placeholder_text = t.string,
		minimum_length = t.number,
		maximum_length = t.number
	}),
	metadata = t.interface({
		disclaimer_label = t.string,
		submit_button_label = t.string,
		form_title_label = t.string
	})
})
return {
	Get = function(p2, p3, p4, p5)
		return performFetch.Single("luaapp.asset-review-api.channels" .. p4, function(p6)
			return GameGetPlayerFeedbackMetadata(p2, FeedbackChannel.ExperienceDiscoveryPage, p4):andThen(function(p7)
				local responseBody = p7 and p7.responseBody
				local v7, v8 = interface(responseBody)

				if not v7 then
					flaggedMutedError("PlayerFeedbackMetadata", v8)
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local v9 = v5[p5]
				local categories = responseBody.categories
				local v10 = nil

				for i, category in ipairs(categories) do
					if category.type == v9 then
						v10 = category
						break
					end
				end

				if v10 == nil then
					flaggedMutedError(
						"PlayerFeedbackMetadata",
						string.format("Invalid category from player feedback metadata response: %s", v9)
					)

					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local v12 = {
					rootPlaceId = p4,
					canSubmitReview = responseBody.capabilities.can_submit_review,
					canSubmitComment = responseBody.capabilities.can_submit_comment,
					categoryType = v9,
					category = v10,
					comment = responseBody.comment,
					metadata = responseBody.metadata
				}

				return Promise.resolve(v12)
			end, function(p7)
				return Promise.reject(p7)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.asset-review-api.channels" .. p3)
	end
}
