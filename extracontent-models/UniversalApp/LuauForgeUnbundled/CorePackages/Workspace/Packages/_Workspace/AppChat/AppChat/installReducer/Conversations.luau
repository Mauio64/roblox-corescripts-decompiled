local Players = game:GetService("Players")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")

local Conversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations")

local ChangedParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ChangedParticipants")
local messageFailedToSend = Conversations.Actions.MessageFailedToSend
local messageModerated = Conversations.Actions.MessageModerated
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local receivedMessages = Conversations.Actions.ReceivedMessages
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local ReceivedChannelsMigrationConflict = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedChannelsMigrationConflict")
local RenamedGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RenamedGroupConversation")
local sendingMessage = Conversations.Actions.SendingMessage
local sentMessage = Conversations.Actions.SentMessage
local SetUserTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/SetUserTyping")
local FriendConversationCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/FriendConversationCreated")
local FriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/FriendshipDestroyed")
local ReloadedMessagesForConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReloadedMessagesForConversations")
local ConversationModerationTypeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ConversationModerationTypeChanged")

local NetworkingChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingChat")
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingFriends")

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Immutable
local orderedMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").OrderedMap
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local addConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/addConversation")

local getFFlagAppChatPCMFixBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").getFFlagAppChatPCMFixBlocking

local updateConversationReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/updateConversationReducer")
local getOneToOneConversationIdFromFriendId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getOneToOneConversationIdFromFriendId")

local getFFlagAppChatEnableManualTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableManualTranslation")
local fFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableU13ChatOptIn

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")

local v5 = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = fFlagAppChatEnableU13ChatOptIn and {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	} or nil
}

local function markConversationAndMessagesAsRead(p2, conversation_id)
	local v6 = p2[conversation_id]

	if not v6 then
		warn("Conversation " .. conversation_id .. " not found when marking conversation as read")
		return p2
	end

	assert(v6, "FFlagLuauTinyControlFlowAnalysis")

	local mapped = v6.messages:Map(function(p3)
		if p3.read then
			return p3
		end

		return immutable.Set(p3, "read", true)
	end)

	local v7 = immutable.Set(v6, "messages", mapped)
	local v8 = immutable.Set(v7, "hasUnreadMessages", false)

	return (immutable.Set(p2, v8.id, v8))
end

local function addMessagesToConversation(p2, p3, data)
	local v6 = p2[p3]

	if not v6 then
		return p2
	end

	local v7 = nil
	local v8 = v6.previewMessageId
	local v9 = 0

	if v8 and v6.messages then
		local v10 = v6.messages:Get(v8)

		if v10 then
			v9 = v10.sent:GetUnixTimestamp()
		end
	end

	for i = 1, #data.messages do
		local message = data.messages[i]
		local v10 = v6.messages:Get(message.id)

		if v10 then
			if v7 then
				v7.previousMessageId = v10.id
			end

			if message.previousMessageId == nil and v10.previousMessageId ~= nil then
				message.previousMessageId = v10.previousMessageId
			end

			message.read = message.read or v10.read
		elseif message.isPreviewable and v9 < message.sent:GetUnixTimestamp() then
			v8 = message.id
			v9 = message.sent:GetUnixTimestamp()
		end

		v7 = message
	end

	local joinDictionaries = immutable.JoinDictionaries(v6, { previewMessageId = v8 })

	local v10 = orderedMap.Insert(joinDictionaries.messages, unpack(data.messages))

	if data.exclusiveStartMessageId and #data.messages > 0 and v10:Get(data.exclusiveStartMessageId) then
		local message = data.messages[1]
		local v11 = v10:Get(data.exclusiveStartMessageId)
		v10 = v10:Insert((immutable.Set(v11, "previousMessageId", message.id)))
	end

	local v11 = v8 and v10 and v10:Get(v8)
	local v12 = joinDictionaries.lastUpdated

	if v11 then
		v12 = (v12 and v12:GetUnixTimestamp() or 0) < v11.sent:GetUnixTimestamp() and v11.sent
			or joinDictionaries.lastUpdated
	end

	local shouldMarkConversationUnread = data.shouldMarkConversationUnread
		or joinDictionaries.hasUnreadMessages
	local joinDictionaries2 = immutable.JoinDictionaries(joinDictionaries, {
		messages = v10,
		lastUpdated = v12,
		hasUnreadMessages = shouldMarkConversationUnread,
		nextCursor = data.nextCursor,
		previousCursor = data.previousCursor
	})

	local v13 = immutable.Set(joinDictionaries2, "usersTyping", {})
	return immutable.Set(p2, v13.id, v13)
end

local function updateMessageContentToDisplay(p2, conversation_id, message_id, content_to_display)
	local v6 = p2[conversation_id]

	local v7 = v6 and v6.messages:Get(message_id)

	if not v7 then
		return p2
	end

	local v8 = immutable.Set(v7, "contentToDisplay", content_to_display)
	local v9 = v6.messages:Insert(v8)
	local v10 = immutable.Set(v6, "messages", v9)
	return immutable.Set(p2, v10.id, v10)
end

local function messagesFromResponseOfChannelsApi(conversation_id, messages)
	if not messages then
		return {}
	end

	local id = nil
	local result = {}

	for i = #messages, 1, -1 do
		local item = messages[i]
		local v6 = MessageModel.fromChannelsApi(item, conversation_id, id)

		if not v6 then
			continue
		end

		table.insert(result, v6)
		id = v6.id
	end

	return result
end

local function getMessagesFromConversationResponse(p2)
	return p2.messages or {}
end

local function getShouldMarkConversationUnread(p2, list): boolean
	if not (p2 and p2.messages and list) then
		return false
	end

	local key = p2.messages.keys[#p2.messages.keys]
	local value = p2.messages.values[key]
	local unixTimestamp = value and value.sent and value.sent:GetUnixTimestamp() or 0

	for i = #list, 1, -1 do
		local item = list[i]

		if not item then
			continue
		end

		if item.sent:GetUnixTimestamp() <= unixTimestamp then
			return false
		end

		if item.senderTargetId ~= tostring(Players.LocalPlayer.UserId) and item.isBadgeable then
			return true
		end
	end

	return false
end

return Rodux.createReducer({}, {
	[ReceivedConversation.name] = function(p2, p3)
		return updateConversationReducer(p2, p3.conversation)
	end,
	[AppChatNetworking.rodux.CreateConversation.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if
			responseBody
			and responseBody.conversations
			and responseBody.conversations[1]
			and responseBody.conversations[1].status == "success"
		then
			p2 = updateConversationReducer(p2, (ConversationChannels.fromChannelsApi(responseBody.conversations[1])))
		end

		return p2
	end,
	[AppChatNetworking.rodux.DuplicateConversation.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if responseBody and responseBody.conversations and responseBody.conversations[1] then
			p2 = addConversation(p2, (ConversationChannels.fromChannelsApi(responseBody.conversations[1])))
		end

		return p2
	end,
	[receivedMessages.name] = function(p2, p3)
		return addMessagesToConversation(p2, p3.conversationId, p3)
	end,
	[sendingMessage.name] = function(p2, p3)
		local v7 = p2[p3.conversationId]

		if v7 then
			local v8 = orderedMap.Insert(v7.sendingMessages, p3.message)
			local v9 = immutable.Set(v7, "sendingMessages", v8)
			p2 = immutable.Set(p2, v9.id, v9)
		end

		return p2
	end,
	[sentMessage.name] = function(p2, p3)
		local v7 = p2[p3.conversationId]

		if v7 then
			local v8 = orderedMap.Delete(v7.sendingMessages, p3.messageId)
			local v9 = immutable.Set(v7, "sendingMessages", v8)
			p2 = immutable.Set(p2, v9.id, v9)
		end

		return p2
	end,
	[RenamedGroupConversation.name] = function(p2, data)
		local conversationId = data.conversationId

		local v7 = p2[conversationId]

		if v7 then
			local joinDictionaries = immutable.JoinDictionaries(v7, {
				lastUpdated = data.lastUpdated,
				title = data.title,
				isDefaultTitle = data.isDefaultTitle
			})

			p2 = immutable.Set(p2, conversationId, joinDictionaries)
		end

		return p2
	end,
	[ChangedParticipants.name] = function(p2, data)
		local conversationId = data.conversationId
		local participants = data.participants

		local v7 = p2[conversationId]

		if v7 then
			local joinDictionaries = immutable.JoinDictionaries(v7, {
				participants = participants,
				lastUpdated = data.lastUpdated,
				title = data.title
			})

			p2 = immutable.Set(p2, conversationId, joinDictionaries)
		end

		return p2
	end,
	[RemovedConversation.name] = function(p2, p3)
		local conversationId = p3.conversationId
		return immutable.Set(p2, conversationId, nil)
	end,
	[SetUserTyping.name] = function(p2, data)
		local v7 = p2[data.conversationId]

		if not v7 then
			return p2
		end

		local usersTyping = v7.usersTyping
		local v8 = immutable.Set(usersTyping, data.userId, data.value)
		local v9 = immutable.Set(v7, "usersTyping", v8)
		p2 = immutable.Set(p2, v9.id, v9)

		return p2
	end,
	[messageModerated.name] = function(p2, p3)
		local v7 = p2[p3.conversationId]

		if not v7 then
			return p2
		end

		local v8 = v7.sendingMessages:Get(p3.messageId)

		if not v8 then
			return p2
		end

		local v9 = immutable.Set(v8, "moderated", true)
		local v10 = v7.sendingMessages:Insert(v9)
		local v11 = immutable.Set(v7, "sendingMessages", v10)
		p2 = immutable.Set(p2, v11.id, v11)

		return p2
	end,
	[messageFailedToSend.name] = function(p2, p3)
		local v7 = p2[p3.conversationId]

		if not v7 then
			return p2
		end

		local v8 = v7.sendingMessages:Get(p3.messageId)

		if not v8 then
			return p2
		end

		local v9 = immutable.Set(v8, "failed", true)
		local v10 = v7.sendingMessages:Insert(v9)
		local v11 = immutable.Set(v7, "sendingMessages", v10)
		p2 = immutable.Set(p2, v11.id, v11)

		return p2
	end,
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		for i, v7 in ipairs(responseBody) do
			p2 = updateConversationReducer(p2, (Conversation.fromWeb(v7)))
		end

		return p2
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if not (responseBody and responseBody.conversations) then
			return p2
		end

		for k, conversation in responseBody.conversations do
			local v7 = ConversationChannels.fromChannelsApi(conversation)
			p2 = updateConversationReducer(p2, v7)
			local messages = conversation.messages or {}

			if not (messages and #messages > 0) then
				continue
			end

			local v8 = {
				messages = LuauPolyfill.Array.map(messages, function(p4)
					return MessageModel.fromChannelsApi(p4, v7.id)
				end)
			}

			p2 = addMessagesToConversation(p2, v7.id, v8)
		end

		return p2
	end,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = function(p2, p3)
		local conversation_id = p3.queryArgs.conversation_id
		local responseBody = p3.responseBody

		local v7 = p2[conversation_id]

		if not v7 then
			return p2
		end

		assert(v7, "FFlagLuauTinyControlFlowAnalysis")

		local v8 = v7.previousCursor or nil
		local nextCursor = v7.nextCursor or nil

		if not responseBody then
			return p2
		end

		local v9 = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)

		local next_cursor = if responseBody.next_cursor ~= "" then responseBody.next_cursor else nil

		if v8 == nil then
			v8 = if responseBody.previous_cursor ~= "" then responseBody.previous_cursor else nil
		end

		local v11 = addMessagesToConversation(p2, conversation_id, {
			messages = v9,
			nextCursor = next_cursor or nextCursor,
			previousCursor = v8
		})

		if next_cursor then
			return v11
		end

		local v12 = v11[conversation_id]

		if v12 then
			local v13 = immutable.Set(v12, "fetchedOldestMessage", true)
			v11 = immutable.Set(v11, v13.id, v13)
		end

		return v11
	end,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = function(p2, p3)
		local conversation_id = p3.queryArgs.conversation_id
		local responseBody = p3.responseBody

		local v7 = p2[conversation_id]

		if not v7 then
			return p2
		end

		assert(v7, "FFlagLuauTinyControlFlowAnalysis")

		local previousCursor = v7.previousCursor or nil
		local v8 = v7.nextCursor or nil

		if not responseBody then
			return p2
		end

		local v9 = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)

		if v8 == nil then
			v8 = if responseBody.next_cursor ~= "" then responseBody.next_cursor else nil
		end

		local v10 = if responseBody.previous_cursor ~= "" then responseBody.previous_cursor else nil

		return (addMessagesToConversation(p2, conversation_id, {
			messages = v9,
			nextCursor = v8,
			previousCursor = v10 or previousCursor,
			shouldMarkConversationUnread = getShouldMarkConversationUnread(v7, v9)
		}))
	end,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = function(p2, p3)
		local conversation = p3.responseBody.conversations[1]

		if not conversation then
			return p2
		end

		local v7 = ConversationChannels.fromChannelsApi(conversation)
		local v8 = updateConversationReducer(p2, v7)
		local messages = conversation.messages or {}

		if messages and #messages > 0 then
			local v9 = {
				messages = LuauPolyfill.Array.map(messages, function(p4)
					return MessageModel.fromChannelsApi(p4, v7.id)
				end)
			}

			v8 = addMessagesToConversation(v8, v7.id, v9)
		end

		return v8
	end,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if not (responseBody and responseBody.conversations) then
			return p2
		end

		for k, conversation in responseBody.conversations do
			local v7 = ConversationChannels.fromChannelsApi(conversation)
			p2 = updateConversationReducer(p2, v7)
			local messages = conversation.messages or {}

			if not (messages and #messages > 0) then
				continue
			end

			local v8 = {
				messages = LuauPolyfill.Array.map(messages, function(p4)
					return MessageModel.fromChannelsApi(p4, v7.id)
				end)
			}

			p2 = addMessagesToConversation(p2, v7.id, v8)
		end

		return p2
	end,
	[AppChatNetworking.rodux.MarkConversation.Succeeded.name] = function(p2, p3)
		return markConversationAndMessagesAsRead(p2, p3.postBody.conversation_ids[1])
	end,
	[AppChatNetworking.rodux.TranslateUserMessage.Succeeded.name] = getFFlagAppChatEnableManualTranslation() and function(p2, p3)
		local content_to_display = p3.responseBody.content_to_display

		if p3.postBody.conversation_id and p3.postBody.message_id then
			return updateMessageContentToDisplay(
				p2,
				p3.postBody.conversation_id,
				p3.postBody.message_id,
				content_to_display
			)
		end

		return p2
	end or nil,
	[ReceivedChannelsMigrationConflict.name] = function(p2, p3)
		return {}
	end,
	[FriendConversationCreated.name] = function(p2, p3)
		if p2[p3.oldFriendConversationId] then
			return immutable.Set(p2, p3.oldFriendConversationId, nil)
		end

		return p2
	end,
	[FriendshipDestroyed.name] = function(p2, p3)
		local v7

		if p3.userId1 == "localUserId" then
			if p3.userId2 ~= "localUserId" then
				v7 = p3.userId2
			end
		else
			v7 = p3.userId1
		end

		if not v7 then
			return p2
		end

		assert(v7, "FFlagLuauTinyControlFlowAnalysis")

		local friendConversationId = ConversationChannels.getFriendConversationId({ v7 })

		if p2[friendConversationId] then
			return immutable.Set(p2, friendConversationId, nil)
		end

		return p2
	end,
	[NetworkingFriends.BlockUserById.Succeeded.name] = getFFlagAppChatPCMFixBlocking() and function(p2, p3)
		local users = tostring(p3.namedIds.users)

		if not users then
			return p2
		end

		local v7 = getOneToOneConversationIdFromFriendId(p2, users)

		local v8 = if v7 and p2[v7] then immutable.Set(p2, v7, nil) else p2

		local friendConversationId = ConversationChannels.getFriendConversationId({ users })

		if friendConversationId and p2[friendConversationId] then
			v8 = immutable.Set(p2, friendConversationId, nil)
		end

		return v8
	end or nil,
	[ReloadedMessagesForConversations.name] = function(p2, p3)
		for k, conversationId in p3.conversationIds do
			local v7 = p2[conversationId]
			p2 = Cryo.Dictionary.join(p2, {
				[conversationId] = Cryo.Dictionary.join(v7, {
					messages = ConversationChannels.getEmptyMessages(),
					sendingMessages = ConversationChannels.getEmptySendingMessages(),
					previousCursor = Cryo.None,
					nextCursor = Cryo.None,
					fetchedOldestMessage = false
				})
			})
		end

		return p2
	end,
	[ConversationModerationTypeChanged.name] = function(p2, p3)
		local conversationId = p3.conversationId
		local moderationType = p3.moderationType
		local v7 = p2[conversationId]

		if not v7 then
			return p2
		end

		local v8 = immutable.Set(v7, "moderationType", moderationType)
		return immutable.Set(p2, conversationId, v8)
	end,
	[AppChatNetworking.rodux.RecordModalSequenceResponse.Succeeded.name] = function(p2, p3)
		local postBody = p3.postBody

		if postBody.action_type ~= Constants.ModalAction.Accept then
			return p2
		end

		local v7 = v5[postBody.modal_variant]

		if not v7 then
			return p2
		end

		local conversation_id = postBody.conversation_id
			or ConversationChannels.getFriendConversationId({ postBody.friend_id })

		local v8 = conversation_id and p2[conversation_id]

		if v8 then
			return immutable.Set(p2, conversation_id, immutable.Set(v8, v7.field, v7.value))
		end

		return p2
	end
})
