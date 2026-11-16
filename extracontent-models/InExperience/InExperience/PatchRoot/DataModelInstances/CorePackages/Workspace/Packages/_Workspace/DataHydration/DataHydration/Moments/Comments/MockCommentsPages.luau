local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)
local CommentFixtures = require(script.Parent.CommentFixtures)

local v = {
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

local function createdAtAgo(ageSeconds: number, p: number?) -- 6 equivalent calls inferred from this helper
	local v2 = p or DateTime.now().UnixTimestamp
	return DateTime.fromUnixTimestamp(v2 - ageSeconds):ToIsoDate()
end

local function namespacedCommentId(p: string, commentId: string) -- 1 equivalent call inferred from this helper
	return `{p}:{commentId}`
end

local function page1(feedItemId: string, p: number?)
	return {
		comments = {
			CommentFixtures.makeComment({
				commentId = `{feedItemId}:c-1`,
				feedItemId = feedItemId,
				text = "can't believe that worked on the first try lol",
				createdAt = createdAtAgo(7200, p), -- inferred equivalent call
				author = CommentFixtures.AUTHORS.roblox
			}),
			CommentFixtures.makeComment({
				commentId = `{feedItemId}:c-2`,
				feedItemId = feedItemId,
				text = "the music sync at the end is so good",
				createdAt = createdAtAgo(25200, p), -- inferred equivalent call
				author = CommentFixtures.AUTHORS.builderman
			})
		},
		nextCursor = "page-empty",
		hasMore = true
	}
end

local function emptyHasMorePage() -- 1 equivalent call inferred from this helper
	return { comments = {}, nextCursor = "page-3", hasMore = true }
end

local function reactionPage(feedItemId: string, p: number?)
	local REACTION_IDS = CommentFixtures.REACTION_IDS
	local comments

	if feedItemId == REACTION_IDS.feedItemId then
		comments = {
			CommentFixtures.makeComment({
				commentId = REACTION_IDS.commentId,
				feedItemId = feedItemId,
				text = "canonical comment reaction fixture",
				createdAt = createdAtAgo(3600, p), -- inferred equivalent call
				author = CommentFixtures.AUTHORS.roblox,
				reactions = CommentFixtures.REACTIONS.empty
			}),
			CommentFixtures.makeComment({
				commentId = REACTION_IDS.secondCommentId,
				feedItemId = feedItemId,
				text = "canonical selected reaction fixture",
				createdAt = createdAtAgo(7200, p), -- inferred equivalent call
				author = CommentFixtures.AUTHORS.builderman,
				reactions = CommentFixtures.REACTIONS.selectedUnknown
			})
		}
	else
		comments = { CommentFixtures.makeComment({
				commentId = REACTION_IDS.otherCommentId,
				feedItemId = feedItemId,
				text = "canonical wrong-parent reaction fixture",
				createdAt = createdAtAgo(3600, p), -- inferred equivalent call
				author = CommentFixtures.AUTHORS.shedletsky,
				reactions = CommentFixtures.REACTIONS.empty
			}) }
	end

	return { comments = comments, nextCursor = nil, hasMore = false }
end

local function page3(feedItemId: string, p: number?)
	local comments = table.create(#v)

	for _, v2 in v do
		local makeComment = CommentFixtures.makeComment
		local v3 = {
			commentId = namespacedCommentId(feedItemId, v2.commentId), -- inferred equivalent call
			feedItemId = feedItemId,
			text = v2.text,
			translatedText = v2.translatedText,
			createdAt = createdAtAgo(v2.ageSeconds, p), -- inferred equivalent call
			author = v2.author
		}
		table.insert(comments, makeComment(v3))
	end

	return { comments = comments, nextCursor = nil, hasMore = false }
end

return {
	EMPTY_HAS_MORE_CURSOR = "page-empty",
	PAGE_3_CURSOR = "page-3",
	page1 = page1,
	reactionPage = reactionPage,
	emptyHasMorePage = emptyHasMorePage,
	page3 = page3,
	pageForCursor = function(feedItemId: string, p: string?, p2: number?)
		if
			(p == nil or p == "")
			and (feedItemId == CommentFixtures.REACTION_IDS.feedItemId or feedItemId == CommentFixtures.REACTION_IDS.otherFeedItemId)
		then
			return reactionPage(feedItemId, p2)
		end

		if p == nil or p == "" then
			return page1(feedItemId, p2)
		end

		if p == "page-empty" then
			return emptyHasMorePage() -- inferred equivalent call
		elseif p == "page-3" then
			return page3(feedItemId, p2)
		end

		return { comments = {}, nextCursor = nil, hasMore = false }
	end
}
