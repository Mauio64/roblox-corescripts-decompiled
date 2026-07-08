local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Immutable = require(AppChatParent.AppCommonLib).Immutable
local SendMessagePolicy = require(script.Parent.SendMessagePolicy)
local MessageModel = require(AppChat.Models.MessageModel)
local DateTime = require(AppChatParent.Time).DateTime
local ReceivedChatResponse = require(AppChat.Conversations.Thunks.ReceivedChatResponse)
local SendingMessage = require(AppChat.Conversations.Actions.SendingMessage)
local SentMessage = require(AppChat.Conversations.Actions.SentMessage)
local StatusCodes = require(AppChatParent.Http).StatusCodes
local MessageFailedToSend = require(AppChat.Conversations.Actions.MessageFailedToSend)
local MessageModerated = require(AppChat.Conversations.Actions.MessageModerated)
local ResponseStatus = require(AppChatParent.AppChatNetworking).Constants.ResponseStatus
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local EnumScreens = require(AppChat.EnumScreens)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)

require(AppChat.Models.ConversationChannels)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local n1 = 0
local v22 = require(AppChat.Logger):new(script.Name)

local function getAscendingNumber() -- line: 31
	-- upvalues: n1 (ref)
	n1 += 1

	return n1
end

local self = setmetatable({}, SendMessagePolicy)

self.__index = self

function self.new(p1, p2, p3) -- line: 39
	-- upvalues: MessageModel (copy)
	return (setmetatable({
		messageSendingId = MessageModel.newSendingId(),
		conversationId = p2,
		replyingToMessage = p3
	}, p1))
end
function self.onBeforeSendingMessage(p4, p5) -- line: 47
	-- upvalues: v22 (copy), getDeepValue2 (copy), MessageModel (copy), Immutable (copy), n1 (ref), DateTime (copy), SendingMessage (copy)
	v22:trace("onBeforeSendingMessage conversationId: {} messageSendingId: {}, replyingToId: {}", p4.conversationId, p4.messageSendingId, if not p4.replyingToMessage then nil else p4.replyingToMessage.id)

	local v30 = getDeepValue2(p5:getState(), `ChatAppReducer.Conversations.{ p4.conversationId }`)
	local v31 = v30 and v30.moderationType
	local newSending = MessageModel.newSending
	local JoinDictionaries = Immutable.JoinDictionaries
	local t1 = {
		id = p4.messageSendingId
	}

	n1 += 1
	t1.order = n1
	t1.conversationId = p4.conversationId
	t1.repliesTo = p4.replyingToMessage
	t1.sent = DateTime.now()
	t1.moderationType = v31

	local v35 = newSending(JoinDictionaries(t1, p4:sendingMessagePayload()))

	p4.sendingMessageStableKey = v35.stableKey
	assert(v35, "Failed to create sending message placeholder")
	p5:dispatch(SendingMessage(p4.conversationId, v35))
end
function self.sendingMessagePayload(_) -- line: 74
	error("Override me")
end
function self.onSuccess(p7, p8, p9) -- line: 78
	-- upvalues: v22 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), SentMessage (copy), ReceivedChatResponse (copy)
	v22:debug("Message sent successfully. conversationId: {} messageSendingId: {} replyingToId: {}", p7.conversationId, p7.messageSendingId, if not p7.replyingToMessage then nil else p7.replyingToMessage.id)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local t2 = {
				conversationId = p7.conversationId
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, t2)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived, t2)
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, {
				conversationId = p7.conversationId
			})
		end
	end

	p8:dispatch(SentMessage(p7.conversationId, p7.messageSendingId))
	p8:dispatch(ReceivedChatResponse(p7.conversationId, p9.responseBody, p7.sendingMessageStableKey))

	return p9
end
function self.onFailure(p10, p11, p12) -- line: 112
	-- upvalues: v22 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), StatusCodes (copy), ReceivedChannelsMigrationConflict (copy), NavigateIntoChat (copy), EnumScreens (copy), MessageFailedToSend (copy), ResponseStatus (copy), MessageModerated (copy)
	v22:error("Failed to send message. conversationId: {}, messageSendingId: {}, responseCode: {}", p10.conversationId, p10.messageSendingId, p12.responseCode)

	if FFlagAppChatPerfTracking then
		if FFlagAppChatMessageTTIMilestones then
			local t3 = {
				conversationId = p10.conversationId
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, t3)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived, t3)
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, {
				conversationId = p10.conversationId
			})
		end
	end

	if not p12 or (p12.responseCode ~= nil and p12.responseCode ~= StatusCodes.OK or (p12.StatusCode ~= nil and p12.StatusCode ~= StatusCodes.OK or (not p12.responseBody or (not p12.responseBody.messages or #p12.responseBody.messages == 0)))) then
		if p12.StatusCode == StatusCodes.CONFLICT then
			v22:error("Message sent conflicting system (409). Reloading messages...")
			p11:dispatch(ReceivedChannelsMigrationConflict())
			p11:dispatch(NavigateIntoChat({
				screen = EnumScreens.ChatLanding,
				params = {
					key = tostring(os.clock())
				}
			}))

			return p12
		end

		p11:dispatch(MessageFailedToSend(p10.conversationId, p10.messageSendingId))
		v22:error("Message could not be sent, no response body or no messages in response body")

		return p12
	end

	if p12.responseBody.messages[1].status and p12.responseBody.messages[1].status == ResponseStatus.MODERATED then
		p11:dispatch(MessageModerated(p10.conversationId, p10.messageSendingId))
		v22:error("Message was moderated.")

		return p12
	end

	p11:dispatch(MessageFailedToSend(p10.conversationId, p10.messageSendingId))
	v22:error("Message could not be sent, no response body or no messages in response body")

	return p12
end

return self
