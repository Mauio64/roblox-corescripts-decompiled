local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local SignalsExperimental = require(parent.SignalsExperimental)

local ConversationChannels = require(AppChat.Models.ConversationChannels)
require(AppChat.Stores.GetConversationStore)
local getResponseBody = require(script.Parent.getResponseBody)
local buildValidMessages = require(script.Parent.buildValidMessages)
local ingestBatch = require(script.Parent.ingestBatch)
local IngestOperation = require(script.Parent.IngestOperation)
local FFlagAppChatIngestConversationMessages = require(AppChat.Flags.FFlagAppChatIngestConversationMessages)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)
local FFlagAppChatAnyServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatAnyServerSideConversationSearch)

local function isInitialCursor(p: string?): boolean -- 1 equivalent call inferred from this helper
	return p == nil or p == ""
end

local function upsertConversationResponse(p, conversation)
	if conversation == nil or conversation.status == "failed" then
		return
	end

	if
		conversation.source == ConversationChannels.Source.Channels
		and conversation.type == ConversationChannels.Type.OneToOne
		and conversation.participant_user_ids ~= nil
	then
		p.removeConversation(ConversationChannels.getFriendConversationId(conversation.participant_user_ids))
	end

	local v = ConversationChannels.fromChannelsApi(conversation)

	if FFlagAppChatAnyServerSideConversationSearch then
		SignalsExperimental.batch(function()
			p.upsertConversation(v)

			searchIntroducedConversationIds.remove(v.id)
		end)
	else
		p.upsertConversation(v)
	end

	if FFlagAppChatIngestConversationMessages then
		local validMessages = buildValidMessages(v.id, conversation.messages or {})

		if #validMessages > 0 then
			ingestBatch(v.id, validMessages, IngestOperation.Prepend)
		end
	end
end

local function upsertConversationResponses(p, responseBody) -- 1 equivalent call inferred from this helper
	if responseBody == nil or responseBody.conversations == nil then
		return
	end

	for _, conversation in responseBody.conversations do
		upsertConversationResponse(p, conversation)
	end
end

local IngestConversationListPage = {}

function IngestConversationListPage.beginFetch(p, p2: string?)
	p.setListStatus({
		isFetchingConversations = true,
		isFetchingNextPage = p2 ~= nil and p2 ~= "",
		error = Cryo.None
	})
end

function IngestConversationListPage.ingestSuccess(p, cursor: string?, p2)
	local responseBody = getResponseBody(p2)
	local next_cursor

	if responseBody ~= nil then
		next_cursor = responseBody.next_cursor
	end

	local conversationCount = (responseBody == nil or responseBody.conversations == nil) and 0
		or #responseBody.conversations

	local v = next_cursor == nil or next_cursor == ""
	local listStatus = p.getListStatus(false)
	upsertConversationResponses(p, responseBody) -- inferred equivalent call
	local setListStatus = p.setListStatus
	local v2 = {
		isFetchingConversations = false,
		isFetchingNextPage = false,
		hasFetchedInitialPage = isInitialCursor(cursor) and true or listStatus.hasFetchedInitialPage, -- inferred equivalent call
		oldestConversationIsFetched = v,
		isExhausted = v,
		nextCursor = 0,
		error = 0
	}

	local nextCursor = if v then Cryo.None else next_cursor
	v2.nextCursor = nextCursor
	v2.error = Cryo.None
	setListStatus(v2)

	return {
		cursor = cursor,
		nextCursor = next_cursor,
		conversationCount = conversationCount,
		responseBody = responseBody
	}
end

function IngestConversationListPage.ingestFailure(p, err)
	p.setListStatus({ isFetchingConversations = false, isFetchingNextPage = false, error = err })
end

IngestConversationListPage.ingestConversationResponses = upsertConversationResponses
IngestConversationListPage.ingestConversationDetails = upsertConversationResponse
return IngestConversationListPage
