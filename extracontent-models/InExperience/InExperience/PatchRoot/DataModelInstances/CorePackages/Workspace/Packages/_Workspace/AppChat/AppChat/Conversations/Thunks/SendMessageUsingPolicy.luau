local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RequestTimeDiag = require(AppChatParent.Analytics).RequestTimeDiag
local Constants = require(AppChat.Constants)
local Promise = require(AppChatParent.Promise)
local StatusCodes = require(AppChatParent.Http).StatusCodes
local ResponseStatus = require(AppChatParent.AppChatNetworking).Constants.ResponseStatus
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local FFlagAppChatCatchSendMessageSyncError = require(AppChat.Flags.FFlagAppChatCatchSendMessageSyncError)
local v12 = require(AppChat.Logger):new(script.Name)

local function invokeSendMessage(p1, p2) -- line: 20
	-- upvalues: FFlagAppChatCatchSendMessageSyncError (copy), v12 (copy), Promise (copy)
	if not FFlagAppChatCatchSendMessageSyncError then
		return p1:sendMessage(p2)
	end

	local ok, result = pcall(function() -- line: 25
		-- upvalues: p1 (copy), p2 (copy)
		return p1:sendMessage(p2)
	end)

	if not ok then
		v12:error("sendPolicy:sendMessage threw synchronously: {}", (tostring(result)))

		return Promise.reject({
			sendMessageSyncError = tostring(result)
		})
	end

	return result
end

return function(p3, _) -- line: 37
	-- upvalues: RequestTimeDiag (copy), Constants (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), invokeSendMessage (copy), StatusCodes (copy), ResponseStatus (copy), Promise (copy)
	local v20 = RequestTimeDiag:new(Constants.PerformanceMeasurement.LUA_CHAT_SEND_MESSAGE)

	return function(p5) -- line: 40
		-- upvalues: p3 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), invokeSendMessage (copy), v20 (copy), StatusCodes (copy), ResponseStatus (copy), Promise (copy)
		p3:onBeforeSendingMessage(p5)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local t1 = {
				conversationId = p3.conversationId
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, t1)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch, t1)
			AppChatPerfTracker.trackRequest(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, "SendChatTextMessage", t1)
		end

		return invokeSendMessage(p3, p5):andThen(function(p6) -- line: 65
			-- upvalues: v20 (copy), StatusCodes (copy), ResponseStatus (copy), Promise (copy)
			v20:report()

			if not p6 or (not p6.responseBody or p6.responseCode ~= StatusCodes.OK or not p6.responseBody.messages or #p6.responseBody.messages == 0) or p6.responseBody.messages[1].status and p6.responseBody.messages[1].status ~= "" and p6.responseBody.messages[1].status ~= ResponseStatus.SUCCESS then
				return Promise.reject(p6)
			end

			return p6
		end):andThen(function(p7) -- line: 86
			-- upvalues: p3 (copy), p5 (copy)
			return p3:onSuccess(p5, p7)
		end):catch(function(p8) -- line: 89
			-- upvalues: p3 (copy), p5 (copy)
			return p3:onFailure(p5, p8)
		end)
	end
end
