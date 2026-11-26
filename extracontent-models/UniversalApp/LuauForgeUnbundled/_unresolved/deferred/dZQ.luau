local module = require("@luauforge/deferred/dZM")
local module2 = require("@luauforge/deferred/dZR")

local module3 = require("@luauforge/deferred/dZS")

local fFlagContentFeedEnableReactions = require("@luauforge/deferred/dZT").FFlagContentFeedEnableReactions

local v5 = { byUserId = {} }

local function fn(posts)
	local result = {}

	for k, item in posts do
		local reactionsByEmoteId = {}

		if item.reactions then
			for k2, reaction in item.reactions do
				reactionsByEmoteId[reaction.emoteId] = reaction
			end
		end

		result[item.postId] = reactionsByEmoteId
	end

	return result
end

local function fn2(p2, p3)
	if #p3.responseBody.posts == 0 then
		return p2
	end

	local creatorUserId = tostring(p3.responseBody.posts[1].creatorUserId)

	local v6 = {}

	if p2.byUserId[creatorUserId] == nil then
		local v7 = {
			nextTimeCursor = p3.responseBody.nextTimeCursor,
			posts = p3.responseBody.posts,
			previousTimeCursor = p3.responseBody.previousTimeCursor,
			reactionsByPostId = 0
		}

		local v8 = if fFlagContentFeedEnableReactions then fn(p3.responseBody.posts) else nil
		v7.reactionsByPostId = v8

		v6[creatorUserId] = v7
	else
		local nextTimeCursor = p2.byUserId[creatorUserId].nextTimeCursor
		local nextTimeCursor2 = p3.responseBody.nextTimeCursor
		local v8 = if nextTimeCursor ~= nil and nextTimeCursor2 ~= nil then math.max(nextTimeCursor, nextTimeCursor2) else nil

		local v7 = {
			nextTimeCursor = v8,
			posts = module3(p2.byUserId[creatorUserId].posts or {}, p3.responseBody.posts),
			previousTimeCursor = 0,
			reactionsByPostId = 0
		}

		local previousTimeCursor = p2.byUserId[creatorUserId].previousTimeCursor
		local previousTimeCursor2 = p3.responseBody.previousTimeCursor
		local v9 = if previousTimeCursor ~= nil and previousTimeCursor2 ~= nil then math.min(previousTimeCursor, previousTimeCursor2) else nil

		v7.previousTimeCursor = v9

		local v10 = if fFlagContentFeedEnableReactions then module.Dictionary.join(
			p2.byUserId[creatorUserId].reactionsByPostId or {},
			fn(p3.responseBody.posts)
		) else nil
		v7.reactionsByPostId = v10
		v6[creatorUserId] = v7
	end

	return {
		byUserId = module.Dictionary.join(p2.byUserId, v6)
	}
end

local function fn3(p2, p3)
	local userId = tostring(p3.queryArgs.userId)

	local join = module.Dictionary.join
	local byUserId = p2.byUserId
	local v8 = {
		nextTimeCursor = p3.responseBody.nextTimeCursor,
		posts = p3.responseBody.posts,
		previousTimeCursor = p3.responseBody.previousTimeCursor,
		reactionsByPostId = 0
	}

	local v9 = if fFlagContentFeedEnableReactions then fn(p3.responseBody.posts) else nil
	v8.reactionsByPostId = v9

	return {
		byUserId = join(byUserId, { [userId] = v8 })
	}
end

return function(p2)
	local contentSharingNetworking = p2.ContentSharingNetworking

	return module2.createReducer(v5, {
		[contentSharingNetworking.GetPostsByUserId.Succeeded.name] = fn3,
		[contentSharingNetworking.GetPostsByPostId.Succeeded.name] = fn3,
		[contentSharingNetworking.GetPostsByCursor.Succeeded.name] = fn2
	})
end
