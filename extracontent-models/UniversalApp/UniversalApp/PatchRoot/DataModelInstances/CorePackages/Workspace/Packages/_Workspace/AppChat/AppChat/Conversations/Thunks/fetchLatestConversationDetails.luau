local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local processConversations = require(script.Parent.processConversations)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Logger = require(AppChat.Logger)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

return function(s1: string) -- line: 18
	-- upvalues: Logger (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), AppChatNetworking (copy), processConversations (copy), ConversationChannels (copy)
	return function(p1) -- line: 19
		-- upvalues: Logger (copy), s1 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), AppChatNetworking (copy), processConversations (copy), ConversationChannels (copy)
		Logger:info("Fetching latest conversation details for conversationId: {}", s1)

		if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
			local t1 = {
				conversationId = s1
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, t1)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch, t1)
			AppChatPerfTracker.trackRequest(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataStarted.Name, "GetConversationDetails", t1)
		end

		return p1:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(s1)):andThen(function(p2) -- line: 45
			-- upvalues: p1 (copy), processConversations (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), s1 (copy), AppChatPerfTracker (copy), ConversationChannels (copy)
			local responseBody = p2.responseBody

			assert(responseBody.conversations and #responseBody.conversations == 1, "Expected exactly one conversation in response body")
			p1:dispatch(processConversations(responseBody.conversations))

			if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones then
				local t2 = {
					conversationId = s1
				}

				AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, t2)
				AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.PrimaryDataReady.Name, AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived, t2)
			end

			return ConversationChannels.fromChannelsApi(responseBody.conversations[1])
		end):catch(function(p3) -- line: 72
			-- upvalues: Logger (copy)
			Logger:warning("Failure in fetchLatestConversationDetails, Status: " .. tostring(p3))
		end)
	end
end
