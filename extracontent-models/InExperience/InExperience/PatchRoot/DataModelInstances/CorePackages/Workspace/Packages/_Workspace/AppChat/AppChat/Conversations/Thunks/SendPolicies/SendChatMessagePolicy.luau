local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local SendMessagePolicy = require(script.Parent.SendMessagePolicy)
local MessageModel = require(AppChat.Models.MessageModel)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local ReceivedChatResponse = require(AppChat.Conversations.Thunks.ReceivedChatResponse)
local SendingMessage = require(AppChat.Conversations.Actions.SendingMessage)
local SentMessage = require(AppChat.Conversations.Actions.SentMessage)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local MessageFailedToSend = require(AppChat.Conversations.Actions.MessageFailedToSend)
local MessageModerated = require(AppChat.Conversations.Actions.MessageModerated)
local AppChatNetworking = require(parent.AppChatNetworking)
local ResponseStatus = AppChatNetworking.Constants.ResponseStatus
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local EnumScreens = require(AppChat.EnumScreens)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
require(AppChat.Models.ConversationChannels)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local FFlagAppChatCoalesceSendMessageWrites = require(AppChat.Flags.FFlagAppChatCoalesceSendMessageWrites)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local count = 0

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function getAscendingNumber() -- 1 equivalent call inferred from this helper
	count += 1
	return count
end

local object = setmetatable({}, SendMessagePolicy)
object.__index = object

function object:new(conversationId, replyingToMessage)
	return (setmetatable(
		{
			messageSendingId = MessageModel.newSendingId(),
			conversationId = conversationId,
			replyingToMessage = replyingToMessage
		},
		self
	))
end

function object:onBeforeSendingMessage(object2)
	local conversationId = self.conversationId
	local messageSendingId = self.messageSendingId
	local v2

	if self.replyingToMessage then
		v2 = self.replyingToMessage.id
	end

	v:trace(
		"onBeforeSendingMessage conversationId: {} messageSendingId: {}, replyingToId: {}",
		conversationId,
		messageSendingId,
		v2
	)

	local deepValue2 = getDeepValue2(object2:getState(), `ChatAppReducer.Conversations.{self.conversationId}`)
	local moderationType = deepValue2 and deepValue2.moderationType

	local v3 = MessageModel.newSending(Immutable.JoinDictionaries({
		id = self.messageSendingId,
		order = getAscendingNumber(), -- inferred equivalent call
		conversationId = self.conversationId,
		repliesTo = self.replyingToMessage,
		sent = DateTime.now(),
		moderationType = moderationType
	}, self:sendingMessagePayload()))
	self.sendingMessageStableKey = v3.stableKey
	assert(v3, "Failed to create sending message placeholder")

	object2:dispatch(SendingMessage(self.conversationId, v3))
end

function object:sendingMessagePayload()
	error("Override me")
end

function object.onSuccess(data, object2, p)
	local conversationId = data.conversationId
	local messageSendingId = data.messageSendingId
	local v2

	if data.replyingToMessage then
		v2 = data.replyingToMessage.id
	end

	v:debug(
		"Message sent successfully. conversationId: {} messageSendingId: {} replyingToId: {}",
		conversationId,
		messageSendingId,
		v2
	)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local v3 = { conversationId = data.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				v3
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
				v3
			)
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, {
				conversationId = data.conversationId
			})
		end
	end

	if FFlagAppChatCoalesceSendMessageWrites then
		GetConversationMessageListStore(false).batchMutations(function()
			object2:dispatch(SentMessage(data.conversationId, data.messageSendingId))
			object2:dispatch(ReceivedChatResponse(data.conversationId, p.responseBody, data.sendingMessageStableKey))
		end)
		return p
	end

	object2:dispatch(SentMessage(data.conversationId, data.messageSendingId))
	object2:dispatch(ReceivedChatResponse(data.conversationId, p.responseBody, data.sendingMessageStableKey))
	return p
end

function object.onFailure(p, object2, data)
	v:error(
		"Failed to send message. conversationId: {}, messageSendingId: {}, responseCode: {}",
		p.conversationId,
		p.messageSendingId,
		data.responseCode
	)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local v2 = { conversationId = p.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				v2
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
				v2
			)
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, {
				conversationId = p.conversationId
			})
		end
	end

	if
		not data
		or data.responseCode ~= nil and data.responseCode ~= StatusCodes.OK
		or data.StatusCode ~= nil and data.StatusCode ~= StatusCodes.OK
		or not data.responseBody
		or not data.responseBody.messages
		or #data.responseBody.messages == 0
	then
		if data.StatusCode == StatusCodes.CONFLICT then
			v:error("Message sent conflicting system (409). Reloading messages...")
			object2:dispatch(ReceivedChannelsMigrationConflict())
			object2:dispatch(NavigateIntoChat({
				screen = EnumScreens.ChatLanding,
				params = { key = tostring(os.clock()) }
			}))
		else
			object2:dispatch(MessageFailedToSend(p.conversationId, p.messageSendingId))
			v:error("Message could not be sent, no response body or no messages in response body")
		end
	elseif
		data.responseBody.messages[1].status
		and data.responseBody.messages[1].status == ResponseStatus.MODERATED
	then
		object2:dispatch(MessageModerated(p.conversationId, p.messageSendingId))
		v:error("Message was moderated.")
	else
		object2:dispatch(MessageFailedToSend(p.conversationId, p.messageSendingId))
		v:error("Message could not be sent, no response body or no messages in response body")
	end

	return data
end

return object
