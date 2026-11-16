local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local buildConversationMessageFromApi = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/buildConversationMessageFromApi")
local ingestBatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/ingestBatch")
local IngestOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/IngestOperation")

local Conversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations")
local receivedMessages = Conversations.Actions.ReceivedMessages
local sendingMessage = Conversations.Actions.SendingMessage
local sentMessage = Conversations.Actions.SentMessage
local messageModerated = Conversations.Actions.MessageModerated
local messageFailedToSend = Conversations.Actions.MessageFailedToSend
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local ReloadedMessagesForConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReloadedMessagesForConversations")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Enums")
local messageStatus = Enums.MessageStatus
local messageType = Enums.MessageType
local messageVisibility = Enums.MessageVisibility
local getFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")

local FFlagAppChatIncrementalPaginationProjection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIncrementalPaginationProjection")
local FFlagAppChatSignalsMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsMessageStore")

local function determineStatus(p2, p3, p4, p5)
	if p2 then
		return messageStatus.Pending
	end

	if p3 then
		return messageStatus.Failed
	end

	if p4 then
		return messageStatus.Moderated
	end

	if p5 == messageVisibility.Hidden then
		return messageStatus.Hidden
	end

	return messageStatus.Default
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

local function buildFromLegacy(data, conversationId)
	local v5

	if data.repliesTo and data.repliesTo.id then
		v5 = {
			id = data.repliesTo.id,
			content = data.repliesTo.content,
			sender_user_id = 0,
			created_at = 0,
			type = 0
		}
		local v6 = if data.repliesTo.senderTargetId then tonumber(data.repliesTo.senderTargetId) else nil
		v5.sender_user_id = v6
		v5.created_at = extractLegacyTimestamp(data.repliesTo.sent)
		local v7 = if data.repliesTo.messageType == "System" then messageType.System else messageType.User
		v5.type = v7
	end

	local v6 = {
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
	local v7 = if data.messageType == "System" then messageType.System else messageType.User
	v6.type = v7
	v6.content = data.content
	v6.created_at = extractLegacyTimestamp(data.sent)
	local v8 = if data.senderTargetId then tonumber(data.senderTargetId) else nil
	v6.sender_user_id = v8
	v6.moderation_type = data.moderationType
	v6.visibility = data.visibility
	v6.preview_content = data.previewContent
	v6.content_to_display = data.contentToDisplay or data.content
	v6.replies_to = v5
	local v9 = if getFFlagEnableSocialCards() then data.cards else nil
	v6.cards = v9
	v6.filtered_for_receivers = data.filteredForReceivers
	v6.is_previewable = data.isPreviewable

	v6.conversationId = conversationId
	local isSending = data.isSending
	local failed = data.failed
	local moderated = data.moderated
	local visibility = data.visibility
	local v10

	if isSending then
		v10 = messageStatus.Pending
	elseif failed then
		v10 = messageStatus.Failed
	elseif moderated then
		v10 = messageStatus.Moderated
	elseif visibility == messageVisibility.Hidden then
		v10 = messageStatus.Hidden
	else
		v10 = messageStatus.Default
	end

	v6.status = v10
	v6.stableKey = data.stableKey or data.stable_key or data.id or data.messageId
	return v6
end

local function clearConversationStores(data, conversationId)
	local orderedIds = data.conversationMessageListStore.getOrderedIds(conversationId)

	for k, orderedId in orderedIds do
		data.conversationMessageStore.removeMessage(orderedId)
	end

	data.conversationMessageViewModelStore.evictConversation(conversationId)
	data.conversationMessageListStore.clearConversation(conversationId)
end

local function handleReceivedMessages(p2, p3)
	local conversationId = p2.conversationId
	local messages = p2.messages

	if messages and conversationId then
		ingestBatch(conversationId, Cryo.List.filterMap(messages, function(p4)
			if p4 and p4.id then
				return buildFromLegacy(p4, conversationId)
			end

			return nil
		end), IngestOperation.Prepend)
	end
end

local function handleSendingMessage(p2, p3)
	local conversationId = p2.conversationId
	local message = p2.message

	if message and message.id and conversationId then
		local v5 = buildFromLegacy(message, conversationId)
		v5.status = messageStatus.Pending
		ingestBatch(conversationId, { v5 }, IngestOperation.Prepend)
	end
end

local function handleSentMessage(p2, p3)
	local conversationId = p2.conversationId
	local messageId = p2.messageId

	if conversationId and messageId then
		p3.conversationMessageListStore.removeMessage(conversationId, messageId)
		p3.conversationMessageStore.removeMessage(messageId)
	end
end

local function handleMessageModerated(p2, p3)
	local messageId = p2.messageId

	if messageId then
		p3.conversationMessageStore.updateMessage(messageId, {
			status = messageStatus.Moderated
		})

		if FFlagAppChatIncrementalPaginationProjection and p2.conversationId then
			p3.conversationMessageListStore.publishMessageUpdates(p2.conversationId, { messageId })
		end
	end
end

local function handleMessageFailedToSend(p2, p3)
	local messageId = p2.messageId

	if messageId then
		p3.conversationMessageStore.updateMessage(messageId, {
			status = messageStatus.Failed
		})

		if FFlagAppChatIncrementalPaginationProjection and p2.conversationId then
			p3.conversationMessageListStore.publishMessageUpdates(p2.conversationId, { messageId })
		end
	end
end

local function handleGetOlderMessagesSucceeded(p2, p3)
	local conversation_id = p2.queryArgs and p2.queryArgs.conversation_id
	local responseBody = p2.responseBody

	if conversation_id and responseBody and responseBody.messages then
		local filterMap = Cryo.List.filterMap(responseBody.messages, function(p4)
			if p4 and p4.id then
				return (buildConversationMessageFromApi(p4, conversation_id))
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

local function handleGetNewerMessagesSucceeded(p2, p3)
	local conversation_id = p2.queryArgs and p2.queryArgs.conversation_id
	local responseBody = p2.responseBody

	if conversation_id and responseBody and responseBody.messages then
		ingestBatch(conversation_id, Cryo.List.filterMap(responseBody.messages, function(p4)
			if p4 and p4.id then
				return (buildConversationMessageFromApi(p4, conversation_id))
			end

			return nil
		end), IngestOperation.Prepend)
	end
end

local function ingestConversationsFromResponse(responseBody, p2)
	if not (responseBody and responseBody.conversations) then
		return
	end

	for k, conversation in responseBody.conversations do
		local id = conversation.id

		if id and conversation.messages then
			ingestBatch(id, Cryo.List.filterMap(conversation.messages, function(p3)
				if p3 and p3.id then
					return (buildConversationMessageFromApi(p3, id))
				end

				return nil
			end), IngestOperation.Prepend)
		end
	end
end

local function handleGetUserConversationsSucceeded(p2, p3)
	ingestConversationsFromResponse(p2.responseBody, p3)
end

local function handleGetConversationDetailsSucceeded(p2, p3)
	ingestConversationsFromResponse(p2.responseBody, p3)
end

local function handleMultiGetConversationDetailsSucceeded(p2, p3)
	ingestConversationsFromResponse(p2.responseBody, p3)
end

local function handleRemovedConversation(p2, p3)
	local conversationId = p2.conversationId

	if conversationId then
		clearConversationStores(p3, conversationId)
	end
end

local function handleReloadedMessagesForConversations(p2, p3)
	local conversationIds = p2.conversationIds

	if conversationIds then
		for k, conversationId in conversationIds do
			clearConversationStores(p3, conversationId)
		end
	end
end

local v5 = {
	[receivedMessages.name] = handleReceivedMessages,
	[sendingMessage.name] = handleSendingMessage,
	[sentMessage.name] = handleSentMessage,
	[messageModerated.name] = handleMessageModerated,
	[messageFailedToSend.name] = handleMessageFailedToSend,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = handleGetOlderMessagesSucceeded,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = handleGetNewerMessagesSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = handleGetUserConversationsSucceeded,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = handleMultiGetConversationDetailsSucceeded,
	[RemovedConversation.name] = handleRemovedConversation,
	[ReloadedMessagesForConversations.name] = handleReloadedMessagesForConversations
}

local function SignalsMessageIngestionMiddleware(callback, p2)
	return function(p3)
		local v6 = callback(p3)

		if not FFlagAppChatSignalsMessageStore then
			return v6
		end

		local v7 = v5[p3.type]

		if v7 then
			local v8 = GetConversationMessageViewModelStore(false)
			v7(p3, {
				conversationMessageStore = v8.conversationMessageStore,
				conversationMessageListStore = v8.conversationMessageListStore,
				conversationMessageViewModelStore = v8
			})
		end

		return v6
	end
end

return SignalsMessageIngestionMiddleware
