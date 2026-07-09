local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local PlayerFeedbackParent = PlayerFeedback.Parent
local Promise = require(PlayerFeedbackParent.Promise)
local PerformFetch = require(PlayerFeedbackParent.Http).PerformFetch
local GameGetPlayerFeedbackMetadata = require(PlayerFeedback.Utils.GameGetPlayerFeedbackMetadata)
local FeedbackChannel = require(PlayerFeedback.Enums.FeedbackChannel)
local VoteStatus = require(PlayerFeedbackParent.GameVotesRodux).Enums.VoteStatus
local t = require(PlayerFeedbackParent.t)
local flaggedMutedError = require(PlayerFeedbackParent.Loggers).flaggedMutedError

require(PlayerFeedback.Types)

local function fetchKeymapper(p1) -- line: 14
	return "luaapp.asset-review-api.channels" .. p1
end

local t1 = {
	[VoteStatus.VotedUp] = "Upvote",
	[VoteStatus.VotedDown] = "Downvote"
}

local function findCategoryByType(p2, p3) -- line: 23
	for _, v in ipairs(p2) do
		if p3 == v.type then
			return v
		end
	end

	return nil
end

local t2 = {}
local v14 = t.interface({
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

function t2.Get(p4, _: string, s2: string, s3: string) -- line: 62
	-- upvalues: PerformFetch (copy), GameGetPlayerFeedbackMetadata (copy), FeedbackChannel (copy), v14 (copy), flaggedMutedError (copy), Promise (copy), t1 (copy)
	return PerformFetch.Single("luaapp.asset-review-api.channels" .. s2, function(_) -- line: 63
		-- upvalues: GameGetPlayerFeedbackMetadata (copy), p4 (copy), FeedbackChannel (copy), s2 (copy), v14 (copy), flaggedMutedError (copy), Promise (copy), t1 (copy), s3 (copy)
		return GameGetPlayerFeedbackMetadata(p4, FeedbackChannel.ExperienceDiscoveryPage, s2):andThen(function(p6) -- line: 65
			-- upvalues: v14 (copy), flaggedMutedError (copy), Promise (copy), t1 (copy), s3 (copy), s2 (copy)
			local v28 = p6 and p6.responseBody
			local v29, v30 = v14(v28)

			if not v29 then
				flaggedMutedError("PlayerFeedbackMetadata", v30)

				return Promise.reject({
					HttpError = Enum.HttpError.OK
				})
			end

			local v31 = t1[s3]
			local categories = v28.categories
			local g36 = nil
			local v35 = nil

			for _, v in ipairs(categories) do
				if v31 == v.type then
					v35 = v
					g36 = true
				end

				if g36 then
					break
				end
			end

			if not g36 then
				v35 = nil
			end

			g36 = false

			if v35 == nil then
				flaggedMutedError("PlayerFeedbackMetadata", string.format("Invalid category from player feedback metadata response: %s", v31))

				return Promise.reject({
					HttpError = Enum.HttpError.OK
				})
			end

			local t3 = {
				rootPlaceId = s2,
				canSubmitReview = v28.capabilities.can_submit_review,
				canSubmitComment = v28.capabilities.can_submit_comment,
				categoryType = v31,
				category = v35,
				comment = v28.comment,
				metadata = v28.metadata
			}

			return Promise.resolve(t3)
		end, function(p7) -- line: 94
			-- upvalues: Promise (copy)
			return Promise.reject(p7)
		end)
	end)
end
function t2.GetFetchingStatus(p8, p9) -- line: 100
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p8, "luaapp.asset-review-api.channels" .. p9)
end

return t2
