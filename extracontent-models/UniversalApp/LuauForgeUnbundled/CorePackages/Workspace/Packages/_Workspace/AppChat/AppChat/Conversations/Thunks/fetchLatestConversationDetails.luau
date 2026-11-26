local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local processConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/processConversations")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

return function(p2)
	return function(object)
		Logger:info("Fetching latest conversation details for conversationId: {}", p2)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local v5 = { conversationId = p2 }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v5
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v5
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetConversationDetails",
				v5
			)
		end

		return object:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(p2)):andThen(function(p3)
			local responseBody = p3.responseBody

			assert(
				responseBody.conversations and #responseBody.conversations == 1,
				"Expected exactly one conversation in response body"
			)

			object:dispatch(processConversations(responseBody.conversations))

			if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
				local v5 = { conversationId = p2 }
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					v5
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
					v5
				)
			end

			return ConversationChannels.fromChannelsApi(responseBody.conversations[1])
		end):catch(function(p3)
			Logger:warning("Failure in fetchLatestConversationDetails, Status: " .. tostring(p3))
		end)
	end
end
