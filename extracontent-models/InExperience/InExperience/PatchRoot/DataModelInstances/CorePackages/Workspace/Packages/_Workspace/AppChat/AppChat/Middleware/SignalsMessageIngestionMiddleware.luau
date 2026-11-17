local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local AppChatNetworking = require(parent.AppChatNetworking)
local SharedFlags = require(parent.SharedFlags)

local buildConversationMessageFromApi = require(AppChat.Stores.Ingestion.buildConversationMessageFromApi)
local ingestBatch = require(AppChat.Stores.Ingestion.ingestBatch)
local IngestOperation = require(AppChat.Stores.Ingestion.IngestOperation)

local Conversations = require(AppChat.Conversations)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local SendingMessage = Conversations.Actions.SendingMessage
local SentMessage = Conversations.Actions.SentMessage
local MessageModerated = Conversations.Actions.MessageModerated
local MessageFailedToSend = Conversations.Actions.MessageFailedToSend
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)

require(AppChat.MessageData.Types)
local Enums = require(AppChat.MessageData.Enums)
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local GetMessageReactionsStore = require(AppChat.Stores.GetMessageReactionsStore)
local GetMessageReactionsViewModelStore = require(AppChat.Stores.GetMessageReactionsViewModelStore)

local FFlagAppChatIncrementalPaginationProjection = require(AppChat.Flags.FFlagAppChatIncrementalPaginationProjection)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local FFlagAppChatEnableReactions = SharedFlags.FFlagAppChatEnableReactions

local function determineStatus(isSending: boolean?, failed: boolean?, moderated: boolean?, visibility: string?) -- 1 equivalent call inferred from this helper
	if isSending then
		return MessageStatus.Pending
	end

	if failed then
		return MessageStatus.Failed
	end

	if moderated then
		return MessageStatus.Moderated
	end

	if visibility == MessageVisibility.Hidden then
		return MessageStatus.Hidden
	end

	return MessageStatus.Default
end

local function extractLegacyTimestamp(sent)
	if sent == nil or typeof(sent) ~= "table" then
		return nil
	end

	if sent.ToIsoDate then
		return sent:ToIsoDate()
	end

	local unixTimestamp = nil

	if sent.GetUnixTimestamp then
		unixTimestamp = sent:GetUnixTimestamp()
	elseif sent.UnixTimestamp then
		unixTimestamp = sent.UnixTimestamp
	end

	if unixTimestamp and unixTimestamp > 0 then
		local success, result = pcall(DateTime.fromUnixTimestamp, unixTimestamp)

		if success and result then
			return result:ToIsoDate()
		end
	end

	return nil
end

local function buildFromLegacy(data, conversationId: string)
	local replies_to

	if data.repliesTo and data.repliesTo.id then
		replies_to = {
			id = data.repliesTo.id,
			content = data.repliesTo.content,
			sender_user_id = 0,
			created_at = 0,
			type = 0
		}
		local sender_user_id

		if data.repliesTo.senderTargetId then
			sender_user_id = tonumber(data.repliesTo.senderTargetId)
		end

		replies_to.sender_user_id = sender_user_id
		replies_to.created_at = extractLegacyTimestamp(data.repliesTo.sent)
		local v

		if data.repliesTo.messageType == "System" then
			v = MessageType.System
		else
			v = MessageType.User
		end

		replies_to.type = v
	end

	local v = {
		id = data.id or data.messageId,
		type = 0,
		content = 0,
		created_at = 0,
		sender_user_id = 0,
		moderation_type = 0,
		visibility = 0,
		preview_content = 0,
		content_to_display = 0,
		replies_to = 0,
		cards = 0,
		filtered_for_receivers = 0,
		is_previewable = 0,
		conversationId = 0,
		status = 0,
		stableKey = 0
	}
	local v2

	if data.messageType == "System" then
		v2 = MessageType.System
	else
		v2 = MessageType.User
	end

	v.type = v2
	v.content = data.content
	v.created_at = extractLegacyTimestamp(data.sent)
	local sender_user_id

	if data.senderTargetId then
		sender_user_id = tonumber(data.senderTargetId)
	end

	v.sender_user_id = sender_user_id
	v.moderation_type = data.moderationType
	v.visibility = data.visibility
	v.preview_content = data.previewContent
	v.content_to_display = data.contentToDisplay or data.content
	v.replies_to = replies_to
	local cards

	if GetFFlagEnableSocialCards() then
		cards = data.cards
	end

	v.cards = cards
	v.filtered_for_receivers = data.filteredForReceivers
	v.is_previewable = data.isPreviewable

	v.conversationId = conversationId
	v.status = determineStatus(data.isSending, data.failed, data.moderated, data.visibility) -- inferred equivalent call
	v.stableKey = data.stableKey or data.stable_key or data.id or data.messageId
	return v
end

local function clearConversationStores(data, conversationId: string)
	local orderedIds = data.conversationMessageListStore.getOrderedIds(conversationId)

	for _, orderedId in orderedIds do
		data.conversationMessageStore.removeMessage(orderedId)
	end

	if FFlagAppChatEnableReactions then
		GetMessageReactionsStore(false).evictMessageReactions(orderedIds)
		GetMessageReactionsViewModelStore(false).evictMessages(orderedIds)
	end

	data.conversationMessageViewModelStore.evictConversation(conversationId)
	data.conversationMessageListStore.clearConversation(conversationId)
end

local function handleReceivedMessages(p, _)
	local conversationId = p.conversationId
	local messages = p.messages

	if messages and conversationId then
		ingestBatch(conversationId, Cryo.List.filterMap(messages, function(p2)
			if p2 and p2.id then
				return buildFromLegacy(p2, conversationId)
			end

			return nil
		end), IngestOperation.Prepend)
	end
end

local function handleSendingMessage(p, _)
	local conversationId = p.conversationId
	local message = p.message

	if message and message.id and conversationId then
		local v = buildFromLegacy(message, conversationId)
		v.status = MessageStatus.Pending
		ingestBatch(conversationId, { v }, IngestOperation.Prepend)
	end
end

local function handleSentMessage(p, p2)
	local conversationId = p.conversationId
	local messageId = p.messageId

	if conversationId and messageId then
		p2.conversationMessageListStore.removeMessage(conversationId, messageId)
		p2.conversationMessageStore.removeMessage(messageId)
	end
end

local function handleMessageModerated(p, p2)
	local messageId = p.messageId

	if messageId then
		p2.conversationMessageStore.updateMessage(messageId, { status = MessageStatus.Moderated })

		if FFlagAppChatIncrementalPaginationProjection and p.conversationId then
			p2.conversationMessageListStore.publishMessageUpdates(p.conversationId, { messageId })
		end
	end
end

local function handleMessageFailedToSend(p, p2)
	local messageId = p.messageId

	if messageId then
		p2.conversationMessageStore.updateMessage(messageId, { status = MessageStatus.Failed })

		if FFlagAppChatIncrementalPaginationProjection and p.conversationId then
			p2.conversationMessageListStore.publishMessageUpdates(p.conversationId, { messageId })
		end
	end
end

local function handleGetOlderMessagesSucceeded(p, _)
	local conversation_id = p.queryArgs and p.queryArgs.conversation_id
	local responseBody = p.responseBody

	if conversation_id and responseBody and responseBody.messages then
		local filterMap = Cryo.List.filterMap(responseBody.messages, function(p2)
			if p2 and p2.id then
				return (buildConversationMessageFromApi(p2, conversation_id))
			end

			return nil
		end)

		local next_cursor = responseBody.next_cursor
		local appendAndAdvanceCursor = IngestOperation.AppendAndAdvanceCursor

		if next_cursor == "" then
			next_cursor = nil
		end

		ingestBatch(conversation_id, filterMap, appendAndAdvanceCursor, next_cursor)
	end
end

local function handleGetNewerMessagesSucceeded(p, _)
	local conversation_id = p.queryArgs and p.queryArgs.conversation_id
	local responseBody = p.responseBody

	if conversation_id and responseBody and responseBody.messages then
		ingestBatch(conversation_id, Cryo.List.filterMap(responseBody.messages, function(p2)
			if p2 and p2.id then
				return (buildConversationMessageFromApi(p2, conversation_id))
			end

			return nil
		end), IngestOperation.Prepend)
	end
end

local function ingestConversationsFromResponse(responseBody, _)
	if not (responseBody and responseBody.conversations) then
		return
	end

	for _, conversation in responseBody.conversations do
		local id = conversation.id

		if id and conversation.messages then
			ingestBatch(id, Cryo.List.filterMap(conversation.messages, function(p)
				if p and p.id then
					return (buildConversationMessageFromApi(p, id))
				end

				return nil
			end), IngestOperation.Prepend)
		end
	end
end

local function handleGetUserConversationsSucceeded(p, p2)
	ingestConversationsFromResponse(p.responseBody, p2)
end

local function handleGetConversationDetailsSucceeded(p, p2)
	ingestConversationsFromResponse(p.responseBody, p2)
end

local function handleMultiGetConversationDetailsSucceeded(p, p2)
	ingestConversationsFromResponse(p.responseBody, p2)
end

local function handleRemovedConversation(p, p2)
	local conversationId = p.conversationId

	if conversationId then
		clearConversationStores(p2, conversationId)
	end
end

local function handleReloadedMessagesForConversations(p, p2)
	local conversationIds = p.conversationIds

	if conversationIds then
		for _, conversationId in conversationIds do
			clearConversationStores(p2, conversationId)
		end
	end
end

local v = {
	[ReceivedMessages.name] = handleReceivedMessages,
	[SendingMessage.name] = handleSendingMessage,
	[SentMessage.name] = handleSentMessage,
	[MessageModerated.name] = handleMessageModerated,
	[MessageFailedToSend.name] = handleMessageFailedToSend,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = handleGetOlderMessagesSucceeded,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = handleGetNewerMessagesSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = handleGetUserConversationsSucceeded,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = handleMultiGetConversationDetailsSucceeded,
	[RemovedConversation.name] = handleRemovedConversation,
	[ReloadedMessagesForConversations.name] = handleReloadedMessagesForConversations
}

local function SignalsMessageIngestionMiddleware(callback, _)
	return function(p)
		local v2 = callback(p)

		if not FFlagAppChatSignalsMessageStore then
			return v2
		end

		local v3 = v[p.type]

		if v3 then
			local conversationMessageViewModelStore = GetConversationMessageViewModelStore(false)
			v3(p, {
				conversationMessageStore = conversationMessageViewModelStore.conversationMessageStore,
				conversationMessageListStore = conversationMessageViewModelStore.conversationMessageListStore,
				conversationMessageViewModelStore = conversationMessageViewModelStore
			})
		end

		return v2
	end
end

return SignalsMessageIngestionMiddleware
