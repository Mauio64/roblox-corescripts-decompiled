local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Promise = require(parent.Promise)

local Constants = require(AppChat.Constants)
local reportToDiagByCountryCode = require(AppChat.Utils.reportToDiagByCountryCode)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local function fn(p) -- 1 equivalent call inferred from this helper
	local v2 = tick() - p
	reportToDiagByCountryCode(Constants.PerformanceMeasurement.LUA_CHAT_RECEIVE_MESSAGE, "MessageReceivedTime", v2)
end

return function(conversationId: string, flag: boolean, p: number)
	v:info("Getting new messages for {}", conversationId)
	return function(object)
		local v2 = {}

		if not object:getState().ChatAppReducer.Conversations[conversationId] then
			table.insert(
				v2,
				object:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(conversationId)):catch(function(p2)
					v:error(`AppChatNetworking failure in GetConversationDetails: {tostring(p2)}`)
				end)
			)
		end

		local v3 = FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and not flag

		if v3 then
			local v4 = { conversationId = conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v4
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v4
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetNewerMessages",
				v4
			)
		end

		table.insert(
			v2,
			object:dispatch(AppChatNetworking.rodux.GetNewerMessages.API(conversationId)):andThen(function()
				fn(p) -- inferred equivalent call

				if v3 then
					local v4 = { conversationId = conversationId }
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.MessageReceiveTTI,
						AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
						v4
					)

					AppChatPerfTracker.trackSubphase(
						AppChatPerfTracker.Events.MessageReceiveTTI,
						AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
						AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
						v4
					)
				end
			end):catch(function(p2)
				v:error(`AppChatNetworking failure in GetNewerMessages: {tostring(p2)}`)
			end)
		)

		return Promise.allSettled(v2)
	end
end
