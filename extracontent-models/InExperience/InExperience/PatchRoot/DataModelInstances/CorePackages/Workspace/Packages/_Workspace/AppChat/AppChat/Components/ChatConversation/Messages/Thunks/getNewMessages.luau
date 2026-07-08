local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

game:DefineFastFlag("AppChatChannelsGetNewerMessagesWithPrevCursor", false)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Promise = require(AppChatParent.Promise)
local Constants = require(AppChat.Constants)
local reportToDiagByCountryCode = require(AppChat.Utils.reportToDiagByCountryCode)
local v7 = require(AppChat.Logger):new(script.Name)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

return function(s1: string, b1: boolean, n1: number) -- line: 25
	-- upvalues: v7 (copy), AppChatNetworking (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), reportToDiagByCountryCode (copy), Constants (copy), Promise (copy)
	v7:info("Getting new messages for {}", s1)

	return function(p1) -- line: 27
		-- upvalues: s1 (copy), AppChatNetworking (copy), v7 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), b1 (copy), AppChatPerfTracker (copy), n1 (copy), reportToDiagByCountryCode (copy), Constants (copy), Promise (copy)
		local t1 = {}
		local v18 = p1:getState().ChatAppReducer.Conversations[s1]

		if not v18 then
			table.insert(t1, p1:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(s1)):catch(function(p2) -- line: 34
				-- upvalues: v7 (copy)
				v7:error(`AppChatNetworking failure in GetConversationDetails: { tostring(p2) }`)
			end))
		end

		local v19 = if not game:GetFastFlag("AppChatChannelsGetNewerMessagesWithPrevCursor") then nil else v18 and v18.previousCursor or nil
		local v20 = FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and not b1)

		if v20 then
			local t2 = {
				conversationId = s1
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageReceiveTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, t2)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.MessageReceiveTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch, t2)
			AppChatPerfTracker.trackRequest(AppChatPerfTracker.Events.MessageReceiveTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, "GetNewerMessages", t2)
		end

		table.insert(t1, p1:dispatch(AppChatNetworking.rodux.GetNewerMessages.API(s1, v19)):andThen(function() -- line: 74
			-- upvalues: n1 (copy), reportToDiagByCountryCode (copy), Constants (copy), v20 (copy), s1 (copy), AppChatPerfTracker (copy)
			local v23 = n1
			local v24 = tick() - v23

			reportToDiagByCountryCode(Constants.PerformanceMeasurement.LUA_CHAT_RECEIVE_MESSAGE, "MessageReceivedTime", v24)

			if v20 then
				local t3 = {
					conversationId = s1
				}

				AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageReceiveTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, t3)
				AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.MessageReceiveTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived, t3)
			end
		end):catch(function(p3) -- line: 91
			-- upvalues: v7 (copy)
			v7:error(`AppChatNetworking failure in GetNewerMessages: { tostring(p3) }`)
		end))

		return Promise.allSettled(t1)
	end
end
