local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)
local isCanonicalNonzeroUuid = require(script.Parent.isCanonicalNonzeroUuid)

local function decodeReactions(reactions)
	if type(reactions) ~= "table" or type(reactions.counts) ~= "table" then
		return nil
	end

	local count = #reactions.counts
	local countsByEmoteId = {}
	local count2 = 0
	local counts = {}

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
		table.insert(counts, { emoteId = count3.emoteId, count = count3.count })
	end

	if count2 ~= count then
		return nil
	end

	local userReaction

	if reactions.userReaction == nil then
		return { counts = counts, userReaction = userReaction }
	end

	if
		type(reactions.userReaction) ~= "table"
		or not isCanonicalNonzeroUuid(reactions.userReaction.emoteId)
		or (countsByEmoteId[reactions.userReaction.emoteId] or 0) <= 0
	then
		return nil
	end

	userReaction = { emoteId = reactions.userReaction.emoteId }

	return { counts = counts, userReaction = userReaction }
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

	local v = {
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
	local translatedText

	if type(data.translatedText) == "string" and data.translatedText ~= "" and data.translatedText ~= data.text then
		translatedText = data.translatedText
	end

	v.translatedText = translatedText

	v.createdAt = data.createdAt

	v.isAuthoredByViewer = data.isAuthoredByViewer == true
	local reactions

	if data.reactions ~= nil then
		reactions = decodeReactions(data.reactions)
	end

	v.reactions = reactions
	return v
end

return convertApiCommentToComment
