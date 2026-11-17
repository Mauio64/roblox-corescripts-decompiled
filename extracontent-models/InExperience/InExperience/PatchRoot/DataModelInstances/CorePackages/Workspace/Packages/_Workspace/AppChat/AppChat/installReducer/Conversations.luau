local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local Rodux = require(parent.Rodux)
local LuauPolyfill = require(parent.LuauPolyfill)

local Conversations = require(AppChat.Conversations)

local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local MessageFailedToSend = Conversations.Actions.MessageFailedToSend
local MessageModerated = Conversations.Actions.MessageModerated
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
local SendingMessage = Conversations.Actions.SendingMessage
local SentMessage = Conversations.Actions.SentMessage
local SetUserTyping = require(AppChat.Conversations.Actions.SetUserTyping)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local FriendshipDestroyed = require(AppChat.Actions.FriendshipDestroyed)
local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)

local NetworkingChat = require(AppChat.Http.NetworkingChat)
local NetworkingBlocking = require(AppChat.Http.NetworkingBlocking)

local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local AppCommonLib2 = require(parent.AppCommonLib)
local OrderedMap = AppCommonLib2.OrderedMap
local MessageModel = require(AppChat.Models.MessageModel)
local Cryo = require(parent.Cryo)

local addConversation = require(AppChat.Utils.addConversation)

local SharedFlags = require(parent.SharedFlags)
local getFFlagAppChatPCMFixBlocking = SharedFlags.getFFlagAppChatPCMFixBlocking

local updateConversationReducer = require(script.Parent.updateConversationReducer)
local getOneToOneConversationIdFromFriendId = require(AppChat.Utils.getOneToOneConversationIdFromFriendId)

local getFFlagAppChatEnableManualTranslation = require(AppChat.Flags.getFFlagAppChatEnableManualTranslation)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatEnableU13ChatOptIn = SharedFlags2.FFlagAppChatEnableU13ChatOptIn

local Constants = require(AppChat.Constants)

local v = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = FFlagAppChatEnableU13ChatOptIn and {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	} or nil
}

local function markConversationAndMessagesAsRead(p, conversation_id: string)
	local v2 = p[conversation_id]

	if not v2 then
		warn("Conversation " .. conversation_id .. " not found when marking conversation as read")
		return p
	end

	assert(v2, "FFlagLuauTinyControlFlowAnalysis")

	local mapped = v2.messages:Map(function(p2)
		if p2.read then
			return p2
		end

		return Immutable.Set(p2, "read", true)
	end)

	local v3 = Immutable.Set(v2, "messages", mapped)
	local v4 = Immutable.Set(v3, "hasUnreadMessages", false)

	return (Immutable.Set(p, v4.id, v4))
end

local function addMessagesToConversation(p, p2: string, data)
	local v2 = p[p2]

	if not v2 then
		return p
	end

	local v3 = nil
	local previewMessageId = v2.previewMessageId
	local v4 = 0

	if previewMessageId and v2.messages then
		local v5 = v2.messages:Get(previewMessageId)

		if v5 then
			v4 = v5.sent:GetUnixTimestamp()
		end
	end

	for i = 1, #data.messages do
		local message = data.messages[i]
		local v5 = v2.messages:Get(message.id)

		if v5 then
			if v3 then
				v3.previousMessageId = v5.id
			end

			if message.previousMessageId == nil and v5.previousMessageId ~= nil then
				message.previousMessageId = v5.previousMessageId
			end

			message.read = message.read or v5.read
		elseif message.isPreviewable and v4 < message.sent:GetUnixTimestamp() then
			previewMessageId = message.id
			v4 = message.sent:GetUnixTimestamp()
		end

		v3 = message
	end

	local joinDictionaries = Immutable.JoinDictionaries(v2, { previewMessageId = previewMessageId })

	local messages = OrderedMap.Insert(joinDictionaries.messages, unpack(data.messages))

	if data.exclusiveStartMessageId and #data.messages > 0 and messages:Get(data.exclusiveStartMessageId) then
		local message = data.messages[1]
		local v5 = messages:Get(data.exclusiveStartMessageId)
		messages = messages:Insert((Immutable.Set(v5, "previousMessageId", message.id)))
	end

	local v5 = previewMessageId and messages and messages:Get(previewMessageId)
	local lastUpdated = joinDictionaries.lastUpdated

	if v5 then
		lastUpdated = (lastUpdated and lastUpdated:GetUnixTimestamp() or 0) < v5.sent:GetUnixTimestamp() and v5.sent
			or joinDictionaries.lastUpdated
	end

	local shouldMarkConversationUnread = data.shouldMarkConversationUnread or joinDictionaries.hasUnreadMessages
	local joinDictionaries2 = Immutable.JoinDictionaries(joinDictionaries, {
		messages = messages,
		lastUpdated = lastUpdated,
		hasUnreadMessages = shouldMarkConversationUnread,
		nextCursor = data.nextCursor,
		previousCursor = data.previousCursor
	})

	local v6 = Immutable.Set(joinDictionaries2, "usersTyping", {})
	return Immutable.Set(p, v6.id, v6)
end

local function updateMessageContentToDisplay(p, conversation_id: string, message_id: string, content_to_display: string)
	local v2 = p[conversation_id]

	local v3 = v2 and v2.messages:Get(message_id)

	if not v3 then
		return p
	end

	local v4 = Immutable.Set(v3, "contentToDisplay", content_to_display)
	local v5 = v2.messages:Insert(v4)
	local v6 = Immutable.Set(v2, "messages", v5)
	return Immutable.Set(p, v6.id, v6)
end

local function messagesFromResponseOfChannelsApi(conversation_id: string, messages)
	if not messages then
		return {}
	end

	local id = nil
	local result = {}

	for i = #messages, 1, -1 do
		local item = messages[i]
		local v2 = MessageModel.fromChannelsApi(item, conversation_id, id)

		if not v2 then
			continue
		end

		table.insert(result, v2)
		id = v2.id
	end

	return result
end

local function getMessagesFromConversationResponse(conversation) -- 3 equivalent calls inferred from this helper
	return conversation.messages or {}
end

local function getShouldMarkConversationUnread(p, list): boolean
	if not (p and p.messages and list) then
		return false
	end

	local key = p.messages.keys[#p.messages.keys]
	local value = p.messages.values[key]
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
	[ReceivedConversation.name] = function(p, p2)
		return updateConversationReducer(p, p2.conversation)
	end,
	[AppChatNetworking.rodux.CreateConversation.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if
			responseBody
			and responseBody.conversations
			and responseBody.conversations[1]
			and responseBody.conversations[1].status == "success"
		then
			p = updateConversationReducer(p, (ConversationChannels.fromChannelsApi(responseBody.conversations[1])))
		end

		return p
	end,
	[AppChatNetworking.rodux.DuplicateConversation.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if responseBody and responseBody.conversations and responseBody.conversations[1] then
			p = addConversation(p, (ConversationChannels.fromChannelsApi(responseBody.conversations[1])))
		end

		return p
	end,
	[ReceivedMessages.name] = function(p, p2)
		return addMessagesToConversation(p, p2.conversationId, p2)
	end,
	[SendingMessage.name] = function(p, p2)
		local v2 = p[p2.conversationId]

		if v2 then
			local v3 = OrderedMap.Insert(v2.sendingMessages, p2.message)
			local v4 = Immutable.Set(v2, "sendingMessages", v3)
			p = Immutable.Set(p, v4.id, v4)
		end

		return p
	end,
	[SentMessage.name] = function(p, p2)
		local v2 = p[p2.conversationId]

		if v2 then
			local v3 = OrderedMap.Delete(v2.sendingMessages, p2.messageId)
			local v4 = Immutable.Set(v2, "sendingMessages", v3)
			p = Immutable.Set(p, v4.id, v4)
		end

		return p
	end,
	[RenamedGroupConversation.name] = function(p, data)
		local conversationId = data.conversationId

		local v2 = p[conversationId]

		if v2 then
			local joinDictionaries = Immutable.JoinDictionaries(v2, {
				lastUpdated = data.lastUpdated,
				title = data.title,
				isDefaultTitle = data.isDefaultTitle
			})

			p = Immutable.Set(p, conversationId, joinDictionaries)
		end

		return p
	end,
	[ChangedParticipants.name] = function(p, data)
		local conversationId = data.conversationId
		local participants = data.participants

		local v2 = p[conversationId]

		if v2 then
			local joinDictionaries = Immutable.JoinDictionaries(v2, {
				participants = participants,
				lastUpdated = data.lastUpdated,
				title = data.title
			})

			p = Immutable.Set(p, conversationId, joinDictionaries)
		end

		return p
	end,
	[RemovedConversation.name] = function(p, p2)
		local conversationId = p2.conversationId
		return Immutable.Set(p, conversationId, nil)
	end,
	[SetUserTyping.name] = function(p, data)
		local v2 = p[data.conversationId]

		if not v2 then
			return p
		end

		local usersTyping = v2.usersTyping
		local v3 = Immutable.Set(usersTyping, data.userId, data.value)
		local v4 = Immutable.Set(v2, "usersTyping", v3)
		p = Immutable.Set(p, v4.id, v4)

		return p
	end,
	[MessageModerated.name] = function(p, p2)
		local v2 = p[p2.conversationId]

		if not v2 then
			return p
		end

		local v3 = v2.sendingMessages:Get(p2.messageId)

		if not v3 then
			return p
		end

		local v4 = Immutable.Set(v3, "moderated", true)
		local v5 = v2.sendingMessages:Insert(v4)
		local v6 = Immutable.Set(v2, "sendingMessages", v5)
		p = Immutable.Set(p, v6.id, v6)

		return p
	end,
	[MessageFailedToSend.name] = function(p, p2)
		local v2 = p[p2.conversationId]

		if not v2 then
			return p
		end

		local v3 = v2.sendingMessages:Get(p2.messageId)

		if not v3 then
			return p
		end

		local v4 = Immutable.Set(v3, "failed", true)
		local v5 = v2.sendingMessages:Insert(v4)
		local v6 = Immutable.Set(v2, "sendingMessages", v5)
		p = Immutable.Set(p, v6.id, v6)

		return p
	end,
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		for _, v2 in ipairs(responseBody) do
			p = updateConversationReducer(p, (Conversation.fromWeb(v2)))
		end

		return p
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if not (responseBody and responseBody.conversations) then
			return p
		end

		for _, conversation in responseBody.conversations do
			local v2 = ConversationChannels.fromChannelsApi(conversation)
			p = updateConversationReducer(p, v2)
			local messagesFromConversationResponse = getMessagesFromConversationResponse(conversation) -- inferred equivalent call

			if not (messagesFromConversationResponse and #messagesFromConversationResponse > 0) then
				continue
			end

			local v3 = {
				messages = LuauPolyfill.Array.map(messagesFromConversationResponse, function(p3)
					return MessageModel.fromChannelsApi(p3, v2.id)
				end)
			}

			p = addMessagesToConversation(p, v2.id, v3)
		end

		return p
	end,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = function(p, p2)
		local conversation_id = p2.queryArgs.conversation_id
		local responseBody = p2.responseBody

		local v2 = p[conversation_id]

		if not v2 then
			return p
		end

		assert(v2, "FFlagLuauTinyControlFlowAnalysis")

		local previousCursor = v2.previousCursor or nil
		local nextCursor = v2.nextCursor or nil

		if not responseBody then
			return p
		end

		local messages = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)
		local next_cursor

		if responseBody.next_cursor ~= "" then
			next_cursor = responseBody.next_cursor
		end

		if previousCursor == nil then
			if responseBody.previous_cursor == "" then
				previousCursor = nil
			else
				previousCursor = responseBody.previous_cursor
			end
		end

		local v3 = addMessagesToConversation(p, conversation_id, {
			messages = messages,
			nextCursor = next_cursor or nextCursor,
			previousCursor = previousCursor
		})

		if next_cursor then
			return v3
		end

		local v4 = v3[conversation_id]

		if v4 then
			local v5 = Immutable.Set(v4, "fetchedOldestMessage", true)
			return (Immutable.Set(v3, v5.id, v5))
		end

		return v3
	end,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = function(p, p2)
		local conversation_id = p2.queryArgs.conversation_id
		local responseBody = p2.responseBody

		local v2 = p[conversation_id]

		if not v2 then
			return p
		end

		assert(v2, "FFlagLuauTinyControlFlowAnalysis")

		local previousCursor = v2.previousCursor or nil
		local nextCursor = v2.nextCursor or nil

		if not responseBody then
			return p
		end

		local messages = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)

		if nextCursor == nil then
			if responseBody.next_cursor == "" then
				nextCursor = nil
			else
				nextCursor = responseBody.next_cursor
			end
		end

		local v3

		if responseBody.previous_cursor ~= "" then
			v3 = responseBody.previous_cursor
		end

		return (addMessagesToConversation(p, conversation_id, {
			messages = messages,
			nextCursor = nextCursor,
			previousCursor = v3 or previousCursor,
			shouldMarkConversationUnread = getShouldMarkConversationUnread(v2, messages)
		}))
	end,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = function(p, p2)
		local conversation = p2.responseBody.conversations[1]

		if not conversation then
			return p
		end

		local v2 = ConversationChannels.fromChannelsApi(conversation)
		local v3 = updateConversationReducer(p, v2)
		local messagesFromConversationResponse = getMessagesFromConversationResponse(conversation) -- inferred equivalent call

		if messagesFromConversationResponse and #messagesFromConversationResponse > 0 then
			local v4 = {
				messages = LuauPolyfill.Array.map(messagesFromConversationResponse, function(p3)
					return MessageModel.fromChannelsApi(p3, v2.id)
				end)
			}

			return (addMessagesToConversation(v3, v2.id, v4))
		end

		return v3
	end,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if not (responseBody and responseBody.conversations) then
			return p
		end

		for _, conversation in responseBody.conversations do
			local v2 = ConversationChannels.fromChannelsApi(conversation)
			p = updateConversationReducer(p, v2)
			local messagesFromConversationResponse = getMessagesFromConversationResponse(conversation) -- inferred equivalent call

			if not (messagesFromConversationResponse and #messagesFromConversationResponse > 0) then
				continue
			end

			local v3 = {
				messages = LuauPolyfill.Array.map(messagesFromConversationResponse, function(p3)
					return MessageModel.fromChannelsApi(p3, v2.id)
				end)
			}

			p = addMessagesToConversation(p, v2.id, v3)
		end

		return p
	end,
	[AppChatNetworking.rodux.MarkConversation.Succeeded.name] = function(p, p2)
		return markConversationAndMessagesAsRead(p, p2.postBody.conversation_ids[1])
	end,
	[AppChatNetworking.rodux.TranslateUserMessage.Succeeded.name] = getFFlagAppChatEnableManualTranslation() and function(p, p2)
		local content_to_display = p2.responseBody.content_to_display

		if p2.postBody.conversation_id and p2.postBody.message_id then
			return updateMessageContentToDisplay(
				p,
				p2.postBody.conversation_id,
				p2.postBody.message_id,
				content_to_display
			)
		end

		return p
	end or nil,
	[ReceivedChannelsMigrationConflict.name] = function(_, _)
		return {}
	end,
	[FriendConversationCreated.name] = function(p, p2)
		if p[p2.oldFriendConversationId] then
			return Immutable.Set(p, p2.oldFriendConversationId, nil)
		end

		return p
	end,
	[FriendshipDestroyed.name] = function(p, p2)
		local v2

		if p2.userId1 == "localUserId" then
			if p2.userId2 ~= "localUserId" then
				v2 = p2.userId2
			end
		else
			v2 = p2.userId1
		end

		if not v2 then
			return p
		end

		assert(v2, "FFlagLuauTinyControlFlowAnalysis")

		local friendConversationId = ConversationChannels.getFriendConversationId({ v2 })

		if p[friendConversationId] then
			return Immutable.Set(p, friendConversationId, nil)
		end

		return p
	end,
	[NetworkingBlocking.BlockUserById.Succeeded.name] = getFFlagAppChatPCMFixBlocking() and function(p, p2)
		local users = tostring(p2.namedIds.users)

		if not users then
			return p
		end

		local oneToOneConversationIdFromFriendId = getOneToOneConversationIdFromFriendId(p, users)
		local v2

		if oneToOneConversationIdFromFriendId and p[oneToOneConversationIdFromFriendId] then
			v2 = Immutable.Set(p, oneToOneConversationIdFromFriendId, nil)
		else
			v2 = p
		end

		local friendConversationId = ConversationChannels.getFriendConversationId({ users })

		if friendConversationId and p[friendConversationId] then
			return (Immutable.Set(p, friendConversationId, nil))
		end

		return v2
	end or nil,
	[ReloadedMessagesForConversations.name] = function(p, p2)
		for _, conversationId in p2.conversationIds do
			local v2 = p[conversationId]
			p = Cryo.Dictionary.join(p, {
				[conversationId] = Cryo.Dictionary.join(v2, {
					messages = ConversationChannels.getEmptyMessages(),
					sendingMessages = ConversationChannels.getEmptySendingMessages(),
					previousCursor = Cryo.None,
					nextCursor = Cryo.None,
					fetchedOldestMessage = false
				})
			})
		end

		return p
	end,
	[ConversationModerationTypeChanged.name] = function(p, p2)
		local conversationId = p2.conversationId
		local moderationType = p2.moderationType
		local v2 = p[conversationId]

		if not v2 then
			return p
		end

		local v3 = Immutable.Set(v2, "moderationType", moderationType)
		return Immutable.Set(p, conversationId, v3)
	end,
	[AppChatNetworking.rodux.RecordModalSequenceResponse.Succeeded.name] = function(p, p2)
		local postBody = p2.postBody

		if postBody.action_type ~= Constants.ModalAction.Accept then
			return p
		end

		local v2 = v[postBody.modal_variant]

		if not v2 then
			return p
		end

		local conversation_id = postBody.conversation_id
			or ConversationChannels.getFriendConversationId({ postBody.friend_id })

		local v3 = conversation_id and p[conversation_id]

		if v3 then
			return Immutable.Set(p, conversation_id, Immutable.Set(v3, v2.field, v2.value))
		end

		return p
	end
})
