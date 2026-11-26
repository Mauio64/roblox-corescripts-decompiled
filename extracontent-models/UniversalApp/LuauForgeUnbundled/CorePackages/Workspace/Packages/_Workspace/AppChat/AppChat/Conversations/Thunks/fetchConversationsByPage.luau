local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("fetchConversationsByPage")

local processConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/processConversations")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local FFlagAppChatConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationStore")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local ReceivedPageConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedPageConversations")
local RequestPageConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RequestPageConversations")

return function(value)
	v5:info("Fetching conversations by page with cursor {}", value or "nil")
	return function(object)
		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and value == nil then
			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatLandingTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatLandingTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.ChatLandingTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetUserConversations"
			)
		end

		if FFlagAppChatConversationStore then
			object:dispatch(RequestPageConversations())
		end

		return object:dispatch(AppChatNetworking.rodux.GetUserConversations.API(value)):tap(function(p2)
			object:dispatch(processConversations(p2.responseBody.conversations))

			if FFlagAppChatConversationStore then
				object:dispatch(ReceivedPageConversations())
			end

			if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and value == nil then
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.ChatLandingTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.ChatLandingTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived
				)
			end
		end):andThen(function(p2)
			local responseBody = p2.responseBody

			if responseBody and responseBody.next_cursor and responseBody.next_cursor ~= "" then
				v5:debug("Next cursor found: {}", responseBody.next_cursor)
				return value, responseBody.next_cursor
			end

			v5:debug("No next cursor found")
			return value, ""
		end):catch(function(p2)
			if FFlagAppChatConversationStore then
				object:dispatch(ReceivedPageConversations())
			end

			v5:warning("Error in GetUserConversations request. Error: {}", (tostring(p2)))
		end)
	end
end
