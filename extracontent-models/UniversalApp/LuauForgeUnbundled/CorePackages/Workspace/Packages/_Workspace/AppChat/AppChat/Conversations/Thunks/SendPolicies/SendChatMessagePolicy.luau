local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Immutable

local SendMessagePolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendPolicies/SendMessagePolicy")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local ReceivedChatResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/ReceivedChatResponse")
local SendingMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/SendingMessage")
local SentMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/SentMessage")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").StatusCodes
local MessageFailedToSend = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/MessageFailedToSend")
local MessageModerated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/MessageModerated")
local responseStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking").Constants.ResponseStatus
local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local ReceivedChannelsMigrationConflict = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedChannelsMigrationConflict")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local GetConversationMessageListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore")
local FFlagAppChatCoalesceSendMessageWrites = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatCoalesceSendMessageWrites")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local count = 0

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("SendChatMessagePolicy")

local function getAscendingNumber()
	count += 1
	return count
end

local object = setmetatable({}, SendMessagePolicy)
object.__index = object

function object.new(p2, p3, p4)
	return (setmetatable(
		{
			messageSendingId = MessageModel.newSendingId(),
			conversationId = p3,
			replyingToMessage = p4
		},
		p2
	))
end

function object:onBeforeSendingMessage(object3)
	local conversationId = self.conversationId
	local messageSendingId = self.messageSendingId
	local v8 = if self.replyingToMessage then self.replyingToMessage.id else nil
	v5:trace(
		"onBeforeSendingMessage conversationId: {} messageSendingId: {}, replyingToId: {}",
		conversationId,
		messageSendingId,
		v8
	)

	local v9 = getDeepValue2(object3:getState(), `ChatAppReducer.Conversations.{self.conversationId}`)
	local moderationType = v9 and v9.moderationType

	local newSending = MessageModel.newSending
	local joinDictionaries = immutable.JoinDictionaries
	local v10 = {
		id = self.messageSendingId,
		order = 0,
		conversationId = 0,
		repliesTo = 0,
		sent = 0,
		moderationType = 0
	}
	count += 1

	v10.order = count
	v10.conversationId = self.conversationId
	v10.repliesTo = self.replyingToMessage
	v10.sent = dateTime.now()
	v10.moderationType = moderationType
	local v11 = newSending(joinDictionaries(v10, self:sendingMessagePayload()))
	self.sendingMessageStableKey = v11.stableKey
	assert(v11, "Failed to create sending message placeholder")

	object3:dispatch(SendingMessage(self.conversationId, v11))
end

function object:sendingMessagePayload()
	error("Override me")
end

function object.onSuccess(data, object2, p2)
	local conversationId = data.conversationId
	local messageSendingId = data.messageSendingId
	local v8 = if data.replyingToMessage then data.replyingToMessage.id else nil
	v5:debug(
		"Message sent successfully. conversationId: {} messageSendingId: {} replyingToId: {}",
		conversationId,
		messageSendingId,
		v8
	)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local v9 = { conversationId = data.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				v9
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
				v9
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
			object2:dispatch(ReceivedChatResponse(data.conversationId, p2.responseBody, data.sendingMessageStableKey))
		end)
		return p2
	end

	object2:dispatch(SentMessage(data.conversationId, data.messageSendingId))
	object2:dispatch(ReceivedChatResponse(data.conversationId, p2.responseBody, data.sendingMessageStableKey))
	return p2
end

function object.onFailure(p2, object2, data)
	v5:error(
		"Failed to send message. conversationId: {}, messageSendingId: {}, responseCode: {}",
		p2.conversationId,
		p2.messageSendingId,
		data.responseCode
	)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local v6 = { conversationId = p2.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				v6
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
				AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
				v6
			)
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, {
				conversationId = p2.conversationId
			})
		end
	end

	if
		not data
		or data.responseCode ~= nil and data.responseCode ~= statusCodes.OK
		or data.StatusCode ~= nil and data.StatusCode ~= statusCodes.OK
		or not data.responseBody
		or not data.responseBody.messages
		or #data.responseBody.messages == 0
	then
		if data.StatusCode == statusCodes.CONFLICT then
			v5:error("Message sent conflicting system (409). Reloading messages...")
			object2:dispatch(ReceivedChannelsMigrationConflict())
			object2:dispatch(NavigateIntoChat({
				screen = EnumScreens.ChatLanding,
				params = { key = tostring(os.clock()) }
			}))
		else
			object2:dispatch(MessageFailedToSend(p2.conversationId, p2.messageSendingId))
			v5:error("Message could not be sent, no response body or no messages in response body")
		end
	elseif
		data.responseBody.messages[1].status
		and data.responseBody.messages[1].status == responseStatus.MODERATED
	then
		object2:dispatch(MessageModerated(p2.conversationId, p2.messageSendingId))
		v5:error("Message was moderated.")
	else
		object2:dispatch(MessageFailedToSend(p2.conversationId, p2.messageSendingId))
		v5:error("Message could not be sent, no response body or no messages in response body")
	end

	return data
end

return object
