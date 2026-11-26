require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local isCanonicalNonzeroUuid = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/isCanonicalNonzeroUuid")

local function decodeReactions(reactions)
	if type(reactions) ~= "table" or type(reactions.counts) ~= "table" then
		return nil
	end

	local count = #reactions.counts
	local countsByEmoteId = {}
	local count2 = 0
	local v5 = {}

	for k, count3 in reactions.counts do
		if
			type(k) ~= "number"
			or k % 1 ~= 0
			or k < 1
			or count < k
			or type(count3) ~= "table"
			or not isCanonicalNonzeroUuid(count3.emoteId)
			or type(count3.count) ~= "number"
			or count3.count < 0
			or count3.count % 1 ~= 0
			or countsByEmoteId[count3.emoteId] ~= nil
		then
			return nil
		end

		count2 += 1
		countsByEmoteId[count3.emoteId] = count3.count
		table.insert(v5, { emoteId = count3.emoteId, count = count3.count })
	end

	if count2 ~= count then
		return nil
	end

	local v6

	if reactions.userReaction == nil then
		return { counts = v5, userReaction = v6 }
	end

	if
		type(reactions.userReaction) ~= "table"
		or not isCanonicalNonzeroUuid(reactions.userReaction.emoteId)
		or (countsByEmoteId[reactions.userReaction.emoteId] or 0) <= 0
	then
		return nil
	end

	v6 = { emoteId = reactions.userReaction.emoteId }

	return { counts = v5, userReaction = v6 }
end

local function convertApiCommentToComment(data)
	if type(data) ~= "table" or (type(data.commentId) ~= "string" or data.commentId == "") then
		return nil
	end

	if
		type(data.feedItemId) ~= "string"
		or data.feedItemId == ""
		or (type(data.authorUserId) ~= "string" or data.authorUserId == "")
	then
		return nil
	end

	if type(data.text) ~= "string" or (type(data.createdAt) ~= "string" or data.createdAt == "") then
		return nil
	end

	if data.isAuthoredByViewer ~= nil and type(data.isAuthoredByViewer) ~= "boolean" then
		return nil
	end

	local v5 = {
		commentId = data.commentId,
		feedItemId = data.feedItemId,
		status = "Active",
		author = { userId = data.authorUserId },
		text = data.text,
		translatedText = 0,
		createdAt = 0,
		editedAt = nil,
		isAuthoredByViewer = 0,
		reactions = 0
	}

	local v6 = if type(data.translatedText) == "string" and data.translatedText ~= "" and data.translatedText ~= data.text then data.translatedText else nil
	v5.translatedText = v6

	v5.createdAt = data.createdAt

	v5.isAuthoredByViewer = data.isAuthoredByViewer == true
	local v7 = if data.reactions ~= nil then decodeReactions(data.reactions) else nil
	v5.reactions = v7
	return v5
end

return convertApiCommentToComment
