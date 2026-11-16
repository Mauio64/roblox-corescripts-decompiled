local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Analytics = require(parent.Analytics)
local RequestTimeDiag = Analytics.RequestTimeDiag
local Constants = require(AppChat.Constants)
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes

local AppChatNetworking = require(parent.AppChatNetworking)
local ResponseStatus = AppChatNetworking.Constants.ResponseStatus
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function invokeSendMessage(object, p)
	local success, result = pcall(function()
		return object:sendMessage(p)
	end)

	if success then
		return result
	end

	v:error("sendPolicy:sendMessage threw synchronously: {}", (tostring(result)))
	return Promise.reject({ sendMessageSyncError = tostring(result) })
end

return function(object, _)
	local v2 = RequestTimeDiag:new(Constants.PerformanceMeasurement.LUA_CHAT_SEND_MESSAGE)

	return function(p)
		object:onBeforeSendingMessage(p)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local v3 = { conversationId = object.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v3
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v3
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"SendChatTextMessage",
				v3
			)
		end

		return invokeSendMessage(object, p):andThen(function(p2)
			v2:report()

			if
				p2
				and p2.responseBody
				and p2.responseCode == StatusCodes.OK
				and p2.responseBody.messages
				and #p2.responseBody.messages ~= 0
				and (not p2.responseBody.messages[1].status or p2.responseBody.messages[1].status == "" or p2.responseBody.messages[1].status == ResponseStatus.SUCCESS)
			then
				return p2
			end

			return Promise.reject(p2)
		end):andThen(function(p2)
			return object:onSuccess(p, p2)
		end):catch(function(p2)
			return object:onFailure(p, p2)
		end)
	end
end
