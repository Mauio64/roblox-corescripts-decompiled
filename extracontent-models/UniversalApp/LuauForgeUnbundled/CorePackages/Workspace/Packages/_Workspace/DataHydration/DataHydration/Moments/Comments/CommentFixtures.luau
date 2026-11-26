require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local v5 = {
	feedItemId = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
	commentId = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb",
	secondCommentId = "cccccccc-cccc-cccc-cccc-cccccccccccc",
	otherFeedItemId = "dddddddd-dddd-dddd-dddd-dddddddddddd",
	otherCommentId = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee",
	nonexistentCommentId = "ffffffff-ffff-ffff-ffff-ffffffffffff",
	thumbsUpEmoteId = "ceaa4d10-c6e5-4dbe-97ef-9c2ee37f9a30",
	unknownEmoteId = "b19f82d3-774b-45a3-a9f7-729d643d126e"
}

local v6 = {
	roblox = {
		userId = "1",
		username = "Roblox",
		displayName = "Roblox",
		hasVerifiedBadge = true
	},
	builderman = {
		userId = "156",
		username = "builderman",
		displayName = "builderman",
		hasVerifiedBadge = true
	},
	shedletsky = { userId = "261", username = "Shedletsky", displayName = "Shedletsky" },
	sceleratis = {
		userId = "1237666",
		username = "Sceleratis",
		displayName = "Sceleratis"
	},
	webGL3D = { userId = "48103520", username = "WebGL3D", displayName = "WebGL3D" },
	unavailableAvatar = { userId = "999999999999999" },
	malformedAvatar = { userId = "not-a-user-id" }
}
local v7 = {
	AUTHORS = v6,
	ERRORS = {
		TextFilterRejected = {
			errorCode = "TextFilterRejected",
			message = "text did not pass filter"
		},
		RateLimited = { errorCode = "RateLimited", message = "too many requests" },
		ViewerNotEligibleToReact = {
			errorCode = "ViewerNotEligibleToReact",
			message = "the viewer cannot react to comments"
		}
	},
	REACTION_IDS = v5,
	REACTIONS = {
		empty = { counts = {}, userReaction = nil },
		selectedThumbsUp = {
			counts = {
				{ emoteId = v5.thumbsUpEmoteId, count = 3 }
			},
			userReaction = { emoteId = v5.thumbsUpEmoteId }
		},
		selectedUnknown = {
			counts = {
				{ emoteId = v5.unknownEmoteId, count = 1 }
			},
			userReaction = { emoteId = v5.unknownEmoteId }
		}
	},
	makeComment = function(items)
		local comment = {
			commentId = "c-1",
			feedItemId = "feed-1",
			status = "Active",
			author = v6.roblox,
			text = "This moment is fire",
			createdAt = "2026-08-12T12:00:00Z",
			isAuthoredByViewer = false
		}

		if items then
			for k, item in items do
				comment[k] = item
			end
		end

		return comment
	end,
	makeEnvelope = function(items)
		local envelope = {
			count = 25,
			countIsCapped = false,
			creatorEnabled = true,
			viewerCanRead = true,
			viewerCanWrite = true
		}

		if items then
			for k, item in items do
				envelope[k] = item
			end
		end

		return envelope
	end,
	cappedEnvelope = 0
}

local v8 = { count = 99, countIsCapped = true }
local v9 = {
	count = 25,
	countIsCapped = false,
	creatorEnabled = true,
	viewerCanRead = true,
	viewerCanWrite = true
}

if v8 then
	for k, v10 in v8 do
		v9[k] = v10
	end
end

v7.cappedEnvelope = v9
return v7
