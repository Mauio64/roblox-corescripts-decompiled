local ContentSharingRodux = script:FindFirstAncestor("ContentSharingRodux")
local ContentSharingRoduxParent = ContentSharingRodux.Parent
local Cryo = require(ContentSharingRoduxParent.Cryo)
local Rodux = require(ContentSharingRoduxParent.Rodux)
local mergeSortPosts = require(ContentSharingRodux.Utils.mergeSortPosts)
local FFlagContentFeedEnableReactions = require(ContentSharingRoduxParent.SharedFlags).FFlagContentFeedEnableReactions
local t1 = {
	byUserId = {}
}

local function v8(p1) -- line: 35
	local t2 = {}

	for _, v18 in p1 do
		local t3 = {}

		if v18.reactions then
			for _, v21 in v18.reactions do
				t3[v21.emoteId] = v21
			end
		end

		t2[v18.postId] = t3
	end

	return t2
end
local function v9(p2, p3) -- line: 61
	-- upvalues: mergeSortPosts (copy), FFlagContentFeedEnableReactions (copy), Cryo (copy), v8 (copy)
	if #p3.responseBody.posts == 0 then
		return p2
	end

	local str = tostring(p3.responseBody.posts[1].creatorUserId)
	local t4 = {}

	if p2.byUserId[str] ~= nil then
		local t5 = {}
		local nextTimeCursor = p2.byUserId[str].nextTimeCursor
		local nextTimeCursor2 = p3.responseBody.nextTimeCursor

		t5.nextTimeCursor = if nextTimeCursor ~= nil and nextTimeCursor2 ~= nil then math.max(nextTimeCursor, nextTimeCursor2) else nil
		t5.posts = mergeSortPosts(p2.byUserId[str].posts or {}, p3.responseBody.posts)

		local previousTimeCursor = p2.byUserId[str].previousTimeCursor
		local previousTimeCursor2 = p3.responseBody.previousTimeCursor

		t5.previousTimeCursor = if previousTimeCursor ~= nil and previousTimeCursor2 ~= nil then math.min(previousTimeCursor, previousTimeCursor2) else nil
		t5.reactionsByPostId = if not FFlagContentFeedEnableReactions then nil else Cryo.Dictionary.join(p2.byUserId[str].reactionsByPostId or {}, (v8(p3.responseBody.posts)))
		t4[str] = t5
	else
		t4[str] = {
			nextTimeCursor = p3.responseBody.nextTimeCursor,
			posts = p3.responseBody.posts,
			previousTimeCursor = p3.responseBody.previousTimeCursor,
			reactionsByPostId = if not FFlagContentFeedEnableReactions then nil else v8(p3.responseBody.posts)
		}
	end

	return {
		byUserId = Cryo.Dictionary.join(p2.byUserId, t4)
	}
end
local function v10(p4, p5) -- line: 94
	-- upvalues: Cryo (copy), FFlagContentFeedEnableReactions (copy), v8 (copy)
	local str = tostring(p5.queryArgs.userId)

	return {
		byUserId = Cryo.Dictionary.join(p4.byUserId, {
			[str] = {
				nextTimeCursor = p5.responseBody.nextTimeCursor,
				posts = p5.responseBody.posts,
				previousTimeCursor = p5.responseBody.previousTimeCursor,
				reactionsByPostId = if not FFlagContentFeedEnableReactions then nil else v8(p5.responseBody.posts)
			}
		})
	}
end

return function(p6) -- line: 104
	-- upvalues: Rodux (copy), t1 (copy), v10 (copy), v9 (copy)
	local ContentSharingNetworking = p6.ContentSharingNetworking

	return Rodux.createReducer(t1, {
		[ContentSharingNetworking.GetPostsByUserId.Succeeded.name] = v10,
		[ContentSharingNetworking.GetPostsByPostId.Succeeded.name] = v10,
		[ContentSharingNetworking.GetPostsByCursor.Succeeded.name] = v9
	})
end
