local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local parent = PlayerFeedback.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local GameGetPlayerFeedbackMetadata = require(PlayerFeedback.Utils.GameGetPlayerFeedbackMetadata)
local FeedbackChannel = require(PlayerFeedback.Enums.FeedbackChannel)
local GameVotesRodux = require(parent.GameVotesRodux)
local VoteStatus = GameVotesRodux.Enums.VoteStatus
local t = require(parent.t)
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError
require(PlayerFeedback.Types)

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.asset-review-api.channels" .. p
end

local v = { [VoteStatus.VotedUp] = "Upvote", [VoteStatus.VotedDown] = "Downvote" }

local function findCategoryByType(categories, p) -- 1 equivalent call inferred from this helper
	for _, item in ipairs(categories) do
		if item.type == p then
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
		options = t.array(t.interface({ id = t.string, label = t.string }))
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
local GetGamePlayerFeedbackMetadata = {}

function GetGamePlayerFeedbackMetadata.Get(p, _: string, rootPlaceId: string, p2: string)
	return PerformFetch.Single(fetchKeymapper(rootPlaceId), function(_) -- inferred equivalent call
		return GameGetPlayerFeedbackMetadata(p, FeedbackChannel.ExperienceDiscoveryPage, rootPlaceId):andThen(
			function(p3)
				local responseBody = p3 and p3.responseBody
				local v2, v3 = interface(responseBody)

				if not v2 then
					flaggedMutedError("PlayerFeedbackMetadata", v3)
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local categoryType = v[p2]
				local categoryByType = findCategoryByType(responseBody.categories, categoryType) -- inferred equivalent call

				if categoryByType == nil then
					flaggedMutedError(
						"PlayerFeedbackMetadata",
						string.format("Invalid category from player feedback metadata response: %s", categoryType)
					)

					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local v4 = {
					rootPlaceId = rootPlaceId,
					canSubmitReview = responseBody.capabilities.can_submit_review,
					canSubmitComment = responseBody.capabilities.can_submit_comment,
					categoryType = categoryType,
					category = categoryByType,
					comment = responseBody.comment,
					metadata = responseBody.metadata
				}

				return Promise.resolve(v4)
			end,
			function(p3)
				return Promise.reject(p3)
			end
		)
	end)
end

function GetGamePlayerFeedbackMetadata.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return GetGamePlayerFeedbackMetadata
