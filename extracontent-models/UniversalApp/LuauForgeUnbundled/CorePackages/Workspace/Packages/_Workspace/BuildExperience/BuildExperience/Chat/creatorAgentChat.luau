local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local fFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local fFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local askUserController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/askUserController")
local clientDataModelController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientDataModelController")
local clientLogsController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientLogsController")
local localToolOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local isWaitingOnUserInput = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/isWaitingOnUserInput")
local proposePlanController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/proposePlanController")

local v5 = if FFlagBuildExperienceManageDevProduct then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/askManageDevProductController") else nil

local v6 = fFlagBuildExperienceManageGamePass and FFlagBuildExperienceManageDevProduct

local v7 = if v6 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/askManageGamePassController") else nil

local v8 = fFlagBuildExperienceManageSubscription and FFlagBuildExperienceManageDevProduct
local v9 = v6 or v8

local v10 = if v8 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/askManageSubscriptionController") else nil

local unifiedMonetizationTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/unifiedMonetizationTool")
local createPromptLifecycleTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/createPromptLifecycleTelemetry")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildEventsUpdate1 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEventsUpdate1")
local fFlagBuildExperienceHistoryPollTelemetry = SharedFlags.FFlagBuildExperienceHistoryPollTelemetry

local studioAskUserTool = CreatorAgentChat.StudioAskUserTool
local studioClientDataModelTools = CreatorAgentChat.StudioClientDataModelTools
local studioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local studioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local studioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local studioManageGamePassTool = CreatorAgentChat.StudioManageGamePassTool
local studioManageSubscriptionTool = CreatorAgentChat.StudioManageSubscriptionTool
local Debug = CreatorAgentChat.debug
local turnStateReducer = CreatorAgentChat.TurnStateReducer

local errorCodes = CreatorAgentChat.ErrorCodes

local forbidden = errorCodes.Forbidden
local v11 = {
	FreeTrialExhausted = "FreeTrialExhausted",
	DailyLimitReached = "DailyLimitReached",
	InsufficientRobuxBalance = "InsufficientRobuxBalance"
}

local v12 = {
	[errorCodes.InvalidParams] = LocalizationStrings.CHAT_ERROR_INVALID_PARAMS,
	[errorCodes.Unauthorized] = LocalizationStrings.CHAT_ERROR_UNAUTHORIZED,
	[errorCodes.Forbidden] = LocalizationStrings.CHAT_ERROR_FORBIDDEN,
	[errorCodes.NotFound] = LocalizationStrings.CHAT_ERROR_NOT_FOUND,
	[errorCodes.Conflict] = LocalizationStrings.CHAT_ERROR_CONFLICT,
	[errorCodes.Gone] = LocalizationStrings.CHAT_ERROR_GONE,
	[errorCodes.UpstreamUnavailable] = LocalizationStrings.CHAT_ERROR_UPSTREAM_UNAVAILABLE,
	[errorCodes.InternalError] = LocalizationStrings.CHAT_ERROR_INTERNAL,
	[errorCodes.OutOfCredits] = LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS
}

local function getOutOfCreditsReason(p2)
	if p2 == nil then
		return nil
	end

	return v11[p2]
end

local function resolvePromptFailure(data, data2)
	if data == nil then
		if data2 == nil then
			return nil
		end

		local v13 = {
			errorCode = data2.errorCode,
			outOfCreditsReason = nil,
			isContentPolicy = false,
			setupStage = data2.stage,
			requestFailure = 0
		}
		local v14 = if fFlagBuildExperiencePromptFailureTelemetry then data2.requestFailure else nil
		v13.requestFailure = v14
		return v13
	else
		if data.status ~= "failed" then
			return nil
		end

		local v13 = {
			errorCode = data.errorCode,
			outOfCreditsReason = 0,
			isContentPolicy = 0,
			requestFailure = 0
		}
		local v14

		if data.errorCode == errorCodes.OutOfCredits then
			if FFlagBuildExperienceModelPicker then
				v14 = data.fundingReason
			end

			if not v14 then
				local err = data.error
				v14 = if err ~= nil then v11[err] else nil
			end
		end

		v13.outOfCreditsReason = v14

		v13.isContentPolicy = data.errorCode == forbidden
		local v15 = if fFlagBuildExperiencePromptFailureTelemetry then data.requestFailure else nil
		v13.requestFailure = v15
		return v13
	end
end

local function getPromptFailureTelemetryParameters(promptFailure)
	local promptFailureTelemetryParameters = {
		isContentPolicy = tostring(promptFailure.isContentPolicy)
	}

	if promptFailure.errorCode ~= nil then
		promptFailureTelemetryParameters.errorCode = tostring(promptFailure.errorCode)
	end

	if promptFailure.outOfCreditsReason ~= nil then
		promptFailureTelemetryParameters.outOfCreditsReason = promptFailure.outOfCreditsReason
	end

	if promptFailure.setupStage ~= nil then
		promptFailureTelemetryParameters.setupStage = promptFailure.setupStage
	end

	return promptFailureTelemetryParameters
end

local function getHistoryPollDropTelemetryParameters(data)
	local historyPollDropTelemetryParameters = {
		pollTrigger = data.pollTrigger,
		appliedFromThisPoll = tostring(data.appliedFromThisPoll)
	}

	if data.priorSequenceId ~= nil then
		historyPollDropTelemetryParameters.priorSequenceId = tostring(data.priorSequenceId)
	end

	return historyPollDropTelemetryParameters
end

local function addPromptFailureTelemetryParameters(p2, data)
	local requestFailure = data.requestFailure

	if requestFailure ~= nil then
		p2.failureKind = requestFailure.kind

		if requestFailure.httpStatusCode ~= nil then
			p2.httpStatusCode = tostring(requestFailure.httpStatusCode)
		end
	end

	local v13

	if data.isContentPolicy then
		v13 = LocalizationStrings.CHAT_POLICY_REJECTION
	elseif data.setupStage == "missing_project" then
		v13 = LocalizationStrings.CHAT_MISSING_PROJECT
	elseif data.errorCode == nil then
		v13 = LocalizationStrings.CHAT_DEFAULT_FAILURE
	else
		v13 = v12[data.errorCode]

		if v13 == nil then
			v13 = LocalizationStrings.CHAT_DEFAULT_FAILURE
		end
	end

	p2.errorCopyKey = v13
end

local function addLifecycleTelemetryParameters(p2, items)
	for k, item in items do
		p2[k] = item
	end
end

local function getAgentTurnFailureTelemetryParameters(data)
	local agentTurnFailureTelemetryParameters = { status = data.status }

	if data.stopReason ~= nil then
		agentTurnFailureTelemetryParameters.stopReason = data.stopReason
	end

	if data.errorCode ~= nil then
		agentTurnFailureTelemetryParameters.errorCode = tostring(data.errorCode)
	end

	return agentTurnFailureTelemetryParameters
end

local v13 = {
	agent_message = true,
	agent_message_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true
}

local v14 = { tool_call_update = true, tool_call_content_chunk = true }

local function trackPromptActivity(p2, p3, getOptimisticLocalTools)
	local emptyTurnState = turnStateReducer.createEmptyTurnState("", nil)
	local v15 = false
	local v16 = false
	local v17 = nil
	local v18 = nil

	local function reportActivity()
		p3.markActivity({ hasResponse = v15, isWaitingOnUser = v16 })
	end

	local function onUpdate(p4, p5)
		if v13[p4.sessionUpdate] == true then
			v15 = true
		end

		if v14[p4.sessionUpdate] == true then
			emptyTurnState = turnStateReducer.applySessionUpdate(emptyTurnState, p4, {
				sequenceNumber = p5
			})
			v16 = isWaitingOnUserInput(emptyTurnState, getOptimisticLocalTools(false).submittedToolCallIds)
		end

		p3.markActivity({ hasResponse = v15, isWaitingOnUser = v16 })
	end

	local effect = Signals.createEffect(function(p4)
		local turnHandle = p2.getTurnHandle(p4)
		local submittedToolCallIds = getOptimisticLocalTools(p4).submittedToolCallIds

		if turnHandle ~= nil and turnHandle ~= v17 and turnHandle.onUpdate ~= nil then
			v17 = turnHandle
			v18 = turnHandle.onUpdate(onUpdate)
		end

		local v19 = isWaitingOnUserInput(emptyTurnState, submittedToolCallIds)

		if v19 ~= v16 then
			v16 = v19
			p3.markActivity({ hasResponse = v15, isWaitingOnUser = v16 })
		end
	end)

	return function()
		effect()

		if v18 ~= nil then
			v18()
			v18 = nil
		end
	end
end

local function isAgentTurnFailure(p2): boolean
	return p2.status == "failed" or p2.stopReason == "error"
end

local function formatSetupErrorMessage(p2)
	local v15 = {
		errorCode = p2.errorCode,
		isContentPolicy = false,
		setupStage = p2.stage
	}

	if v15.isContentPolicy then
		return LocalizationStrings.CHAT_POLICY_REJECTION
	end

	if v15.setupStage == "missing_project" then
		return LocalizationStrings.CHAT_MISSING_PROJECT
	end

	if v15.errorCode ~= nil then
		local v16 = v12[v15.errorCode]

		if v16 ~= nil then
			return v16
		end
	end

	return LocalizationStrings.CHAT_DEFAULT_FAILURE
end

local function createLocalToolControllers(data, p2, p3)
	local v15 = {}
	local v16 = localToolOverlay()
	local v17 = askUserController(data, v15, v16, p2)

	local v18 = proposePlanController(data, v15, v16, p2)

	local v19 = clientLogsController(data, v15, p3)

	local v20 = clientDataModelController(data, v15, p3)

	local v21 = if v5 ~= nil then v5(data, v15, v16, p2, unifiedMonetizationTool.toolsByKind.developerProduct) else nil

	local v22 = {}

	if v6 then
		table.insert(v22, v7(data, v15, v16, p2))
	end

	if v8 then
		table.insert(v22, v10(data, v15, v16, p2))
	end

	return {
		getOptimisticLocalTools = v16.getOptimisticLocalTools,
		getLocalToolActions = v16.getLocalToolActions,
		hasDisplayedAnswerStack = v17.hasDisplayedAnswerStack,
		syncFromTurnState = function(p4)
			v17.syncAnswerStack(p4)
			v18.syncPlanProposal(p4)
			v19.syncClientLogsRequest(p4)
			v20.syncClientDataModelRequests(p4)

			if v21 ~= nil then
				v21.syncManageDevProductRequests(p4)
			end

			if v9 then
				for k, v23 in v22 do
					v23.syncRequests(p4)
				end
			end
		end,
		trySubmitComposerText = function(p4)
			if v9 then
				if
					v17.trySubmitComposerText(p4)
					or v18.trySubmitComposerText(p4)
					or v21 ~= nil and v21.trySubmitComposerText(p4)
				then
					return true
				end

				for k, v23 in v22 do
					if v23.trySubmitComposerText(p4) then
						return true
					end
				end

				return false
			else
				local v23 = v17.trySubmitComposerText(p4) or v18.trySubmitComposerText(p4)

				if not v23 then
					v23 = not (v21 == nil) and v21.trySubmitComposerText(p4)
				end

				return v23
			end
		end,
		trySubmitAnswerText = v17.trySubmitAnswerText,
		stopPending = function()
			v17.stopPendingAnswer()
			v18.stopPendingPlan()
			v20.revokePending()

			if v21 ~= nil then
				v21.stopPending()
			end

			if v9 then
				for k, v23 in v22 do
					v23.stopPending()
				end
			end
		end
	}
end

return {
	createLiveAssistantTurn = function(data, p2, callback, p3, p4, callback2, callback3, sendConfiguration, expectedSessionId, isCancelled)
		local localToolControllers = createLocalToolControllers(data, p3, p4)
		local universeId = data.universeId

		local v15 = {
			studioAskUserTool.LOCAL_TOOL_DEFINITION,
			studioProposePlanTool.LOCAL_TOOL_DEFINITION,
			studioClientLogsTool.LOCAL_TOOL_DEFINITION
		}

		table.insert(v15, studioClientDataModelTools.SEARCH_LOCAL_TOOL_DEFINITION)
		table.insert(v15, studioClientDataModelTools.INSPECT_LOCAL_TOOL_DEFINITION)

		if unifiedMonetizationTool.localToolDefinition == nil then
			if FFlagBuildExperienceManageDevProduct then
				table.insert(v15, studioManageDevProductTool.LOCAL_TOOL_DEFINITION)
			end

			if v6 then
				table.insert(v15, studioManageGamePassTool.LOCAL_TOOL_DEFINITION)
			end

			if v8 then
				table.insert(v15, studioManageSubscriptionTool.LOCAL_TOOL_DEFINITION)
			end
		else
			table.insert(v15, unifiedMonetizationTool.localToolDefinition)
		end

		local v17

		if fFlagBuildExperiencePromptFailureTelemetry then
			v17 = createPromptLifecycleTelemetry(function()
				return {
					universeId = universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId()
				}
			end)
		else
			v17 = nil
		end

		local function onDroppedChatMessage(p5, data2)
			local v18 = {
				universeId = universeId,
				placeId = data.placeId,
				conversationId = data.getCasSessionId(),
				messageId = p5
			}
			local v21

			if fFlagBuildExperienceHistoryPollTelemetry and data2 ~= nil then
				v21 = {
					pollTrigger = data2.pollTrigger,
					appliedFromThisPoll = tostring(data2.appliedFromThisPoll)
				}

				if data2.priorSequenceId ~= nil then
					v21.priorSequenceId = tostring(data2.priorSequenceId)
				end
			end

			sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", v18, v21)
		end

		local v18 = false
		local function handleReceived(p5)
			if FFlagBuildEventsUpdate1 and not v18 then
				sendBuildExperienceEvent("SEND_PROMPT_RECIEVED", {
					universeId = universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId(),
					turnId = p5
				})
			end

			if callback2 ~= nil then
				callback2(p5)
			end
		end

		local fn = fFlagBuildExperienceLibrary and callback3 ~= nil and function()
			if FFlagBuildEventsUpdate1 then
				v18 = true
				sendBuildExperienceEvent("SEND_PROMPT_RECIEVED", {
					universeId = universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId()
				})
			end

			callback3()
		end or nil

		local v19 = nil
		local v20 = nil

		local function finishPromptTelemetry(p5)
			if v20 ~= nil then
				v20()
				v20 = nil
			end

			p5.finish()
		end

		local function completeTurn(data2)
			local promptFailure = resolvePromptFailure(data2, v19.getSetupError(false))

			if promptFailure == nil then
				if
					fFlagBuildExperiencePromptFailureTelemetry
					and v17 ~= nil
					and data2 ~= nil
					and (data2.status == "failed" or data2.stopReason == "error")
				then
					local lifecycleParameters = { status = data2.status }

					if data2.stopReason ~= nil then
						lifecycleParameters.stopReason = data2.stopReason
					end

					if data2.errorCode ~= nil then
						lifecycleParameters.errorCode = tostring(data2.errorCode)
					end

					local lifecycleParameters2 = v17.getLifecycleParameters()

					for k, lifecycleParameter in lifecycleParameters2 do
						lifecycleParameters[k] = lifecycleParameter
					end

					sendBuildExperienceEvent(
						"AGENT_TURN_FAILED",
						{
							universeId = universeId,
							placeId = data.placeId,
							conversationId = data.getCasSessionId()
						},
						lifecycleParameters
					)
				end
			else
				Debug.log("info", "prompt send failed", {
					errorCode = promptFailure.errorCode,
					isContentPolicy = promptFailure.isContentPolicy,
					setupStage = promptFailure.setupStage,
					universeId = universeId,
					placeId = data.placeId
				})

				local promptFailureTelemetryParameters = getPromptFailureTelemetryParameters(promptFailure)

				if fFlagBuildExperiencePromptFailureTelemetry and v17 ~= nil then
					local requestFailure = promptFailure.requestFailure

					if requestFailure ~= nil then
						promptFailureTelemetryParameters.failureKind = requestFailure.kind

						if requestFailure.httpStatusCode ~= nil then
							promptFailureTelemetryParameters.httpStatusCode = tostring(requestFailure.httpStatusCode)
						end
					end

					local v21

					if promptFailure.isContentPolicy then
						v21 = LocalizationStrings.CHAT_POLICY_REJECTION
					elseif promptFailure.setupStage == "missing_project" then
						v21 = LocalizationStrings.CHAT_MISSING_PROJECT
					elseif promptFailure.errorCode == nil then
						v21 = LocalizationStrings.CHAT_DEFAULT_FAILURE
					else
						v21 = v12[promptFailure.errorCode]

						if v21 == nil then
							v21 = LocalizationStrings.CHAT_DEFAULT_FAILURE
						end
					end

					promptFailureTelemetryParameters.errorCopyKey = v21

					local lifecycleParameters = v17.getLifecycleParameters()

					for k, lifecycleParameter in lifecycleParameters do
						promptFailureTelemetryParameters[k] = lifecycleParameter
					end
				end

				sendBuildExperienceEvent(
					"SEND_PROMPT_FAILED",
					{
						universeId = universeId,
						placeId = data.placeId,
						conversationId = data.getCasSessionId()
					},
					promptFailureTelemetryParameters
				)
			end

			if fFlagBuildExperiencePromptFailureTelemetry and v17 ~= nil then
				if v20 ~= nil then
					v20()
					v20 = nil
				end

				v17.finish()
			end

			callback(promptFailure)
		end

		if not FFlagBuildEventsUpdate1 and callback2 == nil then
			handleReceived = nil
		end

		local v21 = {
			prompt = p2,
			promptMeta = {
				_roblox = {
					application = "build-on-mobile",
					localTools = v15,
					providerConfig = { universeId = universeId }
				}
			},
			onDroppedChatMessage = onDroppedChatMessage,
			onReceived = handleReceived,
			onAccepted = fn,
			onCompleted = completeTurn
		}

		if FFlagBuildExperienceModelPicker then
			v21.sendConfiguration = sendConfiguration
			v21.expectedSessionId = expectedSessionId
			v21.isCancelled = isCancelled
		end

		v19 = data.sendPrompt(v21)

		local function getSetupErrorText(p5)
			local setupError = v19.getSetupError(p5)

			if setupError == nil then
				return nil
			end

			local v22 = {
				errorCode = setupError.errorCode,
				isContentPolicy = false,
				setupStage = setupError.stage
			}

			if v22.isContentPolicy then
				return LocalizationStrings.CHAT_POLICY_REJECTION
			end

			if v22.setupStage == "missing_project" then
				return LocalizationStrings.CHAT_MISSING_PROJECT
			end

			if v22.errorCode ~= nil then
				local v23 = v12[v22.errorCode]

				if v23 ~= nil then
					return v23
				end
			end

			return LocalizationStrings.CHAT_DEFAULT_FAILURE
		end

		local function start()
			if fFlagBuildExperiencePromptFailureTelemetry and v17 ~= nil then
				v17.start()

				if v20 == nil then
					v20 = trackPromptActivity(v19, v17, localToolControllers.getOptimisticLocalTools)
				end
			end

			v19.start()
		end

		local function stop()
			localToolControllers.stopPending()
			v19.stop()
		end

		local liveAssistantTurn = {
			getOptimisticLocalTools = localToolControllers.getOptimisticLocalTools,
			getLocalToolActions = localToolControllers.getLocalToolActions,
			getSetupErrorText = getSetupErrorText,
			start = start,
			stop = stop,
			reportUserStop = 0,
			detach = 0,
			syncFromTurnState = 0,
			trySubmitComposerText = 0,
			trySubmitAnswerText = 0
		}

		local v22 = if fFlagBuildExperiencePromptFailureTelemetry and v17 ~= nil then v17.reportUserStop else nil
		liveAssistantTurn.reportUserStop = v22
		local v23

		if fFlagBuildExperiencePromptFailureTelemetry and v17 ~= nil then
			v23 = function()
				localToolControllers.stopPending()

				if v20 ~= nil then
					v20()
					v20 = nil
				end

				v17.finish()
			end
		else
			v23 = localToolControllers.stopPending
		end

		liveAssistantTurn.detach = v23

		liveAssistantTurn.syncFromTurnState = localToolControllers.syncFromTurnState
		liveAssistantTurn.trySubmitComposerText = localToolControllers.trySubmitComposerText
		liveAssistantTurn.trySubmitAnswerText = localToolControllers.trySubmitAnswerText
		return liveAssistantTurn
	end,
	createResumedAssistantTurn = function(data, p2, p3, afterSequenceId, p4, p5)
		local localToolControllers = createLocalToolControllers(data, p4, p5)

		local signal = Signals.createSignal(nil)

		local flag = false
		local flag2 = false
		local v15 = nil
		local v16 = nil

		local function cleanupObservers()
			if v16 ~= nil then
				v16()
				v16 = nil
			end

			if v15 ~= nil then
				v15()
				v15 = nil
			end
		end

		local function finish()
			if flag2 then
				return
			end

			flag2 = true

			if v16 ~= nil then
				v16()
				v16 = nil
			end

			if v15 ~= nil then
				v15()
				v15 = nil
			end

			if fFlagBuildExperiencePromptFailureTelemetry then
				local state = p2.state(false)

				if (state.status == "failed" or state.stopReason == "error") and state.requestId == nil then
					local v17 = { status = state.status }

					if state.stopReason ~= nil then
						v17.stopReason = state.stopReason
					end

					if state.errorCode ~= nil then
						v17.errorCode = tostring(state.errorCode)
					end

					v17.isResumedTurn = "true"

					sendBuildExperienceEvent(
						"AGENT_TURN_FAILED",
						{
							universeId = data.universeId,
							placeId = data.placeId,
							conversationId = data.getCasSessionId()
						},
						v17
					)
				end
			end

			local v18

			if FFlagBuildExperienceModelPicker then
				local state = p2.state(false)

				if not (state == nil or state.status ~= "failed") then
					v18 = {
						errorCode = state.errorCode,
						outOfCreditsReason = 0,
						isContentPolicy = 0,
						requestFailure = 0
					}
					local v19

					if state.errorCode == errorCodes.OutOfCredits then
						if FFlagBuildExperienceModelPicker then
							v19 = state.fundingReason
						end

						if not v19 then
							local err = state.error
							v19 = if err ~= nil then v11[err] else nil
						end
					end

					v18.outOfCreditsReason = v19

					v18.isContentPolicy = state.errorCode == forbidden
					local v20 = if fFlagBuildExperiencePromptFailureTelemetry then state.requestFailure else nil
					v18.requestFailure = v20
				end
			end

			p3(v18)
		end

		local v17 = false

		local fn = fFlagBuildExperiencePromptFailureTelemetry and function()
			if flag2 or v17 then
				return
			end

			v17 = true

			sendBuildExperienceEvent(
				"SEND_PROMPT_STOPPED",
				{
					universeId = data.universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId()
				},
				{ isResumedTurn = "true" }
			)
		end or nil

		local function start()
			if flag then
				return
			end

			flag = true
			local v18 = {
				onDroppedChatMessage = function(p6, data2)
					local v19 = {
						universeId = data.universeId,
						placeId = data.placeId,
						conversationId = data.getCasSessionId(),
						messageId = p6
					}
					local v22

					if fFlagBuildExperienceHistoryPollTelemetry and data2 ~= nil then
						v22 = {
							pollTrigger = data2.pollTrigger,
							appliedFromThisPoll = tostring(data2.appliedFromThisPoll)
						}

						if data2.priorSequenceId ~= nil then
							v22.priorSequenceId = tostring(data2.priorSequenceId)
						end
					end

					sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", v19, v22)
				end
			}

			if afterSequenceId ~= nil then
				v18.afterSequenceId = afterSequenceId
			end

			v15 = data.startPollingActiveTurn(v18)

			v16 = Signals.createEffect(function(p6)
				if p2.state(p6).isDone then
					finish()
				end
			end)
		end

		return {
			getOptimisticLocalTools = localToolControllers.getOptimisticLocalTools,
			getLocalToolActions = localToolControllers.getLocalToolActions,
			getSetupErrorText = function(p6)
				return signal(p6)
			end,
			start = start,
			stop = function()
				if not FFlagBuildExperienceModelPicker then
					flag2 = true

					if v16 ~= nil then
						v16()
						v16 = nil
					end

					if v15 ~= nil then
						v15()
						v15 = nil
					end
				end

				localToolControllers.stopPending()
				p2.cancel()
			end,
			reportUserStop = fn,
			detach = function()
				flag2 = true

				if v16 ~= nil then
					v16()
					v16 = nil
				end

				if v15 ~= nil then
					v15()
					v15 = nil
				end

				localToolControllers.stopPending()
			end,
			syncFromTurnState = localToolControllers.syncFromTurnState,
			trySubmitComposerText = localToolControllers.trySubmitComposerText,
			trySubmitAnswerText = localToolControllers.trySubmitAnswerText
		}
	end,
	getPromptFailureComposerError = function(data)
		if data.isContentPolicy then
			return LocalizationStrings.CHAT_POLICY_REJECTION
		end

		if data.setupStage == "missing_project" then
			return LocalizationStrings.CHAT_MISSING_PROJECT
		end

		if data.errorCode ~= nil then
			local v15 = v12[data.errorCode]

			if v15 ~= nil then
				return v15
			end
		end

		return LocalizationStrings.CHAT_DEFAULT_FAILURE
	end,
	getToolResultFailureComposerError = function(p2)
		local v15 = {
			errorCode = p2,
			outOfCreditsReason = nil,
			isContentPolicy = p2 == forbidden,
			setupStage = nil
		}

		if v15.isContentPolicy then
			return LocalizationStrings.CHAT_POLICY_REJECTION
		end

		if v15.setupStage == "missing_project" then
			return LocalizationStrings.CHAT_MISSING_PROJECT
		end

		if v15.errorCode ~= nil then
			local v16 = v12[v15.errorCode]

			if v16 ~= nil then
				return v16
			end
		end

		return LocalizationStrings.CHAT_DEFAULT_FAILURE
	end
}
