local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local FFlagDisableLegacyReportToDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags/FFlagDisableLegacyReportToDiag")
local fFlagAppChatEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableReactions

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local reportToDiagByCountryCode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/reportToDiagByCountryCode")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("getNewMessages")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local GetMessageReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore")

return function(p2, p3, p4)
	v5:info("Getting new messages for {}", p2)
	return function(object)
		local v6 = {}

		if not object:getState().ChatAppReducer.Conversations[p2] then
			table.insert(v6, object:dispatch(AppChatNetworking.rodux.GetConversationDetails.API(p2)):catch(function(p5)
				v5:error(`AppChatNetworking failure in GetConversationDetails: {tostring(p5)}`)
			end))
		end

		local v7 = FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and not p3

		if v7 then
			local v8 = { conversationId = p2 }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				v8
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Subphase.NetworkFetch,
				v8
			)

			AppChatPerfTracker.trackRequest(
				AppChatPerfTracker.Events.MessageReceiveTTI,
				AppChatPerfTracker.Milestone.PrimaryDataStarted.Name,
				"GetNewerMessages",
				v8
			)
		end

		table.insert(v6, object:dispatch(AppChatNetworking.rodux.GetNewerMessages.API(p2)):andThen(function(p5)
			if not FFlagDisableLegacyReportToDiag then
				local v9 = tick() - p4
				reportToDiagByCountryCode(Constants.PerformanceMeasurement.LUA_CHAT_RECEIVE_MESSAGE, "MessageReceivedTime", v9)
			end

			if v7 then
				local v8 = { conversationId = p2 }
				AppChatPerfTracker.trackMilestone(
					AppChatPerfTracker.Events.MessageReceiveTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					v8
				)

				AppChatPerfTracker.trackSubphase(
					AppChatPerfTracker.Events.MessageReceiveTTI,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Name,
					AppChatPerfTracker.Milestone.PrimaryDataReady.Subphase.ResponseReceived,
					v8
				)
			end

			if fFlagAppChatEnableReactions and p5.responseBody then
				GetMessageReactionsStore(false).ingestMessageReactions(p5.responseBody.messages)
			end
		end):catch(function(p5)
			v5:error(`AppChatNetworking failure in GetNewerMessages: {tostring(p5)}`)
		end))

		return Promise.allSettled(v6)
	end
end
