local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local processConversations = require(script.Parent.processConversations)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local ReceivedPageConversations = require(AppChat.Conversations.Actions.ReceivedPageConversations)
local RequestPageConversations = require(AppChat.Conversations.Actions.RequestPageConversations)

return function(value: string?)
	v:info("Fetching conversations by page with cursor {}", value or "nil")
	return function(object)
		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and value == nil then
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatLandingTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name
			)

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

		return object:dispatch(AppChatNetworking.rodux.GetUserConversations.API(value)):tap(function(p)
			object:dispatch(processConversations(p.responseBody.conversations))

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
		end):andThen(function(p)
			local responseBody = p.responseBody

			if responseBody and responseBody.next_cursor and responseBody.next_cursor ~= "" then
				v:debug("Next cursor found: {}", responseBody.next_cursor)
				return value, responseBody.next_cursor
			end

			v:debug("No next cursor found")
			return value, ""
		end):catch(function(p)
			if FFlagAppChatConversationStore then
				object:dispatch(ReceivedPageConversations())
			end

			v:warning("Error in GetUserConversations request. Error: {}", (tostring(p)))
		end)
	end
end
