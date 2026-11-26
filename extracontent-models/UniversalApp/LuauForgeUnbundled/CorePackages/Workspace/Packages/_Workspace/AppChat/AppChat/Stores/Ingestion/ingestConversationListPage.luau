require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local getResponseBody = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/getResponseBody")
local buildValidMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/buildValidMessages")
local ingestBatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/ingestBatch")
local IngestOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/IngestOperation")
local FFlagAppChatIngestConversationMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIngestConversationMessages")
local searchIntroducedConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/searchIntroducedConversationIds")
local FFlagAppChatAnyServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAnyServerSideConversationSearch")

local function isInitialCursor(p2): boolean
	return p2 == nil or p2 == ""
end

local function upsertConversationResponse(p2, conversation)
	if conversation == nil or conversation.status == "failed" then
		return
	end

	if
		conversation.source == ConversationChannels.Source.Channels
		and conversation.type == ConversationChannels.Type.OneToOne
		and conversation.participant_user_ids ~= nil
	then
		p2.removeConversation(ConversationChannels.getFriendConversationId(conversation.participant_user_ids))
	end

	local v5 = ConversationChannels.fromChannelsApi(conversation)

	if FFlagAppChatAnyServerSideConversationSearch then
		SignalsExperimental.batch(function()
			p2.upsertConversation(v5)

			searchIntroducedConversationIds.remove(v5.id)
		end)
	else
		p2.upsertConversation(v5)
	end

	if FFlagAppChatIngestConversationMessages then
		local v6 = buildValidMessages(v5.id, conversation.messages or {})

		if #v6 > 0 then
			ingestBatch(v5.id, v6, IngestOperation.Prepend)
		end
	end
end

local function upsertConversationResponses(p2, p3)
	if p3 == nil or p3.conversations == nil then
		return
	end

	for k, conversation in p3.conversations do
		upsertConversationResponse(p2, conversation)
	end
end

return {
	beginFetch = function(p2, p3)
		p2.setListStatus({
			isFetchingConversations = true,
			isFetchingNextPage = p3 ~= nil and p3 ~= "",
			error = Cryo.None
		})
	end,
	ingestSuccess = function(p2, p3, p4)
		local v5 = getResponseBody(p4)
		local next_cursor = if v5 ~= nil then v5.next_cursor else nil
		local v6 = (v5 == nil or v5.conversations == nil) and 0 or #v5.conversations

		local v7 = next_cursor == nil or next_cursor == ""
		local listStatus = p2.getListStatus(false)

		if v5 ~= nil and v5.conversations ~= nil then
			for k, conversation in v5.conversations do
				upsertConversationResponse(p2, conversation)
			end
		end

		local setListStatus = p2.setListStatus
		local v8 = {
			isFetchingConversations = false,
			isFetchingNextPage = false,
			hasFetchedInitialPage = p3 == nil or p3 == "" or listStatus.hasFetchedInitialPage,
			oldestConversationIsFetched = v7,
			isExhausted = v7,
			nextCursor = 0,
			error = 0
		}

		local v9 = if v7 then Cryo.None else next_cursor
		v8.nextCursor = v9
		v8.error = Cryo.None
		setListStatus(v8)

		return {
			cursor = p3,
			nextCursor = next_cursor,
			conversationCount = v6,
			responseBody = v5
		}
	end,
	ingestFailure = function(p2, p3)
		p2.setListStatus({
			isFetchingConversations = false,
			isFetchingNextPage = false,
			error = p3
		})
	end,
	ingestConversationResponses = upsertConversationResponses,
	ingestConversationDetails = upsertConversationResponse
}
