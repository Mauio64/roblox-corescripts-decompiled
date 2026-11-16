local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local processConversations = require(script.Parent.processConversations)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Logger = require(AppChat.Logger)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

return function(conversationId: string)
	return function(object)
		Logger:info("Fetching latest conversation details for conversationId: {}", conversationId)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local v = { conversationId = conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetConversationDetails",
				v
			)
		end

		return object:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(conversationId)):andThen(function(p)
			local responseBody = p.responseBody

			assert(
				responseBody.conversations and #responseBody.conversations == 1,
				"Expected exactly one conversation in response body"
			)

			object:dispatch(processConversations(responseBody.conversations))

			if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
				local v = { conversationId = conversationId }
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					v
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
					v
				)
			end

			return ConversationChannels.fromChannelsApi(responseBody.conversations[1])
		end):catch(function(p)
			Logger:warning("Failure in fetchLatestConversationDetails, Status: " .. tostring(p))
		end)
	end
end
