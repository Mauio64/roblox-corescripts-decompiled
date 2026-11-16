local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local SignalsExperimental = require(parent.SignalsExperimental)
local ExpChatShared = require(parent.ExpChatShared)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker

local AppChatNetworking = require(parent.AppChatNetworking)
local createConversationFromFriendPlaceholder = require(parent.AppChat.createConversationFromFriendPlaceholder)
local GetConversationMessageStore = require(parent.AppChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)
local ingestNewerMessages = require(parent.AppChat.ingestNewerMessages)
local ChatConversationTelemetryEvents = require(parent.AppChat.ChatConversationTelemetryEvents)
local SendMessageError = require(parent.AppChat.SendMessageError)

local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local getConversationMessageSentInfo = require(script.Parent.Parent.Telemetry.ChatConversation.getConversationMessageSentInfo)
local FFlagFriendsChatMessageSendPerfTracking = require(FriendsChat.Flags.FFlagFriendsChatMessageSendPerfTracking)
local FriendsChatTabName = require(FriendsChat.FriendsChatTabName)

local serializeParticipantIdsForTelemetry = require(script.Parent.Parent.Telemetry.App.serializeParticipantIdsForTelemetry)

local v = ExpChatShared.Logger:new(script.Name)

local function isSendResponseAccepted(data): boolean
	if
		data == nil
		or data.responseBody == nil
		or data.responseCode ~= nil and data.responseCode ~= 200
		or data.StatusCode ~= nil and data.StatusCode ~= 200
	then
		return false
	end

	local messages = data.responseBody.messages

	if messages == nil or #messages == 0 then
		return false
	end

	local status = messages[1].status
	return status == nil or status == "" or status == "success"
end

local function sendFriendsChatMessage(data)
	local text = data.text
	local conversationId = data.conversationId
	local isFriendPlaceholder = data.isFriendPlaceholder
	local hasRealConversation = data.hasRealConversation
	local emit = data.emit

	local v2 = "sending-friends-message-" .. HttpService:GenerateGUID(false)
	local v3

	if FFlagFriendsChatMessageSendPerfTracking then
		v3 = ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
			messageId = v2
		}, {
			tabName = FriendsChatTabName
		})
	else
		v3 = false
	end

	task.spawn(function()
		local conversationId2 = conversationId or ""
		local localPlayer = Players.LocalPlayer

		if isFriendPlaceholder and conversationId ~= nil then
			if v3 then
				ExpChatPerfTracker.cancel(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
					messageId = v2
				})
			end

			local conversation = ExpChatConversationListAdapter.getConversationStore().getConversation(
				conversationId,
				false
			)

			if conversation == nil then
				v:warning(`Unable to find friend placeholder {conversationId}`)
				return
			end

			local conversationFromFriendPlaceholder = createConversationFromFriendPlaceholder(
				conversation,
				not localPlayer and 0 or localPlayer.UserId
			)

			if conversationFromFriendPlaceholder == nil then
				v:warning(`Unable to create conversation for friend placeholder {conversationId}`)
				return
			end

			local v4, v5 = conversationFromFriendPlaceholder:await()

			if not v4 or v5 == nil then
				v:warning(`Failed to create conversation for friend placeholder {conversationId}`)
				return
			end

			conversationId2 = v5.id

			if data.onFriendPlaceholderConversationCreated ~= nil then
				data.onFriendPlaceholderConversationCreated(conversationId2)
			end
		elseif not hasRealConversation then
			if v3 then
				ExpChatPerfTracker.cancel(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
					messageId = v2
				})
			end

			return
		end

		local conversationMessageStore = GetConversationMessageStore(false)
		local conversationMessageListStore = GetConversationMessageListStore(false)

		local v4 = {
			id = v2,
			type = "user",
			content = text,
			created_at = tostring(os.time()),
			sender_user_id = 0,
			status = "Pending",
			conversationId = 0
		}
		local sender_user_id

		if localPlayer then
			sender_user_id = localPlayer.UserId
		end

		v4.sender_user_id = sender_user_id

		v4.conversationId = conversationId2

		conversationMessageStore.upsertMessages({ [v2] = v4 })
		conversationMessageListStore.prependMessages(conversationId2, { v2 })

		local content = string.rep("#", utf8.len(text) or #text)

		local conversation = ExpChatConversationListAdapter.getConversationStore().getConversation(
			conversationId2,
			false
		)
		local v5

		if conversation then
			v5 = conversation.participants
		end

		local recipientIds = serializeParticipantIdsForTelemetry(v5, not localPlayer and 0 or localPlayer.UserId)

		AppChatNetworking.http.SendChatTextMessage(nil, conversationId2, text):andThen(function(p)
			emit(
				ChatConversationTelemetryEvents.ConversationMessageSent,
				getConversationMessageSentInfo(p, recipientIds)
			)

			if not isSendResponseAccepted(p) then
				conversationMessageStore.updateMessage(v2, { content = content, status = "Failed" })
				return
			end

			local messages = p.responseBody.messages or {}

			SignalsExperimental.batch(function()
				if #ingestNewerMessages(conversationId2, messages) == 0 then
					conversationMessageStore.updateMessage(v2, {
						content = content,
						status = "Failed"
					})
					return
				end

				ExpChatConversationListAdapter.updateConversationPreviewFromMessages(conversationId2, messages, {
					hasUnreadMessages = false,
					localUserId = not localPlayer and 0 or localPlayer.UserId
				})

				conversationMessageListStore.removeMessage(conversationId2, v2)
				conversationMessageStore.removeMessage(v2)
			end)
		end):catch(function(p)
			v:warning(`Failed to send message to {conversationId2}: {tostring(p)}`)

			emit(ChatConversationTelemetryEvents.ConversationMessageSent, {
				messageSentResult = SendMessageError.OtherFailure,
				recipientIds = recipientIds
			})

			conversationMessageStore.updateMessage(v2, { content = content, status = "Failed" })
		end)
	end)
end

return sendFriendsChatMessage
