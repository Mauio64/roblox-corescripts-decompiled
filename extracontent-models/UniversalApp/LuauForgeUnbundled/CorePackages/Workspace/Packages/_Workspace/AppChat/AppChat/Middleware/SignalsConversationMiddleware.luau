local Players = game:GetService("Players")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Conversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
local GetConversationListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationListStore")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationSearchDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationSearchDataHydration")
local searchIntroducedConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/searchIntroducedConversationIds")
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingFriends")
local NetworkingChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingChat")
local getPreciseUnixTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getPreciseUnixTimestamp")

local ChangedParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ChangedParticipants")
local ConversationModerationTypeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ConversationModerationTypeChanged")
local FriendConversationCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/FriendConversationCreated")
local FriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/FriendshipDestroyed")
local ReceivedChannelsMigrationConflict = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedChannelsMigrationConflict")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local ReceivedPageConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedPageConversations")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local RenamedGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RenamedGroupConversation")
local RequestPageConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RequestPageConversations")
local receivedMessages = Conversations.Actions.ReceivedMessages
local SetUserTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/SetUserTyping")

local FFlagAppChatConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationStore")
local FFlagAppChatConversationLoadRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationLoadRetry")
local FFlagAppChatAnyServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAnyServerSideConversationSearch")
local defineFastFlag = game:DefineFastFlag("AppChatBatchConversationPageUpsert", false)

local FFlagAppChatDerivedConversationLatestActivity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDerivedConversationLatestActivity")

local v5 = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

local function upsertConversationResponse(p2, p3)
	if p3 == nil or p3.status == "failed" then
		return
	end

	local v6 = ConversationChannels.fromChannelsApi(p3)

	if FFlagAppChatAnyServerSideConversationSearch then
		SignalsExperimental.batch(function()
			p2.upsertConversation(v6)
			searchIntroducedConversationIds.remove(v6.id)
		end)
	else
		p2.upsertConversation(v6)
	end
end

local function upsertConversationResponses(p2, responseBody)
	if responseBody == nil or responseBody.conversations == nil then
		return
	end

	if defineFastFlag then
		SignalsExperimental.batch(function()
			for k, conversation in responseBody.conversations do
				upsertConversationResponse(p2, conversation)
			end
		end)
		return
	end

	for k, conversation in responseBody.conversations do
		upsertConversationResponse(p2, conversation)
	end
end

local function updateConversation(p2, p3, p4)
	if p3 == nil then
		return
	end

	local conversation = p2.getConversation(p3, false)

	if conversation == nil then
		return
	end

	p2.upsertConversation(Cryo.Dictionary.join(conversation, p4), false)
end

local function getUnixTimestamp(value)
	if value == nil then
		return nil
	end

	if typeof(value) == "DateTime" then
		return value.UnixTimestamp
	end

	if type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	end

	return nil
end

local function getDateTimeFromIsoDate(value)
	if type(value) ~= "string" then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(value)
	end)

	if success then
		return result
	end

	return nil
end

local function getMessageSentTime(data)
	if data.sent == nil then
		local created_at = data.created_at or data.createdAt

		if type(created_at) ~= "string" then
			return nil
		end

		local success, result = pcall(function()
			return DateTime.fromIsoDate(created_at)
		end)

		if success then
			return result
		end

		return nil
	else
		if type(data.sent) ~= "string" then
			return data.sent
		end

		local sent = data.sent

		if type(sent) ~= "string" then
			return nil
		end

		local success, result = pcall(function()
			return DateTime.fromIsoDate(sent)
		end)

		if success then
			return result
		end

		return nil
	end
end

local function isMessagePreviewable(p2)
	if p2.isPreviewable ~= nil then
		return p2.isPreviewable
	end

	if p2.is_previewable == nil then
		return false
	end

	return p2.is_previewable
end

local function getNewestMessageUnixTime(p2)
	if p2 == nil then
		return 0
	end

	local v6 = GetConversationMessageViewModelStore(false)

	local v7 = v6.conversationMessageListStore.getOrderedIds(p2, false)[1]

	local result = v7 and v6.conversationMessageStore.getMessage(v7, false)

	if result then
		if result.sent == nil then
			local created_at = result.created_at or result.createdAt

			if type(created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			else
				result = nil
			end
		elseif type(result.sent) == "string" then
			local sent = result.sent

			if type(sent) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(sent)
				end)

				if not success then
					result = nil
				end
			else
				result = nil
			end
		else
			result = result.sent
		end
	end

	local unixTimestamp

	if result ~= nil then
		if typeof(result) == "DateTime" then
			unixTimestamp = result.UnixTimestamp
		elseif type(result) == "table" and result.GetUnixTimestamp ~= nil then
			unixTimestamp = result:GetUnixTimestamp()
		end
	end

	return unixTimestamp or 0
end

local function shouldMarkConversationUnreadFromMessages(conversation_id, messages): boolean
	if messages == nil then
		return false
	end

	local newestMessageUnixTime = getNewestMessageUnixTime(conversation_id)
	local userId = tostring(Players.LocalPlayer.UserId)

	for k, item in messages do
		local result

		if item.sent == nil then
			local created_at = item.created_at or item.createdAt

			if type(created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		elseif type(item.sent) == "string" then
			local sent = item.sent

			if type(sent) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(sent)
				end)

				if not success then
					result = nil
				end
			end
		else
			result = item.sent
		end

		local unixTimestamp

		if result ~= nil then
			if typeof(result) == "DateTime" then
				unixTimestamp = result.UnixTimestamp
			elseif type(result) == "table" and result.GetUnixTimestamp ~= nil then
				unixTimestamp = result:GetUnixTimestamp()
			end
		end

		local sender_user_id = item.sender_user_id or item.senderTargetId

		if
			unixTimestamp ~= nil
			and newestMessageUnixTime < unixTimestamp
			and sender_user_id ~= nil
			and tostring(sender_user_id) ~= userId
			and item.is_badgeable == true
		then
			return true
		end
	end

	return false
end

local function getPreviewMessageUnixTime(p2)
	if p2.previewMessageId == nil then
		return 0
	end

	local result = GetConversationMessageViewModelStore(false).conversationMessageStore.getMessage(p2.previewMessageId, false)

	if result then
		if result.sent == nil then
			local created_at = result.created_at or result.createdAt

			if type(created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			else
				result = nil
			end
		elseif type(result.sent) == "string" then
			local sent = result.sent

			if type(sent) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(sent)
				end)

				if not success then
					result = nil
				end
			else
				result = nil
			end
		else
			result = result.sent
		end
	end

	local unixTimestamp

	if result ~= nil then
		if typeof(result) == "DateTime" then
			unixTimestamp = result.UnixTimestamp
		elseif type(result) == "table" and result.GetUnixTimestamp ~= nil then
			unixTimestamp = result:GetUnixTimestamp()
		end
	end

	return unixTimestamp or 0
end

local function updateConversationLastUpdatedFromMessages(p2, p3, messages, p4)
	if p3 == nil or messages == nil then
		return
	end

	local conversation = p2.getConversation(p3, false)

	if conversation == nil then
		return
	end

	local v6 = nil
	local id = nil
	local v7

	if conversation.previewMessageId == nil then
		v7 = 0
	else
		local result = GetConversationMessageViewModelStore(false).conversationMessageStore.getMessage(
			conversation.previewMessageId,
			false
		)

		if result then
			if result.sent == nil then
				local created_at = result.created_at or result.createdAt

				if type(created_at) == "string" then
					local success
					success, result = pcall(function()
						return DateTime.fromIsoDate(created_at)
					end)

					if not success then
						result = nil
					end
				else
					result = nil
				end
			elseif type(result.sent) == "string" then
				local sent = result.sent

				if type(sent) == "string" then
					local success
					success, result = pcall(function()
						return DateTime.fromIsoDate(sent)
					end)

					if not success then
						result = nil
					end
				else
					result = nil
				end
			else
				result = result.sent
			end
		end

		local unixTimestamp

		if result ~= nil then
			if typeof(result) == "DateTime" then
				unixTimestamp = result.UnixTimestamp
			elseif type(result) == "table" and result.GetUnixTimestamp ~= nil then
				unixTimestamp = result:GetUnixTimestamp()
			end
		end

		v7 = unixTimestamp or 0
	end

	local lastUpdated = conversation.lastUpdated
	local unixTimestamp

	if lastUpdated ~= nil then
		if typeof(lastUpdated) == "DateTime" then
			unixTimestamp = lastUpdated.UnixTimestamp
		elseif type(lastUpdated) == "table" and lastUpdated.GetUnixTimestamp ~= nil then
			unixTimestamp = lastUpdated:GetUnixTimestamp()
		end
	end

	local v8 = unixTimestamp or 0

	for k, item in messages do
		if item == nil then
			continue
		end

		local v9

		if item.isPreviewable == nil then
			v9 = not (item.is_previewable == nil) and item.is_previewable
		else
			v9 = item.isPreviewable
		end

		if not v9 then
			continue
		end

		local result

		if item.sent == nil then
			local created_at = item.created_at or item.createdAt

			if type(created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		elseif type(item.sent) == "string" then
			local sent = item.sent

			if type(sent) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(sent)
				end)

				if not success then
					result = nil
				end
			end
		else
			result = item.sent
		end

		local unixTimestamp2

		if result ~= nil then
			if typeof(result) == "DateTime" then
				unixTimestamp2 = result.UnixTimestamp
			elseif type(result) == "table" and result.GetUnixTimestamp ~= nil then
				unixTimestamp2 = result:GetUnixTimestamp()
			end
		end

		if not (unixTimestamp2 ~= nil and v7 < unixTimestamp2) then
			continue
		end

		id = item.id
		v6 = result
		v7 = unixTimestamp2
	end

	if v6 == nil then
		if p4 then
			local v9 = { hasUnreadMessages = true }

			if p3 == nil then
				return
			end

			local conversation2 = p2.getConversation(p3, false)

			if conversation2 == nil then
				return
			end

			p2.upsertConversation(Cryo.Dictionary.join(conversation2, v9), false)
		end
	else
		local v9 = { previewMessageId = id }

		if v8 < v7 then
			v9.lastUpdated = v6

			if FFlagAppChatAnyServerSideConversationSearch then
				searchIntroducedConversationIds.remove(p3)
			end
		end

		if p4 then
			v9.hasUnreadMessages = true
		end

		if p3 == nil then
			return
		end

		local conversation2 = p2.getConversation(p3, false)

		if conversation2 == nil then
			return
		end

		p2.upsertConversation(Cryo.Dictionary.join(conversation2, v9), false)
	end
end

local function hasPreviewableMessageNewerThan(items, p2): boolean
	for k, item in items do
		if item == nil then
			continue
		end

		local v6

		if item.isPreviewable == nil then
			v6 = not (item.is_previewable == nil) and item.is_previewable
		else
			v6 = item.isPreviewable
		end

		if not v6 then
			continue
		end

		local result

		if item.sent == nil then
			local created_at = item.created_at or item.createdAt

			if type(created_at) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		elseif type(item.sent) == "string" then
			local sent = item.sent

			if type(sent) == "string" then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(sent)
				end)

				if not success then
					result = nil
				end
			end
		else
			result = item.sent
		end

		if p2 < (getPreciseUnixTimestamp(result) or 0) then
			return true
		end
	end

	return false
end

local function updateConversationFromMessages(p2, p3, messages, p4)
	if p3 == nil or messages == nil then
		return
	end

	local conversation = p2.getConversation(p3, false)

	if conversation == nil then
		return
	end

	local v6

	if
		FFlagAppChatAnyServerSideConversationSearch
		and searchIntroducedConversationIds.has(p3)
		and hasPreviewableMessageNewerThan(messages, getPreciseUnixTimestamp(conversation.lastUpdated) or 0)
	then
		searchIntroducedConversationIds.remove(p3)
		v6 = true
	else
		v6 = false
	end

	local v7 = {}

	if p4 then
		v7.hasUnreadMessages = true
	end

	if v6 or p4 then
		if p3 == nil then
			return
		end

		local conversation2 = p2.getConversation(p3, false)

		if conversation2 == nil then
			return
		end

		p2.upsertConversation(Cryo.Dictionary.join(conversation2, v7), false)
	end
end

local function handleCreateConversationSucceeded(p2, p3)
	local responseBody = p2.responseBody
	upsertConversationResponse(
		p3,
		responseBody and responseBody.conversations and responseBody.conversations[1]
	)

	if FFlagAppChatAnyServerSideConversationSearch then
		GetConversationSearchDataHydration(false).invalidate()
	end
end

local function handleDuplicateConversationSucceeded(p2, p3)
	local responseBody = p2.responseBody
	upsertConversationResponse(
		p3,
		responseBody and responseBody.conversations and responseBody.conversations[1]
	)

	if FFlagAppChatAnyServerSideConversationSearch then
		GetConversationSearchDataHydration(false).invalidate()
	end
end

local function isInitialConversationPage(p2): boolean
	local queryArgs = if p2 ~= nil then p2.queryArgs else nil

	if type(queryArgs) ~= "table" then
		return true
	end

	if queryArgs.pageNumber ~= nil then
		return queryArgs.pageNumber == 1
	end

	local cursor = queryArgs.cursor
	return cursor == nil or cursor == ""
end

local function applyConversationLoadSuccessStatus(p2, p3)
	if not FFlagAppChatConversationLoadRetry then
		return
	end

	p3.error = Cryo.None
	p3.isFetchingNextPage = false
	local queryArgs = if p2 ~= nil then p2.queryArgs else nil
	local v6

	if type(queryArgs) == "table" then
		if queryArgs.pageNumber == nil then
			local cursor = queryArgs.cursor
			v6 = cursor == nil or cursor == ""
		else
			v6 = queryArgs.pageNumber == 1
		end
	else
		v6 = true
	end

	if v6 then
		p3.hasFetchedInitialPage = true
	end
end

local function applyConversationLoadFailureStatus(p2, p3)
	if not FFlagAppChatConversationLoadRetry then
		return
	end

	p3.isFetchingNextPage = false
	local queryArgs = if p2 ~= nil then p2.queryArgs else nil
	local v6

	if type(queryArgs) == "table" then
		if queryArgs.pageNumber == nil then
			local cursor = queryArgs.cursor
			v6 = cursor == nil or cursor == ""
		else
			v6 = queryArgs.pageNumber == 1
		end
	else
		v6 = true
	end

	if v6 then
		p3.error = p2 == nil or p2.error == nil or p2.error
	end
end

local function handleGetUserConversationsSucceeded(p2, p3)
	upsertConversationResponses(p3, p2.responseBody)
	local next_cursor = p2.responseBody and p2.responseBody.next_cursor
	local v6 = { isFetchingConversations = false }

	if next_cursor == nil or next_cursor == "" then
		v6.oldestConversationIsFetched = true
	end

	if FFlagAppChatConversationLoadRetry then
		v6.error = Cryo.None
		v6.isFetchingNextPage = false
		local queryArgs = if p2 ~= nil then p2.queryArgs else nil
		local v7

		if type(queryArgs) == "table" then
			if queryArgs.pageNumber == nil then
				local cursor = queryArgs.cursor
				v7 = cursor == nil or cursor == ""
			else
				v7 = queryArgs.pageNumber == 1
			end
		else
			v7 = true
		end

		if v7 then
			v6.hasFetchedInitialPage = true
		end
	end

	p3.setListStatus(v6)
end

local function handleGetUserConversationsFailed(p2, p3)
	local v6 = { isFetchingConversations = false }

	if FFlagAppChatConversationLoadRetry then
		v6.isFetchingNextPage = false
		local queryArgs = if p2 ~= nil then p2.queryArgs else nil
		local v7

		if type(queryArgs) == "table" then
			if queryArgs.pageNumber == nil then
				local cursor = queryArgs.cursor
				v7 = cursor == nil or cursor == ""
			else
				v7 = queryArgs.pageNumber == 1
			end
		else
			v7 = true
		end

		if v7 then
			v6.error = p2 == nil or p2.error == nil or p2.error
		end
	end

	p3.setListStatus(v6)
end

local function handleGetConversationDetailsSucceeded(p2, p3)
	upsertConversationResponses(p3, p2.responseBody)
end

local function handleLegacyGetUserConversationsSucceeded(p2, p3)
	local responseBody = p2.responseBody

	if responseBody == nil then
		return
	end

	for i, v6 in ipairs(responseBody) do
		p3.upsertConversation(Conversation.fromWeb(v6))
	end

	local v6 = { isFetchingConversations = false }

	if FFlagAppChatConversationLoadRetry then
		v6.error = Cryo.None
		v6.isFetchingNextPage = false
		local queryArgs = if p2 ~= nil then p2.queryArgs else nil
		local v7

		if type(queryArgs) == "table" then
			if queryArgs.pageNumber == nil then
				local cursor = queryArgs.cursor
				v7 = cursor == nil or cursor == ""
			else
				v7 = queryArgs.pageNumber == 1
			end
		else
			v7 = true
		end

		if v7 then
			v6.hasFetchedInitialPage = true
		end
	end

	p3.setListStatus(v6)
	local pageSize = p2.queryArgs and p2.queryArgs.pageSize

	if pageSize ~= nil and #responseBody < pageSize then
		p3.setListStatus({ oldestConversationIsFetched = true })
	end
end

local function handleReceivedConversation(p2, p3)
	p3.upsertConversation(p2.conversation)
end

local function handleRemovedConversation(p2, p3)
	if p2.conversationId then
		p3.removeConversation(p2.conversationId)
	end
end

local function handleRenamedGroupConversation(data, p2)
	local conversationId = data.conversationId
	local v6 = {
		lastUpdated = data.lastUpdated,
		title = data.title,
		isDefaultTitle = data.isDefaultTitle
	}

	if conversationId == nil then
		return
	end

	local conversation = p2.getConversation(conversationId, false)

	if conversation == nil then
		return
	end

	p2.upsertConversation(Cryo.Dictionary.join(conversation, v6), false)
end

local function handleChangedParticipants(data, p2)
	local conversationId = data.conversationId
	local v6 = {
		participants = data.participants,
		lastUpdated = data.lastUpdated,
		title = data.title
	}

	if conversationId == nil then
		return
	end

	local conversation = p2.getConversation(conversationId, false)

	if conversation == nil then
		return
	end

	p2.upsertConversation(Cryo.Dictionary.join(conversation, v6), false)
end

local function handleMarkConversationSucceeded(p2, p3)
	local conversation_ids = p2.postBody and p2.postBody.conversation_ids

	if conversation_ids == nil then
		return
	end

	for k, conversation_id in conversation_ids do
		local v6 = { hasUnreadMessages = false }

		if conversation_id == nil then
			continue
		end

		local conversation = p3.getConversation(conversation_id, false)

		if conversation ~= nil then
			p3.upsertConversation(Cryo.Dictionary.join(conversation, v6), false)
		end
	end
end

local function handleSetUserTyping(data, p2)
	local v6 = data.conversationId and p2.getConversation(data.conversationId, false)

	if v6 == nil then
		return
	end

	local clone = table.clone(v6.usersTyping or {})
	clone[data.userId] = data.value
	p2.setUsersTyping(data.conversationId, clone)
end

local function handleConversationModerationTypeChanged(p2, p3)
	local conversationId = p2.conversationId
	local v6 = { moderationType = p2.moderationType }

	if conversationId == nil then
		return
	end

	local conversation = p3.getConversation(conversationId, false)

	if conversation == nil then
		return
	end

	p3.upsertConversation(Cryo.Dictionary.join(conversation, v6), false)
end

local function handleRecordModalSequenceResponseSucceeded(p2, p3)
	local postBody = p2.postBody

	if postBody == nil or postBody.action_type ~= Constants.ModalAction.Accept then
		return
	end

	local v6 = v5[postBody.modal_variant]

	if v6 == nil then
		return
	end

	local conversation_id = postBody.conversation_id
		or ConversationChannels.getFriendConversationId({ postBody.friend_id })
	local v7 = { [v6.field] = v6.value }

	if conversation_id == nil then
		return
	end

	local conversation = p3.getConversation(conversation_id, false)

	if conversation == nil then
		return
	end

	p3.upsertConversation(Cryo.Dictionary.join(conversation, v7), false)
end

local function handleFriendConversationCreated(p2, p3)
	if p2.oldFriendConversationId then
		p3.removeConversation(p2.oldFriendConversationId)
	end

	if FFlagAppChatAnyServerSideConversationSearch then
		GetConversationSearchDataHydration(false).invalidate()
	end
end

local function handleFriendshipDestroyed(p2, p3)
	local v6

	if p2.userId1 == "localUserId" then
		if p2.userId2 ~= "localUserId" then
			v6 = p2.userId2
		end
	else
		v6 = p2.userId1
	end

	if v6 == nil then
		return
	end

	p3.removeConversation(ConversationChannels.getFriendConversationId({ v6 }))
end

local function handleBlockUserByIdSucceeded(p2, p3)
	local users = p2.namedIds and p2.namedIds.users

	if users == nil then
		return
	end

	local v6 = tostring(users)

	for k, v7 in p3.getConversations(false) do
		local participants = v7.participants or {}

		if v7.type == ConversationChannels.Type.OneToOne and table.find(participants, v6) then
			p3.removeConversation(v7.id)
		end
	end

	p3.removeConversation(ConversationChannels.getFriendConversationId({ v6 }))
end

local function handleParticipantMetadataSucceeded(p2, p3)
	local responseBody = p2.responseBody

	if responseBody == nil or responseBody.conversation_participants_metadata == nil then
		return
	end

	for k, v6 in responseBody.conversation_participants_metadata do
		local v7 = {}

		for k2, v8 in v6.participants_metadata do
			v7[k2] = {
				isPending = v8.is_pending,
				isBlocked = v8.is_blocked,
				isInviter = v8.is_inviter,
				isInvited = v8.is_invited
			}
		end

		p3.setParticipantMetadata(k, v7)
	end
end

local function handleRequestPageConversations(p2, p3)
	p3.setListStatus({ isFetchingConversations = true })
end

local function handleReceivedPageConversations(p2, p3)
	p3.setListStatus({ isFetchingConversations = false })
end

local function handleReceivedMessages(data, p2)
	if FFlagAppChatDerivedConversationLatestActivity then
		updateConversationFromMessages(
			p2,
			data.conversationId,
			data.messages,
			data.shouldMarkConversationUnread
		)
	else
		updateConversationLastUpdatedFromMessages(
			p2,
			data.conversationId,
			data.messages,
			data.shouldMarkConversationUnread
		)
	end
end

local function handleGetNewerMessagesSucceeded(p2, p3)
	local conversation_id = p2.queryArgs and p2.queryArgs.conversation_id
	local responseBody = p2.responseBody
	local messages = responseBody and responseBody.messages

	if FFlagAppChatDerivedConversationLatestActivity then
		updateConversationFromMessages(
			p3,
			conversation_id,
			messages,
			shouldMarkConversationUnreadFromMessages(conversation_id, messages)
		)
	else
		updateConversationLastUpdatedFromMessages(
			p3,
			conversation_id,
			messages,
			shouldMarkConversationUnreadFromMessages(conversation_id, messages)
		)
	end
end

local function handleReceivedChannelsMigrationConflict(p2, p3)
	p3.clear()
	GetConversationListStore(false).setLatestMessagesFetching(false)
end

local v6 = {
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
	[NetworkingFriends.BlockUserById.Succeeded.name] = handleBlockUserByIdSucceeded,
	[ReceivedConversation.name] = handleReceivedConversation,
	[receivedMessages.name] = handleReceivedMessages,
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

local function SignalsConversationMiddleware(callback, p2)
	return function(p3)
		local v7 = callback(p3)

		if not FFlagAppChatConversationStore then
			return v7
		end

		local v8 = v6[p3.type]

		if v8 then
			v8(p3, GetConversationStore(false))
		end

		return v7
	end
end

return SignalsConversationMiddleware
