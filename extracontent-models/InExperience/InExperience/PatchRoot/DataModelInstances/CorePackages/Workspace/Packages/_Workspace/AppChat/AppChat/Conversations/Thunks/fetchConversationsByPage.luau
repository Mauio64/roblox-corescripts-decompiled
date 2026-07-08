local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local v4 = require(AppChat.Logger):new(script.Name)
local processConversations = require(script.Parent.processConversations)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local ReceivedPageConversations = require(AppChat.Conversations.Actions.ReceivedPageConversations)
local RequestPageConversations = require(AppChat.Conversations.Actions.RequestPageConversations)

return function(s1: string?) -- line: 21
	-- upvalues: v4 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), FFlagAppChatConversationStore (copy), RequestPageConversations (copy), AppChatNetworking (copy), processConversations (copy), ReceivedPageConversations (copy)
	v4:info("Fetching conversations by page with cursor {}", s1 or "nil")

	return function(p1) -- line: 23
		-- upvalues: FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), s1 (copy), AppChatPerfTracker (copy), FFlagAppChatConversationStore (copy), RequestPageConversations (copy), AppChatNetworking (copy), processConversations (copy), ReceivedPageConversations (copy), v4 (copy)
		if FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and s1 == nil) then
			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch)
			AppChatPerfTracker.trackRequest(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, "GetUserConversations")
		end

		if FFlagAppChatConversationStore then
			p1:dispatch(RequestPageConversations())
		end

		return p1:dispatch(AppChatNetworking.rodux.GetUserConversations.API(s1)):tap(function(p2) -- line: 47
			-- upvalues: p1 (copy), processConversations (copy), FFlagAppChatConversationStore (copy), ReceivedPageConversations (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), s1 (copy), AppChatPerfTracker (copy)
			p1:dispatch(processConversations(p2.responseBody.conversations))

			if FFlagAppChatConversationStore then
				p1:dispatch(ReceivedPageConversations())
			end

			if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and s1 == nil then
				AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name)
				AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived)
			end
		end):andThen(function(p3) -- line: 65
			-- upvalues: v4 (copy), s1 (copy)
			local responseBody = p3.responseBody

			if responseBody and (responseBody.next_cursor and responseBody.next_cursor ~= "") then
				v4:debug("Next cursor found: {}", responseBody.next_cursor)

				return s1, responseBody.next_cursor
			end

			v4:debug("No next cursor found")

			return s1, ""
		end):catch(function(p4) -- line: 75
			-- upvalues: FFlagAppChatConversationStore (copy), p1 (copy), ReceivedPageConversations (copy), v4 (copy)
			if FFlagAppChatConversationStore then
				p1:dispatch(ReceivedPageConversations())
			end

			v4:warning("Error in GetUserConversations request. Error: {}", (tostring(p4)))
		end)
	end
end
