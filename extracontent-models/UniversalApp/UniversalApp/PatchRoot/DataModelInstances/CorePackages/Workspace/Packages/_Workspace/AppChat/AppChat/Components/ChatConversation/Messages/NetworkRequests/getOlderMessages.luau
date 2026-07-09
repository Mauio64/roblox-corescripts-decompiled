local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

return function(p1, _, s1: string?) -- line: 9
	-- upvalues: FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), AppChatNetworking (copy)
	return function(p3) -- line: 10
		-- upvalues: FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), s1 (copy), p1 (copy), AppChatPerfTracker (copy), AppChatNetworking (copy)
		local v11 = FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and s1 == nil)

		if v11 then
			local t1 = {
				conversationId = p1
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, t1)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch, t1)
			AppChatPerfTracker.trackRequest(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, "GetOlderMessages", t1)
		end

		local v13 = p3:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p1, s1))

		if v11 then
			v13 = v13:tap(function() -- line: 39
				-- upvalues: p1 (copy), AppChatPerfTracker (copy)
				local t2 = {
					conversationId = p1
				}

				AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, t2)
				AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived, t2)
			end)
		end

		return v13:catch(function(p4) -- line: 55
			warn("AppChatNetworking failure in getOlderMessages, Status: " .. tostring(p4))
		end)
	end
end
