local requestTimeDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").RequestTimeDiag
local FFlagDisableLegacyReportToDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags/FFlagDisableLegacyReportToDiag")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").StatusCodes

local responseStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking").Constants.ResponseStatus
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("SendMessageUsingPolicy")

local function invokeSendMessage(object, p2)
	local success, result = pcall(function()
		return object:sendMessage(p2)
	end)

	if success then
		return result
	end

	v5:error("sendPolicy:sendMessage threw synchronously: {}", (tostring(result)))
	return Promise.reject({ sendMessageSyncError = tostring(result) })
end

return function(object, p2)
	local v6

	if FFlagDisableLegacyReportToDiag then
		v6 = nil
	else
		v6 = requestTimeDiag:new(Constants.PerformanceMeasurement.LUA_CHAT_SEND_MESSAGE)
	end

	return function(p3)
		object:onBeforeSendingMessage(p3)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local v7 = { conversationId = object.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v7
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v7
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.MessageSendTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"SendChatTextMessage",
				v7
			)
		end

		return invokeSendMessage(object, p3):andThen(function(p4)
			if v6 then
				v6:report()
			end

			if
				p4
				and p4.responseBody
				and p4.responseCode == statusCodes.OK
				and p4.responseBody.messages
				and #p4.responseBody.messages ~= 0
				and (not p4.responseBody.messages[1].status or p4.responseBody.messages[1].status == "" or p4.responseBody.messages[1].status == responseStatus.SUCCESS)
			then
				return p4
			end

			return Promise.reject(p4)
		end):andThen(function(p4)
			return object:onSuccess(p3, p4)
		end):catch(function(p4)
			return object:onFailure(p3, p4)
		end)
	end
end
