require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local CommentFixtures = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Comments/CommentFixtures")

local v5 = {
	{
		commentId = "c-3",
		text = "okay the camera turn at the end was actually perfect",
		ageSeconds = 64800,
		author = CommentFixtures.AUTHORS.shedletsky
	},
	{
		commentId = "c-4",
		text = "i tried this and immediately fell off the map 😭",
		ageSeconds = 86400,
		author = CommentFixtures.AUTHORS.webGL3D
	},
	{
		commentId = "c-5",
		text = "¿qué configuración usas para esto?",
		translatedText = "what settings are you using for this?",
		ageSeconds = 172800,
		author = CommentFixtures.AUTHORS.sceleratis
	},
	{
		commentId = "c-6",
		text = "avatar service said no, but this comment should still render normally",
		ageSeconds = 259200,
		author = CommentFixtures.AUTHORS.unavailableAvatar
	},
	{
		commentId = "c-7",
		text = "no way you landed that first try",
		ageSeconds = 432000,
		author = CommentFixtures.AUTHORS.roblox
	},
	{
		commentId = "c-8",
		text = "saving this so i can practice later",
		ageSeconds = 518400,
		author = CommentFixtures.AUTHORS.webGL3D
	},
	{
		commentId = "c-9",
		text = "the sound effect took me out 💀",
		ageSeconds = 604800,
		author = CommentFixtures.AUTHORS.shedletsky
	},
	{
		commentId = "c-10",
		text = "full tutorial please — camera sensitivity, keybinds, timing cues, practice route, and how you recover when the second jump goes wrong 🙏",
		ageSeconds = 864000,
		author = CommentFixtures.AUTHORS.sceleratis
	},
	{
		commentId = "c-25",
		text = "okay i have watched this an unreasonable number of times and i still cannot figure out how you kept enough momentum after the first turn to clear the second platform, because every time i try it i either clip the corner, lose all my speed, or launch in completely the wrong direction. i changed my sensitivity, copied the camera angle, slowed the clip down frame by frame, and even practiced the opening section for an entire evening, but the closest i got was landing on the edge and immediately sliding off. please make a full breakdown that shows the inputs, camera movement, timing, backup route, and what to do when the setup is slightly off, because this one clip has somehow become my personal final boss and i refuse to give up until i can land it consistently.",
		ageSeconds = 1036800,
		author = CommentFixtures.AUTHORS.roblox
	},
	{
		commentId = "c-11",
		text = [[
first attempt: fell instantly
second attempt: missed the ledge
third attempt: somehow landed it 😭]],
		ageSeconds = 1209600,
		author = CommentFixtures.AUTHORS.builderman
	},
	{
		commentId = "c-12",
		text = "あのリカバリーは信じられないほどきれいだった",
		translatedText = "that recovery was unbelievably clean",
		ageSeconds = 1728000,
		author = CommentFixtures.AUTHORS.roblox
	},
	{
		commentId = "c-13",
		text = "i keep coming back to watch the last five seconds",
		ageSeconds = 2505600,
		author = CommentFixtures.AUTHORS.webGL3D
	},
	{
		commentId = "c-14",
		text = "this convinced me to try the game again",
		ageSeconds = 2592000,
		author = CommentFixtures.AUTHORS.shedletsky
	},
	{
		commentId = "c-15",
		text = "the movement looks so smooth here",
		ageSeconds = 3888000,
		author = CommentFixtures.AUTHORS.sceleratis
	},
	{
		commentId = "c-16",
		text = "still one of the best clips from this update",
		ageSeconds = 5184000,
		author = CommentFixtures.AUTHORS.builderman
	},
	{
		commentId = "c-17",
		text = "this author id is malformed, so the row should use its fallback avatar and name",
		ageSeconds = 10368000,
		author = CommentFixtures.AUTHORS.malformedAvatar
	},
	{
		commentId = "c-18",
		text = "the timing on every jump is so satisfying",
		ageSeconds = 20736000,
		author = CommentFixtures.AUTHORS.webGL3D
	},
	{
		commentId = "c-19",
		text = "almost a year later and this strategy still works",
		ageSeconds = 31449600,
		author = CommentFixtures.AUTHORS.shedletsky
	},
	{
		commentId = "c-20",
		text = "this was the clip that got me into speedrunning",
		ageSeconds = 31536000,
		author = CommentFixtures.AUTHORS.sceleratis
	},
	{
		commentId = "c-21",
		text = "two years later and i finally managed to do it",
		ageSeconds = 63072000,
		author = CommentFixtures.AUTHORS.builderman
	},
	{
		commentId = "c-22",
		text = "the nostalgia in this comment section is unreal",
		ageSeconds = 94608000,
		author = CommentFixtures.AUTHORS.roblox
	},
	{
		commentId = "c-23",
		text = "this moment aged perfectly",
		ageSeconds = 157680000,
		author = CommentFixtures.AUTHORS.webGL3D
	},
	{
		commentId = "c-24",
		text = "an all-time classic",
		ageSeconds = 252288000,
		author = CommentFixtures.AUTHORS.shedletsky
	}
}

local function createdAtAgo(p2, p3)
	local v6 = p3 or DateTime.now().UnixTimestamp
	return DateTime.fromUnixTimestamp(v6 - p2):ToIsoDate()
end

local function namespacedCommentId(p2, p3)
	return `{p2}:{p3}`
end

local function page1(p2, p3)
	local makeComment = CommentFixtures.makeComment
	local v7 = {
		commentId = `{p2}:c-1`,
		feedItemId = p2,
		text = "can't believe that worked on the first try lol",
		createdAt = 0,
		author = 0
	}
	local v8 = p3 or DateTime.now().UnixTimestamp
	v7.createdAt = DateTime.fromUnixTimestamp(v8 - 7200):ToIsoDate()
	v7.author = CommentFixtures.AUTHORS.roblox
	local comment = makeComment(v7)

	local makeComment2 = CommentFixtures.makeComment
	local v9 = {
		commentId = `{p2}:c-2`,
		feedItemId = p2,
		text = "the music sync at the end is so good",
		createdAt = 0,
		author = 0
	}
	local v10 = p3 or DateTime.now().UnixTimestamp
	v9.createdAt = DateTime.fromUnixTimestamp(v10 - 25200):ToIsoDate()
	v9.author = CommentFixtures.AUTHORS.builderman
	return {
		comments = { comment, makeComment2(v9) },
		nextCursor = "page-empty",
		hasMore = true
	}
end

local function reactionPage(p2, p3)
	local REACTION_IDS = CommentFixtures.REACTION_IDS
	local v6

	if p2 == REACTION_IDS.feedItemId then
		local makeComment = CommentFixtures.makeComment
		local v7 = {
			commentId = REACTION_IDS.commentId,
			feedItemId = p2,
			text = "canonical comment reaction fixture",
			createdAt = 0,
			author = 0,
			reactions = 0
		}
		local v8 = p3 or DateTime.now().UnixTimestamp
		v7.createdAt = DateTime.fromUnixTimestamp(v8 - 3600):ToIsoDate()
		v7.author = CommentFixtures.AUTHORS.roblox
		v7.reactions = CommentFixtures.REACTIONS.empty
		local comment = makeComment(v7)

		local makeComment2 = CommentFixtures.makeComment
		local v9 = {
			commentId = REACTION_IDS.secondCommentId,
			feedItemId = p2,
			text = "canonical selected reaction fixture",
			createdAt = 0,
			author = 0,
			reactions = 0
		}
		local v10 = p3 or DateTime.now().UnixTimestamp
		v9.createdAt = DateTime.fromUnixTimestamp(v10 - 7200):ToIsoDate()
		v9.author = CommentFixtures.AUTHORS.builderman
		v9.reactions = CommentFixtures.REACTIONS.selectedUnknown
		v6 = { comment, makeComment2(v9) }
	else
		local makeComment = CommentFixtures.makeComment
		local v7 = {
			commentId = REACTION_IDS.otherCommentId,
			feedItemId = p2,
			text = "canonical wrong-parent reaction fixture",
			createdAt = 0,
			author = 0,
			reactions = 0
		}
		local v8 = p3 or DateTime.now().UnixTimestamp
		v7.createdAt = DateTime.fromUnixTimestamp(v8 - 3600):ToIsoDate()
		v7.author = CommentFixtures.AUTHORS.shedletsky
		v7.reactions = CommentFixtures.REACTIONS.empty
		v6 = { makeComment(v7) }
	end

	return { comments = v6, nextCursor = nil, hasMore = false }
end

local function page3(p2, p3)
	local v6 = table.create(#v5)

	for k, v7 in v5 do
		local makeComment = CommentFixtures.makeComment
		local v8 = {
			commentId = `{p2}:{v7.commentId}`,
			feedItemId = p2,
			text = v7.text,
			translatedText = v7.translatedText,
			createdAt = 0,
			author = 0
		}
		local ageSeconds = v7.ageSeconds
		local v9 = p3 or DateTime.now().UnixTimestamp
		v8.createdAt = DateTime.fromUnixTimestamp(v9 - ageSeconds):ToIsoDate()
		v8.author = v7.author
		table.insert(v6, makeComment(v8))
	end

	return { comments = v6, nextCursor = nil, hasMore = false }
end

return {
	EMPTY_HAS_MORE_CURSOR = "page-empty",
	PAGE_3_CURSOR = "page-3",
	page1 = page1,
	reactionPage = reactionPage,
	emptyHasMorePage = function()
		return { comments = {}, nextCursor = "page-3", hasMore = true }
	end,
	page3 = page3,
	pageForCursor = function(p2, p3, p4)
		if
			(p3 == nil or p3 == "")
			and (p2 == CommentFixtures.REACTION_IDS.feedItemId or p2 == CommentFixtures.REACTION_IDS.otherFeedItemId)
		then
			return reactionPage(p2, p4)
		end

		if p3 == nil or p3 == "" then
			return page1(p2, p4)
		end

		if p3 == "page-empty" then
			return { comments = {}, nextCursor = "page-3", hasMore = true }
		elseif p3 == "page-3" then
			return page3(p2, p4)
		end

		return { comments = {}, nextCursor = nil, hasMore = false }
	end
}
