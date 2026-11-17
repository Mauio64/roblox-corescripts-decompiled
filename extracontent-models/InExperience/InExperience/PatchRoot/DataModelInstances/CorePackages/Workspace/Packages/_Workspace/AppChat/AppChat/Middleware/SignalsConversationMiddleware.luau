local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local SignalsExperimental = require(parent.SignalsExperimental)

local Constants = require(AppChat.Constants)
local Conversations = require(AppChat.Conversations)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Conversation = require(AppChat.Models.Conversation)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local GetConversationListStore = require(AppChat.Stores.GetConversationListStore)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationSearchDataHydration = require(AppChat.Stores.GetConversationSearchDataHydration)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)
local NetworkingBlocking = require(AppChat.Http.NetworkingBlocking)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local getMessageSentUnixSeconds = require(AppChat.Utils.getMessageSentUnixSeconds)
local getUnixTimestampMillis = require(AppChat.Utils.getUnixTimestampMillis)
local getUnixTimestampSeconds = require(AppChat.Utils.getUnixTimestampSeconds)
require(AppChat.AppChatData.Types)
local findNewestPreviewableMessage = require(AppChat.AppChatData.Conversations.findNewestPreviewableMessage)
local hasPreviewableMessageNewerThan = require(AppChat.AppChatData.Conversations.hasPreviewableMessageNewerThan)
local shouldMarkUnread = require(AppChat.AppChatData.Unread.shouldMarkUnread)

local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local FriendshipDestroyed = require(AppChat.Actions.FriendshipDestroyed)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local ReceivedPageConversations = require(AppChat.Conversations.Actions.ReceivedPageConversations)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
local RequestPageConversations = require(AppChat.Conversations.Actions.RequestPageConversations)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local SetUserTyping = require(AppChat.Conversations.Actions.SetUserTyping)

local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local FFlagAppChatConversationLoadRetry = require(AppChat.Flags.FFlagAppChatConversationLoadRetry)
local FFlagAppChatAnyServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatAnyServerSideConversationSearch)
local defineFastFlag = game:DefineFastFlag("AppChatBatchConversationPageUpsert", false)

local FFlagAppChatDerivedConversationLatestActivity = require(AppChat.Flags.FFlagAppChatDerivedConversationLatestActivity)

local v = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

local function upsertConversationResponse(p, p2)
	if p2 == nil or p2.status == "failed" then
		return
	end

	local v2 = ConversationChannels.fromChannelsApi(p2)

	if FFlagAppChatAnyServerSideConversationSearch then
		SignalsExperimental.batch(function()
			p.upsertConversation(v2)
			searchIntroducedConversationIds.remove(v2.id)
		end)
	else
		p.upsertConversation(v2)
	end
end

local function upsertConversationResponses(p, responseBody)
	if responseBody == nil or responseBody.conversations == nil then
		return
	end

	if defineFastFlag then
		SignalsExperimental.batch(function()
			for _, conversation in responseBody.conversations do
				upsertConversationResponse(p, conversation)
			end
		end)
		return
	end

	for _, conversation in responseBody.conversations do
		upsertConversationResponse(p, conversation)
	end
end

local function updateConversation(p, p2: string?, p3) -- 8 equivalent calls inferred from this helper
	if p2 == nil then
		return
	end

	local conversation = p.getConversation(p2, false)

	if conversation == nil then
		return
	end

	p.upsertConversation(Cryo.Dictionary.join(conversation, p3), false)
end

local function getNewestMessageUnixSeconds(p: string?)
	if p == nil then
		return 0
	end

	local conversationMessageViewModelStore = GetConversationMessageViewModelStore(false)

	local v2 = conversationMessageViewModelStore.conversationMessageListStore.getOrderedIds(p, false)[1]

	local v3 = v2 and conversationMessageViewModelStore.conversationMessageStore.getMessage(v2, false)
	return v3 and getMessageSentUnixSeconds(v3) or 0
end

local function shouldMarkConversationUnreadFromMessages(conversation_id: string?, messages)
	if messages == nil then
		return false
	end

	return shouldMarkUnread(
		messages,
		getNewestMessageUnixSeconds(conversation_id),
		(tostring(Players.LocalPlayer.UserId))
	)
end

local function getPreviewMessageUnixSeconds(conversation) -- 1 equivalent call inferred from this helper
	if conversation.previewMessageId == nil then
		return 0
	end

	local message = GetConversationMessageViewModelStore(false).conversationMessageStore.getMessage(
		conversation.previewMessageId,
		false
	)
	return message and getMessageSentUnixSeconds(message) or 0
end

local function updateConversationLastUpdatedFromMessages(p, p2: string?, messages, flag: boolean?)
	if p2 == nil or messages == nil then
		return
	end

	local conversation = p.getConversation(p2, false)

	if conversation == nil then
		return
	end

	local newestPreviewableMessage = findNewestPreviewableMessage(messages, getPreviewMessageUnixSeconds(conversation)) -- inferred equivalent call
	local v2 = getUnixTimestampSeconds(conversation.lastUpdated) or 0

	if newestPreviewableMessage == nil then
		if flag then
			updateConversation(p, p2, { hasUnreadMessages = true }) -- inferred equivalent call
		end
	else
		local v3 = { previewMessageId = newestPreviewableMessage.messageId }

		if v2 < newestPreviewableMessage.sentUnixSeconds then
			v3.lastUpdated = newestPreviewableMessage.sentDateTime

			if FFlagAppChatAnyServerSideConversationSearch then
				searchIntroducedConversationIds.remove(p2)
			end
		end

		if flag then
			v3.hasUnreadMessages = true
		end

		updateConversation(p, p2, v3) -- inferred equivalent call
	end
end

local function updateConversationFromMessages(p, p2: string?, messages, flag: boolean?)
	if p2 == nil or messages == nil then
		return
	end

	local conversation = p.getConversation(p2, false)

	if conversation == nil then
		return
	end

	local v2

	if
		FFlagAppChatAnyServerSideConversationSearch
		and searchIntroducedConversationIds.has(p2)
		and hasPreviewableMessageNewerThan(messages, getUnixTimestampMillis(conversation.lastUpdated) or 0)
	then
		searchIntroducedConversationIds.remove(p2)
		v2 = true
	else
		v2 = false
	end

	local v3 = {}

	if flag then
		v3.hasUnreadMessages = true
	end

	if v2 or flag then
		updateConversation(p, p2, v3) -- inferred equivalent call
	end
end

local function handleCreateConversationSucceeded(p, p2) -- 1 equivalent call inferred from this helper
	local responseBody = p.responseBody
	upsertConversationResponse(p2, responseBody and responseBody.conversations and responseBody.conversations[1])

	if FFlagAppChatAnyServerSideConversationSearch then
		GetConversationSearchDataHydration(false).invalidate()
	end
end

local function handleDuplicateConversationSucceeded(p, p2)
	handleCreateConversationSucceeded(p, p2) -- inferred equivalent call
end

local function isInitialConversationPage(p): boolean -- 2 equivalent calls inferred from this helper
	local queryArgs

	if p ~= nil then
		queryArgs = p.queryArgs
	end

	if type(queryArgs) ~= "table" then
		return true
	end

	if queryArgs.pageNumber ~= nil then
		return queryArgs.pageNumber == 1
	end

	local cursor = queryArgs.cursor
	return cursor == nil or cursor == ""
end

local function applyConversationLoadSuccessStatus(p, p2) -- 2 equivalent calls inferred from this helper
	if not FFlagAppChatConversationLoadRetry then
		return
	end

	p2.error = Cryo.None
	p2.isFetchingNextPage = false

	if isInitialConversationPage(p) then -- inferred equivalent call
		p2.hasFetchedInitialPage = true
	end
end

local function applyConversationLoadFailureStatus(p, p2) -- 1 equivalent call inferred from this helper
	if not FFlagAppChatConversationLoadRetry then
		return
	end

	p2.isFetchingNextPage = false

	if isInitialConversationPage(p) then -- inferred equivalent call
		p2.error = p == nil or p.error == nil or p.error
	end
end

local function handleGetUserConversationsSucceeded(p, p2)
	upsertConversationResponses(p2, p.responseBody)
	local next_cursor = p.responseBody and p.responseBody.next_cursor
	local v2 = { isFetchingConversations = false }

	if next_cursor == nil or next_cursor == "" then
		v2.oldestConversationIsFetched = true
	end

	applyConversationLoadSuccessStatus(p, v2) -- inferred equivalent call
	p2.setListStatus(v2)
end

local function handleGetUserConversationsFailed(p, p2)
	local v2 = { isFetchingConversations = false }
	applyConversationLoadFailureStatus(p, v2) -- inferred equivalent call
	p2.setListStatus(v2)
end

local function handleGetConversationDetailsSucceeded(p, p2)
	upsertConversationResponses(p2, p.responseBody)
end

local function handleLegacyGetUserConversationsSucceeded(p, p2)
	local responseBody = p.responseBody

	if responseBody == nil then
		return
	end

	for _, v2 in ipairs(responseBody) do
		p2.upsertConversation(Conversation.fromWeb(v2))
	end

	local v2 = { isFetchingConversations = false }
	applyConversationLoadSuccessStatus(p, v2) -- inferred equivalent call
	p2.setListStatus(v2)
	local pageSize = p.queryArgs and p.queryArgs.pageSize

	if pageSize ~= nil and #responseBody < pageSize then
		p2.setListStatus({ oldestConversationIsFetched = true })
	end
end

local function handleReceivedConversation(p, p2)
	p2.upsertConversation(p.conversation)
end

local function handleRemovedConversation(p, p2)
	if p.conversationId then
		p2.removeConversation(p.conversationId)
	end
end

local function handleRenamedGroupConversation(data, p)
	updateConversation(p, data.conversationId, { -- inferred equivalent call
		lastUpdated = data.lastUpdated,
		title = data.title,
		isDefaultTitle = data.isDefaultTitle
	})
end

local function handleChangedParticipants(data, p)
	updateConversation(p, data.conversationId, { -- inferred equivalent call
		participants = data.participants,
		lastUpdated = data.lastUpdated,
		title = data.title
	})
end

local function handleMarkConversationSucceeded(p, p2)
	local conversation_ids = p.postBody and p.postBody.conversation_ids

	if conversation_ids == nil then
		return
	end

	for _, conversation_id in conversation_ids do
		updateConversation(p2, conversation_id, { hasUnreadMessages = false }) -- inferred equivalent call
	end
end

local function handleSetUserTyping(data, p)
	local v2 = data.conversationId and p.getConversation(data.conversationId, false)

	if v2 == nil then
		return
	end

	local clone = table.clone(v2.usersTyping or {})
	clone[data.userId] = data.value
	p.setUsersTyping(data.conversationId, clone)
end

local function handleConversationModerationTypeChanged(p, p2)
	updateConversation(p2, p.conversationId, { moderationType = p.moderationType }) -- inferred equivalent call
end

local function handleRecordModalSequenceResponseSucceeded(p, p2)
	local postBody = p.postBody

	if postBody == nil or postBody.action_type ~= Constants.ModalAction.Accept then
		return
	end

	local v2 = v[postBody.modal_variant]

	if v2 == nil then
		return
	end

	local conversation_id = postBody.conversation_id
		or ConversationChannels.getFriendConversationId({ postBody.friend_id })
	updateConversation(p2, conversation_id, { [v2.field] = v2.value }) -- inferred equivalent call
end

local function handleFriendConversationCreated(p, p2)
	if p.oldFriendConversationId then
		p2.removeConversation(p.oldFriendConversationId)
	end

	if FFlagAppChatAnyServerSideConversationSearch then
		GetConversationSearchDataHydration(false).invalidate()
	end
end

local function handleFriendshipDestroyed(p, p2)
	local v2

	if p.userId1 == "localUserId" then
		if p.userId2 ~= "localUserId" then
			v2 = p.userId2
		end
	else
		v2 = p.userId1
	end

	if v2 == nil then
		return
	end

	p2.removeConversation(ConversationChannels.getFriendConversationId({ v2 }))
end

local function handleBlockUserByIdSucceeded(p, p2)
	local users = p.namedIds and p.namedIds.users

	if users == nil then
		return
	end

	local v2 = tostring(users)

	for _, v3 in p2.getConversations(false) do
		local participants = v3.participants or {}

		if v3.type == ConversationChannels.Type.OneToOne and table.find(participants, v2) then
			p2.removeConversation(v3.id)
		end
	end

	p2.removeConversation(ConversationChannels.getFriendConversationId({ v2 }))
end

local function handleParticipantMetadataSucceeded(p, p2)
	local responseBody = p.responseBody

	if responseBody == nil or responseBody.conversation_participants_metadata == nil then
		return
	end

	for k, v2 in responseBody.conversation_participants_metadata do
		local v3 = {}

		for k2, v4 in v2.participants_metadata do
			v3[k2] = {
				isPending = v4.is_pending,
				isBlocked = v4.is_blocked,
				isInviter = v4.is_inviter,
				isInvited = v4.is_invited
			}
		end

		p2.setParticipantMetadata(k, v3)
	end
end

local function handleRequestPageConversations(_, p)
	p.setListStatus({ isFetchingConversations = true })
end

local function handleReceivedPageConversations(_, p)
	p.setListStatus({ isFetchingConversations = false })
end

local function handleReceivedMessages(data, p)
	if FFlagAppChatDerivedConversationLatestActivity then
		updateConversationFromMessages(p, data.conversationId, data.messages, data.shouldMarkConversationUnread)
	else
		updateConversationLastUpdatedFromMessages(
			p,
			data.conversationId,
			data.messages,
			data.shouldMarkConversationUnread
		)
	end
end

local function handleGetNewerMessagesSucceeded(p, p2)
	local conversation_id = p.queryArgs and p.queryArgs.conversation_id
	local responseBody = p.responseBody
	local messages = responseBody and responseBody.messages

	if FFlagAppChatDerivedConversationLatestActivity then
		updateConversationFromMessages(
			p2,
			conversation_id,
			messages,
			shouldMarkConversationUnreadFromMessages(conversation_id, messages)
		)
	else
		updateConversationLastUpdatedFromMessages(
			p2,
			conversation_id,
			messages,
			shouldMarkConversationUnreadFromMessages(conversation_id, messages)
		)
	end
end

local function handleReceivedChannelsMigrationConflict(_, p)
	p.clear()
	GetConversationListStore(false).setLatestMessagesFetching(false)
end

local v2 = {
	[AppChatNetworking.rodux.CreateConversation.Succeeded.name] = handleCreateConversationSucceeded,
	[AppChatNetworking.rodux.DuplicateConversation.Succeeded.name] = handleDuplicateConversationSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = handleGetUserConversationsSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Failed.name] = handleGetUserConversationsFailed,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MarkConversation.Succeeded.name] = handleMarkConversationSucceeded,
	[AppChatNetworking.rodux.GetConversationsParticipantsMetadata.Succeeded.name] = handleParticipantMetadataSucceeded,
	[AppChatNetworking.rodux.RecordModalSequenceResponse.Succeeded.name] = handleRecordModalSequenceResponseSucceeded,
	[NetworkingChat.GetUserConversations.Succeeded.name] = handleLegacyGetUserConversationsSucceeded,
	[NetworkingChat.GetUserConversations.Failed.name] = handleGetUserConversationsFailed,
	[NetworkingBlocking.BlockUserById.Succeeded.name] = handleBlockUserByIdSucceeded,
	[ReceivedConversation.name] = handleReceivedConversation,
	[ReceivedMessages.name] = handleReceivedMessages,
	[RemovedConversation.name] = handleRemovedConversation,
	[RenamedGroupConversation.name] = handleRenamedGroupConversation,
	[ChangedParticipants.name] = handleChangedParticipants,
	[SetUserTyping.name] = handleSetUserTyping,
	[ConversationModerationTypeChanged.name] = handleConversationModerationTypeChanged,
	[FriendConversationCreated.name] = handleFriendConversationCreated,
	[FriendshipDestroyed.name] = handleFriendshipDestroyed,
	[RequestPageConversations.name] = handleRequestPageConversations,
	[ReceivedPageConversations.name] = handleReceivedPageConversations,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = handleGetNewerMessagesSucceeded,
	[ReceivedChannelsMigrationConflict.name] = handleReceivedChannelsMigrationConflict
}

local function SignalsConversationMiddleware(callback, _)
	return function(p)
		local v3 = callback(p)

		if not FFlagAppChatConversationStore then
			return v3
		end

		local v4 = v2[p.type]

		if v4 then
			v4(p, GetConversationStore(false))
		end

		return v3
	end
end

return SignalsConversationMiddleware
