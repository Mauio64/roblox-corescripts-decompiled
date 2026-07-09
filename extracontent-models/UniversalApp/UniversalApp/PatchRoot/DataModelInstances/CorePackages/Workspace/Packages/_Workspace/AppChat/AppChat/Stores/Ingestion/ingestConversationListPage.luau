local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChatParent.AppChatNetworking)

local Cryo = require(AppChatParent.Cryo)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

require(AppChat.Stores.GetConversationStore)

local getResponseBody = require(script.Parent.getResponseBody)

local function isInitialCursor(s1: string?) -- line: 18
	return s1 == nil or s1 == ""
end
local function upsertConversationResponse(p1, p2) -- line: 22
	-- upvalues: ConversationChannels (copy)
	if p2 == nil or p2.status == "failed" then
		return
	end

	if p2.source == ConversationChannels.Source.Channels and p2.type == ConversationChannels.Type.OneToOne and p2.participant_user_ids ~= nil then
		p1.removeConversation(ConversationChannels.getFriendConversationId(p2.participant_user_ids))
	end

	p1.upsertConversation(ConversationChannels.fromChannelsApi(p2))
end
local function upsertConversationResponses(p3, p4) -- line: 43
	-- upvalues: upsertConversationResponse (copy)
	if p4 == nil or p4.conversations == nil then
		return
	end

	for _, v15 in p4.conversations do
		upsertConversationResponse(p3, v15)
	end
end

return {
	beginFetch = function(p5, s2: string?) -- line: 56
		-- upvalues: Cryo (copy)
		p5.setListStatus({
			isFetchingConversations = true,
			isFetchingNextPage = not (s2 == nil or s2 == ""),
			error = Cryo.None
		})
	end,
	ingestSuccess = function(p6, s3: string?, p7) -- line: 64
		-- upvalues: getResponseBody (copy), upsertConversationResponse (copy), Cryo (copy)
		local v21 = getResponseBody(p7)
		local v22 = if v21 == nil then nil else v21.next_cursor
		local v23 = (v21 == nil or v21.conversations == nil) and 0 or #v21.conversations
		local v24 = v22 == nil or v22 == ""
		local v25 = p6.getListStatus(false)

		if v21 ~= nil and v21.conversations ~= nil then
			for _, v27 in v21.conversations do
				upsertConversationResponse(p6, v27)
			end
		end

		p6.setListStatus({
			isFetchingConversations = false,
			isFetchingNextPage = false,
			hasFetchedInitialPage = not not (s3 == nil or s3 == "") or v25.hasFetchedInitialPage,
			oldestConversationIsFetched = v24,
			isExhausted = v24,
			nextCursor = if not v24 then v22 else Cryo.None,
			error = Cryo.None
		})

		return {
			cursor = s3,
			nextCursor = v22,
			conversationCount = v23,
			responseBody = v21
		}
	end,
	ingestFailure = function(p8, p9) -- line: 96
		p8.setListStatus({
			isFetchingConversations = false,
			isFetchingNextPage = false,
			error = p9
		})
	end,
	ingestConversationResponses = upsertConversationResponses,
	ingestConversationDetails = upsertConversationResponse
}
