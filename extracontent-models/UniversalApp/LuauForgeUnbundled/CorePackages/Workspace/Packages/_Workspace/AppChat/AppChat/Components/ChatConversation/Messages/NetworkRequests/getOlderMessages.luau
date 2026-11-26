local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local fFlagAppChatEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableReactions

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local FFlagAppChatIncrementalPaginationProjection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIncrementalPaginationProjection")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
local GetMessageReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore")

return function(p2, p3, p4)
	return function(object)
		local v5 = FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and p4 == nil

		if v5 then
			local v6 = { conversationId = p2 }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v6
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v6
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetOlderMessages",
				v6
			)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			GetConversationMessageViewModelStore(false).conversationMessageListStore.setLoading(p2, true)
		end

		local v6 = object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p2, p4))

		if v5 then
			v6 = v6:tap(function()
				local v7 = { conversationId = p2 }
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					v7
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.ChatConversationTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
					v7
				)
			end)
		end

		if fFlagAppChatEnableReactions then
			v6 = v6:andThen(function(p5)
				if p5.responseBody then
					GetMessageReactionsStore(false).ingestMessageReactions(p5.responseBody.messages)
				end

				return p5
			end)
		end

		if FFlagAppChatIncrementalPaginationProjection then
			v6 = v6:finally(function()
				GetConversationMessageViewModelStore(false).conversationMessageListStore.setLoading(p2, false)
			end)
		end

		return v6:catch(function(p5)
			warn("AppChatNetworking failure in getOlderMessages, Status: " .. tostring(p5))
		end)
	end
end
