local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local FFlagAppChatIncrementalPaginationProjection = require(AppChat.Flags.FFlagAppChatIncrementalPaginationProjection)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)

return function(conversationId: string, _, p: string?)
	return function(object)
		local v = FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and p == nil

		if v then
			local v2 = { conversationId = conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v2
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v2
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetOlderMessages",
				v2
			)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			GetConversationMessageViewModelStore(false).conversationMessageListStore.setLoading(conversationId, true)
		end

		local v2 = object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(conversationId, p))

		if v then
			v2 = v2:tap(function()
				local v3 = { conversationId = conversationId }
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					v3
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
					v3
				)
			end)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			v2 = v2:finally(function()
				GetConversationMessageViewModelStore(false).conversationMessageListStore.setLoading(
					conversationId,
					false
				)
			end)
		end

		return v2:catch(function(p2)
			warn("AppChatNetworking failure in getOlderMessages, Status: " .. tostring(p2))
		end)
	end
end
