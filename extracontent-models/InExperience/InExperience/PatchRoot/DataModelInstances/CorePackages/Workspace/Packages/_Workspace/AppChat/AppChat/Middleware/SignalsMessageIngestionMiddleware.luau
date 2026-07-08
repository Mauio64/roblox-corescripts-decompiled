local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local SharedFlags = require(AppChatParent.SharedFlags)
local buildConversationMessageFromApi = require(AppChat.Stores.Ingestion.buildConversationMessageFromApi)
local ingestBatch = require(AppChat.Stores.Ingestion.ingestBatch)
local IngestOperation = require(AppChat.Stores.Ingestion.IngestOperation)
local Conversations = require(AppChat.Conversations)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local SendingMessage = Conversations.Actions.SendingMessage
local SentMessage = Conversations.Actions.SentMessage
local MessageModerated = Conversations.Actions.MessageModerated
local MessageFailedToSend = Conversations.Actions.MessageFailedToSend
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)

require(AppChat.MessageData.Types)

local Enums = require(AppChat.MessageData.Enums)
local MessageModel = require(AppChat.Models.MessageModel)
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)

local function determineStatus(b1: boolean?, b2: boolean?, b3: boolean?, s1: string?) -- line: 64
	-- upvalues: MessageStatus (copy), MessageVisibility (copy)
	if b1 then
		return MessageStatus.Pending
	end

	if b2 then
		return MessageStatus.Failed
	end

	if b3 then
		return MessageStatus.Moderated
	end

	if s1 == MessageVisibility.Hidden then
		return MessageStatus.Hidden
	end

	return MessageStatus.Default
end
local function extractLegacyTimestamp(p1) -- line: 83
	if p1 == nil or typeof(p1) ~= "table" then
		return nil
	end

	if p1.ToIsoDate then
		return p1:ToIsoDate()
	end

	local UnixTimestamp = nil

	if p1.GetUnixTimestamp then
		UnixTimestamp = p1:GetUnixTimestamp()
	elseif p1.UnixTimestamp then
		UnixTimestamp = p1.UnixTimestamp
	end

	if UnixTimestamp and UnixTimestamp > 0 then
		local ok, result = pcall(DateTime.fromUnixTimestamp, UnixTimestamp)

		if ok and result then
			return result:ToIsoDate()
		end
	end

	return nil
end
local function messagesFromWebResponse(s2: string, t1: {[any]: any}?) -- line: 105
	-- upvalues: MessageModel (copy)
	if t1 == nil then
		return {}
	end

	local id = nil
	local t2 = {}

	for i = #t1, 1, -1 do
		local v60 = t1[i]
		local v61 = MessageModel.fromWeb(v60, s2, id)

		if v61 ~= nil then
			v61.isPreviewable = v60.is_previewable
			v61.isBadgeable = v60.is_badgeable
			id = v61.id
			table.insert(t2, 1, v61)
		end
	end

	return t2
end
local function buildFromLegacy(p2, s3: string) -- line: 127
	-- upvalues: extractLegacyTimestamp (copy), MessageType (copy), GetFFlagEnableSocialCards (copy), MessageStatus (copy), MessageVisibility (copy)
	local t3 = nil

	if p2.repliesTo and p2.repliesTo.id then
		t3 = {
			id = p2.repliesTo.id,
			content = p2.repliesTo.content,
			sender_user_id = if not p2.repliesTo.senderTargetId then nil else tonumber(p2.repliesTo.senderTargetId),
			created_at = extractLegacyTimestamp(p2.repliesTo.sent),
			type = if p2.repliesTo.messageType ~= "System" then MessageType.User else MessageType.System
		}
	end

	local t4 = {
		id = p2.id or p2.messageId,
		type = if p2.messageType ~= "System" then MessageType.User else MessageType.System,
		content = p2.content,
		created_at = extractLegacyTimestamp(p2.sent),
		sender_user_id = if not p2.senderTargetId then nil else tonumber(p2.senderTargetId),
		moderation_type = p2.moderationType,
		visibility = p2.visibility,
		preview_content = p2.previewContent,
		content_to_display = p2.contentToDisplay or p2.content,
		replies_to = t3,
		cards = if not GetFFlagEnableSocialCards() then nil else p2.cards,
		filtered_for_receivers = p2.filteredForReceivers,
		conversationId = s3
	}
	local isSending = p2.isSending
	local failed = p2.failed
	local moderated = p2.moderated
	local visibility = p2.visibility

	t4.status = if not isSending then if not failed then if not moderated then if visibility ~= MessageVisibility.Hidden then MessageStatus.Default else MessageStatus.Hidden else MessageStatus.Moderated else MessageStatus.Failed else MessageStatus.Pending
	t4.stableKey = p2.stableKey or (p2.stable_key or (p2.id or p2.messageId))

	return t4
end
local function clearConversationStores(t5: {[any]: any}, s4: string) -- line: 159
	for _, v73 in (t5.conversationMessageListStore.getOrderedIds(s4)) do
		t5.conversationMessageStore.removeMessage(v73)
	end

	t5.conversationMessageViewModelStore.evictConversation(s4)
	t5.conversationMessageListStore.clearConversation(s4)
end
local function handleReceivedMessages(p3, _: {[any]: any}) -- line: 170
	-- upvalues: Cryo (copy), buildFromLegacy (copy), ingestBatch (copy), IngestOperation (copy)
	local conversationId = p3.conversationId
	local messages = p3.messages

	if messages and conversationId then
		local v78 = Cryo.List.filterMap(messages, function(p4) -- line: 174
			-- upvalues: buildFromLegacy (copy), conversationId (copy)
			if p4 and p4.id then
				return (buildFromLegacy(p4, conversationId))
			end

			return nil
		end)

		ingestBatch(conversationId, v78, IngestOperation.Prepend)
	end
end
local function handleSendingMessage(p5, _: {[any]: any}) -- line: 181
	-- upvalues: buildFromLegacy (copy), MessageStatus (copy), ingestBatch (copy), IngestOperation (copy)
	local conversationId = p5.conversationId
	local message = p5.message

	if message and (message.id and conversationId) then
		local v83 = buildFromLegacy(message, conversationId)

		v83.status = MessageStatus.Pending
		ingestBatch(conversationId, { v83 }, IngestOperation.Prepend)
	end
end
local function handleSentMessage(p6, t8: {[any]: any}) -- line: 191
	local conversationId = p6.conversationId
	local messageId = p6.messageId

	if conversationId and messageId then
		t8.conversationMessageListStore.removeMessage(conversationId, messageId)
		t8.conversationMessageStore.removeMessage(messageId)
	end
end
local function handleMessageModerated(p7, t9: {[any]: any}) -- line: 200
	-- upvalues: MessageStatus (copy)
	local messageId = p7.messageId

	if messageId then
		t9.conversationMessageStore.updateMessage(messageId, {
			status = MessageStatus.Moderated
		})
	end
end
local function handleMessageFailedToSend(p8, t10: {[any]: any}) -- line: 207
	-- upvalues: MessageStatus (copy)
	local messageId = p8.messageId

	if messageId then
		t10.conversationMessageStore.updateMessage(messageId, {
			status = MessageStatus.Failed
		})
	end
end
local function handleGetOlderMessagesSucceeded(p9, _: {[any]: any}) -- line: 214
	-- upvalues: Cryo (copy), buildConversationMessageFromApi (copy), ingestBatch (copy), IngestOperation (copy)
	local v96 = p9.queryArgs and p9.queryArgs.conversation_id
	local responseBody = p9.responseBody

	if v96 and (responseBody and responseBody.messages) then
		local v98 = Cryo.List.filterMap(responseBody.messages, function(p10) -- line: 218
			-- upvalues: buildConversationMessageFromApi (copy), v96 (copy)
			if p10 and p10.id then
				return (buildConversationMessageFromApi(p10, v96))
			end

			return nil
		end)
		local next_cursor = responseBody.next_cursor

		ingestBatch(v96, v98, IngestOperation.AppendAndAdvanceCursor, if next_cursor ~= "" then next_cursor else nil)
	end
end
local function handleGetNewerMessagesSucceeded(p11, _: {[any]: any}) -- line: 226
	-- upvalues: Cryo (copy), buildConversationMessageFromApi (copy), ingestBatch (copy), IngestOperation (copy)
	local v102 = p11.queryArgs and p11.queryArgs.conversation_id
	local responseBody = p11.responseBody

	if v102 and (responseBody and responseBody.messages) then
		local v104 = Cryo.List.filterMap(responseBody.messages, function(p12) -- line: 230
			-- upvalues: buildConversationMessageFromApi (copy), v102 (copy)
			if p12 and p12.id then
				return (buildConversationMessageFromApi(p12, v102))
			end

			return nil
		end)

		ingestBatch(v102, v104, IngestOperation.Prepend)
	end
end
local function handleGetLatestMessagesSucceeded(p13, _: {[any]: any}) -- line: 237
	-- upvalues: messagesFromWebResponse (copy), Cryo (copy), buildFromLegacy (copy), ingestBatch (copy), IngestOperation (copy)
	local responseBody = p13.responseBody

	if responseBody == nil then
		return
	end

	for _, v in ipairs(responseBody) do
		local str = tostring(v.conversationId)
		local v111 = messagesFromWebResponse(str, v.chatMessages)
		local v112 = Cryo.List.filterMap(v111, function(p14) -- line: 246
			-- upvalues: buildFromLegacy (copy), str (copy)
			if p14 and p14.id then
				return (buildFromLegacy(p14, str))
			end

			return nil
		end)

		ingestBatch(str, v112, IngestOperation.Prepend)
	end
end
local function ingestConversationsFromResponse(p15, _: {[any]: any}) -- line: 253
	-- upvalues: Cryo (copy), buildConversationMessageFromApi (copy), ingestBatch (copy), IngestOperation (copy)
	if not p15 or not p15.conversations then
		return
	end

	for _, v116 in p15.conversations do
		local id = v116.id

		if id and v116.messages then
			local v118 = Cryo.List.filterMap(v116.messages, function(p16) -- line: 260
				-- upvalues: buildConversationMessageFromApi (copy), id (copy)
				if p16 and p16.id then
					return (buildConversationMessageFromApi(p16, id))
				end

				return nil
			end)

			ingestBatch(id, v118, IngestOperation.Prepend)
		end
	end
end
local function handleGetUserConversationsSucceeded(p17, t15: {[any]: any}) -- line: 268
	-- upvalues: ingestConversationsFromResponse (copy)
	ingestConversationsFromResponse(p17.responseBody, t15)
end
local function handleGetConversationDetailsSucceeded(p18, t16: {[any]: any}) -- line: 272
	-- upvalues: ingestConversationsFromResponse (copy)
	ingestConversationsFromResponse(p18.responseBody, t16)
end
local function handleMultiGetConversationDetailsSucceeded(p19, t17: {[any]: any}) -- line: 276
	-- upvalues: ingestConversationsFromResponse (copy)
	ingestConversationsFromResponse(p19.responseBody, t17)
end
local function handleRemovedConversation(p20, t18: {[any]: any}) -- line: 280
	-- upvalues: clearConversationStores (copy)
	local conversationId = p20.conversationId

	if conversationId then
		clearConversationStores(t18, conversationId)
	end
end
local function handleReloadedMessagesForConversations(p21, t19: {[any]: any}) -- line: 287
	-- upvalues: clearConversationStores (copy)
	local conversationIds = p21.conversationIds

	if conversationIds then
		for _, v132 in conversationIds do
			clearConversationStores(t19, v132)
		end
	end
end

local t20 = {
	[ReceivedMessages.name] = handleReceivedMessages,
	[SendingMessage.name] = handleSendingMessage,
	[SentMessage.name] = handleSentMessage,
	[MessageModerated.name] = handleMessageModerated,
	[MessageFailedToSend.name] = handleMessageFailedToSend,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = handleGetOlderMessagesSucceeded,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = handleGetNewerMessagesSucceeded,
	[NetworkingChat.GetLatestMessages.Succeeded.name] = handleGetLatestMessagesSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = handleGetUserConversationsSucceeded,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = handleMultiGetConversationDetailsSucceeded,
	[RemovedConversation.name] = handleRemovedConversation,
	[ReloadedMessagesForConversations.name] = handleReloadedMessagesForConversations
}

local function SignalsMessageIngestionMiddleware(p22, _) -- line: 312
	-- upvalues: FFlagAppChatSignalsMessageStore (copy), t20 (copy), GetConversationMessageViewModelStore (copy)
	return function(p24) -- line: 313
		-- upvalues: p22 (copy), FFlagAppChatSignalsMessageStore (copy), t20 (copy), GetConversationMessageViewModelStore (copy)
		local v141 = p22(p24)

		if not FFlagAppChatSignalsMessageStore then
			return v141
		end

		local v142 = t20[p24.type]

		if v142 then
			local v143 = GetConversationMessageViewModelStore(false)

			v142(p24, {
				conversationMessageStore = v143.conversationMessageStore,
				conversationMessageListStore = v143.conversationMessageListStore,
				conversationMessageViewModelStore = v143
			})
		end

		return v141
	end
end

return SignalsMessageIngestionMiddleware
