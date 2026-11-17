local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildExperienceManageGamePass = SharedFlags.FFlagBuildExperienceManageGamePass
local FFlagBuildExperienceManageSubscription = SharedFlags.FFlagBuildExperienceManageSubscription

require(script.Parent.chatTypes)
local askUserController = require(script.Parent.askUserController)
local clientDataModelController = require(script.Parent.clientDataModelController)
local clientLogsController = require(script.Parent.clientLogsController)
local localToolOverlay = require(script.Parent.localToolOverlay)
local isWaitingOnUserInput = require(script.Parent.isWaitingOnUserInput)
local proposePlanController = require(script.Parent.proposePlanController)
local askManageDevProductController

if FFlagBuildExperienceManageDevProduct then
	askManageDevProductController = require(script.Parent.askManageDevProductController)
else
	askManageDevProductController = nil
end

local v = FFlagBuildExperienceManageGamePass and FFlagBuildExperienceManageDevProduct
local askManageGamePassController

if v then
	askManageGamePassController = require(script.Parent.askManageGamePassController)
else
	askManageGamePassController = nil
end

local v2 = FFlagBuildExperienceManageSubscription and FFlagBuildExperienceManageDevProduct
local v3 = v or v2
local askManageSubscriptionController

if v2 then
	askManageSubscriptionController = require(script.Parent.askManageSubscriptionController)
else
	askManageSubscriptionController = nil
end

local unifiedMonetizationTool = require(script.Parent.unifiedMonetizationTool)
local createPromptLifecycleTelemetry = require(BuildExperience.Telemetry.createPromptLifecycleTelemetry)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildEventsUpdate1 = require(BuildExperience.Flags.FFlagBuildEventsUpdate1)
local FFlagBuildExperienceHistoryPollTelemetry = SharedFlags.FFlagBuildExperienceHistoryPollTelemetry
local FFlagBuildExperienceChatOpenId = require(BuildExperience.Flags.FFlagBuildExperienceChatOpenId)

local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioClientDataModelTools = CreatorAgentChat.StudioClientDataModelTools
local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local StudioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local StudioManageGamePassTool = CreatorAgentChat.StudioManageGamePassTool
local StudioManageSubscriptionTool = CreatorAgentChat.StudioManageSubscriptionTool
local Debug = CreatorAgentChat.debug
local TurnStateReducer = CreatorAgentChat.TurnStateReducer

local ErrorCodes = CreatorAgentChat.ErrorCodes

local Forbidden = ErrorCodes.Forbidden
local v4 = {
	FreeTrialExhausted = "FreeTrialExhausted",
	DailyLimitReached = "DailyLimitReached",
	InsufficientRobuxBalance = "InsufficientRobuxBalance"
}

local v5 = {
	[ErrorCodes.InvalidParams] = LocalizationStrings.CHAT_ERROR_INVALID_PARAMS,
	[ErrorCodes.Unauthorized] = LocalizationStrings.CHAT_ERROR_UNAUTHORIZED,
	[ErrorCodes.Forbidden] = LocalizationStrings.CHAT_ERROR_FORBIDDEN,
	[ErrorCodes.NotFound] = LocalizationStrings.CHAT_ERROR_NOT_FOUND,
	[ErrorCodes.Conflict] = LocalizationStrings.CHAT_ERROR_CONFLICT,
	[ErrorCodes.Gone] = LocalizationStrings.CHAT_ERROR_GONE,
	[ErrorCodes.UpstreamUnavailable] = LocalizationStrings.CHAT_ERROR_UPSTREAM_UNAVAILABLE,
	[ErrorCodes.InternalError] = LocalizationStrings.CHAT_ERROR_INTERNAL,
	[ErrorCodes.OutOfCredits] = LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS
}

local function getPromptFailureComposerError(data) -- 3 equivalent calls inferred from this helper
	if data.isContentPolicy then
		return LocalizationStrings.CHAT_POLICY_REJECTION
	end

	if data.setupStage == "missing_project" then
		return LocalizationStrings.CHAT_MISSING_PROJECT
	end

	if data.errorCode ~= nil then
		local v6 = v5[data.errorCode]

		if v6 ~= nil then
			return v6
		end
	end

	return LocalizationStrings.CHAT_DEFAULT_FAILURE
end

local function getOutOfCreditsReason(err: string?) -- 2 equivalent calls inferred from this helper
	if err == nil then
		return nil
	end

	return v4[err]
end

local function resolvePromptFailure(data, data2)
	if data == nil then
		if data2 == nil then
			return nil
		end

		local v6 = {
			errorCode = data2.errorCode,
			outOfCreditsReason = nil,
			isContentPolicy = false,
			setupStage = data2.stage,
			requestFailure = 0
		}
		local requestFailure

		if FFlagBuildExperiencePromptFailureTelemetry then
			requestFailure = data2.requestFailure
		end

		v6.requestFailure = requestFailure
		return v6
	else
		if data.status ~= "failed" then
			return nil
		end

		local v6 = {
			errorCode = data.errorCode,
			outOfCreditsReason = 0,
			isContentPolicy = 0,
			requestFailure = 0
		}
		local outOfCreditsReason

		if data.errorCode == ErrorCodes.OutOfCredits then
			if FFlagBuildExperienceModelPicker then
				outOfCreditsReason = data.fundingReason
			end

			if not outOfCreditsReason then
				outOfCreditsReason = getOutOfCreditsReason(data.error) -- inferred equivalent call
			end
		end

		v6.outOfCreditsReason = outOfCreditsReason

		v6.isContentPolicy = data.errorCode == Forbidden
		local requestFailure

		if FFlagBuildExperiencePromptFailureTelemetry then
			requestFailure = data.requestFailure
		end

		v6.requestFailure = requestFailure
		return v6
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

local function addPromptFailureTelemetryParameters(promptFailureTelemetryParameters, promptFailure) -- 1 equivalent call inferred from this helper
	local requestFailure = promptFailure.requestFailure

	if requestFailure ~= nil then
		promptFailureTelemetryParameters.failureKind = requestFailure.kind

		if requestFailure.httpStatusCode ~= nil then
			promptFailureTelemetryParameters.httpStatusCode = tostring(requestFailure.httpStatusCode)
		end
	end

	promptFailureTelemetryParameters.errorCopyKey = getPromptFailureComposerError(promptFailure) -- inferred equivalent call
end

local function addLifecycleTelemetryParameters(p, items) -- 2 equivalent calls inferred from this helper
	for k, item in items do
		p[k] = item
	end
end

local function getAgentTurnFailureTelemetryParameters(data) -- 2 equivalent calls inferred from this helper
	local agentTurnFailureTelemetryParameters = { status = data.status }

	if data.stopReason ~= nil then
		agentTurnFailureTelemetryParameters.stopReason = data.stopReason
	end

	if data.errorCode ~= nil then
		agentTurnFailureTelemetryParameters.errorCode = tostring(data.errorCode)
	end

	return agentTurnFailureTelemetryParameters
end

local v6 = {
	agent_message = true,
	agent_message_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true
}

local v7 = { tool_call_update = true, tool_call_content_chunk = true }

local function trackPromptActivity(p, p2, getOptimisticLocalTools)
	local emptyTurnState = TurnStateReducer.createEmptyTurnState("", nil)
	local hasResponse = false
	local isWaitingOnUser = false
	local v8 = nil
	local v9 = nil

	local function reportActivity() -- 2 equivalent calls inferred from this helper
		p2.markActivity({ hasResponse = hasResponse, isWaitingOnUser = isWaitingOnUser })
	end

	local function onUpdate(p3, sequenceNumber: number?)
		if v6[p3.sessionUpdate] == true then
			hasResponse = true
		end

		if v7[p3.sessionUpdate] == true then
			emptyTurnState = TurnStateReducer.applySessionUpdate(emptyTurnState, p3, {
				sequenceNumber = sequenceNumber
			})
			isWaitingOnUser = isWaitingOnUserInput(emptyTurnState, getOptimisticLocalTools(false).submittedToolCallIds)
		end

		reportActivity() -- inferred equivalent call
	end

	local effect = Signals.createEffect(function(p3)
		local turnHandle = p.getTurnHandle(p3)
		local submittedToolCallIds = getOptimisticLocalTools(p3).submittedToolCallIds

		if turnHandle ~= nil and turnHandle ~= v8 and turnHandle.onUpdate ~= nil then
			v8 = turnHandle
			v9 = turnHandle.onUpdate(onUpdate)
		end

		local waitingOnUserInput = isWaitingOnUserInput(emptyTurnState, submittedToolCallIds)

		if waitingOnUserInput ~= isWaitingOnUser then
			isWaitingOnUser = waitingOnUserInput
			reportActivity() -- inferred equivalent call
		end
	end)

	return function()
		effect()

		if v9 ~= nil then
			v9()
			v9 = nil
		end
	end
end

local function isAgentTurnFailure(state): boolean -- 1 equivalent call inferred from this helper
	return state.status == "failed" or state.stopReason == "error"
end

local function formatSetupErrorMessage(setupError) -- 1 equivalent call inferred from this helper
	return getPromptFailureComposerError({ -- inferred equivalent call
		errorCode = setupError.errorCode,
		isContentPolicy = false,
		setupStage = setupError.stage
	})
end

local function createLocalToolControllers(data, p, callback)
	local v8 = {}
	local v9 = localToolOverlay()
	local v10 = askUserController(data, v8, v9, p)

	local v11 = proposePlanController(data, v8, v9, p)

	local v12 = clientLogsController(data, v8, callback)

	local v13 = clientDataModelController(data, v8, callback)
	local v14

	if askManageDevProductController == nil then
		v14 = nil
	else
		v14 = askManageDevProductController(data, v8, v9, p, unifiedMonetizationTool.toolsByKind.developerProduct)
	end

	local v15 = {}

	if v then
		table.insert(v15, askManageGamePassController(data, v8, v9, p))
	end

	if v2 then
		table.insert(v15, askManageSubscriptionController(data, v8, v9, p))
	end

	return {
		getOptimisticLocalTools = v9.getOptimisticLocalTools,
		getLocalToolActions = v9.getLocalToolActions,
		hasDisplayedAnswerStack = v10.hasDisplayedAnswerStack,
		syncFromTurnState = function(p2)
			v10.syncAnswerStack(p2)
			v11.syncPlanProposal(p2)
			v12.syncClientLogsRequest(p2)
			v13.syncClientDataModelRequests(p2)

			if v14 ~= nil then
				v14.syncManageDevProductRequests(p2)
			end

			if v3 then
				for _, v16 in v15 do
					v16.syncRequests(p2)
				end
			end
		end,
		trySubmitComposerText = function(p2: string)
			if v3 then
				if
					v10.trySubmitComposerText(p2)
					or v11.trySubmitComposerText(p2)
					or v14 ~= nil and v14.trySubmitComposerText(p2)
				then
					return true
				end

				for _, v16 in v15 do
					if v16.trySubmitComposerText(p2) then
						return true
					end
				end

				return false
			else
				local v16 = v10.trySubmitComposerText(p2) or v11.trySubmitComposerText(p2)

				if not v16 then
					if v14 == nil then
						return false
					end

					return (v14.trySubmitComposerText(p2))
				end

				return v16
			end
		end,
		trySubmitAnswerText = v10.trySubmitAnswerText,
		stopPending = function()
			v10.stopPendingAnswer()
			v11.stopPendingPlan()
			v13.revokePending()

			if v14 ~= nil then
				v14.stopPending()
			end

			if v3 then
				for _, v16 in v15 do
					v16.stopPending()
				end
			end
		end
	}
end

local CreatorAgentChat_2 = {}

function CreatorAgentChat_2.createLiveAssistantTurn(data, prompt, callback, p, callback2, callback3, callback4, sendConfiguration, expectedSessionId: string?, isCancelled)
	local localToolControllers = createLocalToolControllers(data, p, callback2)
	local universeId = data.universeId
	local chatOpenId

	if FFlagBuildExperienceChatOpenId then
		chatOpenId = CreatorAgentChat.chatOpenTelemetry.getChatOpenIdForUniverse(universeId)
	else
		chatOpenId = nil
	end

	local localTools = {
		StudioAskUserTool.LOCAL_TOOL_DEFINITION,
		StudioProposePlanTool.LOCAL_TOOL_DEFINITION,
		StudioClientLogsTool.LOCAL_TOOL_DEFINITION
	}

	table.insert(localTools, StudioClientDataModelTools.SEARCH_LOCAL_TOOL_DEFINITION)
	table.insert(localTools, StudioClientDataModelTools.INSPECT_LOCAL_TOOL_DEFINITION)

	if unifiedMonetizationTool.localToolDefinition == nil then
		if FFlagBuildExperienceManageDevProduct then
			table.insert(localTools, StudioManageDevProductTool.LOCAL_TOOL_DEFINITION)
		end

		if v then
			table.insert(localTools, StudioManageGamePassTool.LOCAL_TOOL_DEFINITION)
		end

		if v2 then
			table.insert(localTools, StudioManageSubscriptionTool.LOCAL_TOOL_DEFINITION)
		end
	else
		table.insert(localTools, unifiedMonetizationTool.localToolDefinition)
	end

	local v8

	if FFlagBuildExperiencePromptFailureTelemetry then
		v8 = createPromptLifecycleTelemetry(function()
			return {
				universeId = universeId,
				placeId = data.placeId,
				conversationId = data.getCasSessionId(),
				chatOpenId = chatOpenId
			}
		end)
	else
		v8 = nil
	end

	local function onDroppedChatMessage(messageId: number, data2)
		local v9 = {
			universeId = universeId,
			placeId = data.placeId,
			conversationId = data.getCasSessionId(),
			chatOpenId = chatOpenId,
			messageId = messageId
		}
		local v10

		if FFlagBuildExperienceHistoryPollTelemetry and data2 ~= nil then
			v10 = {
				pollTrigger = data2.pollTrigger,
				appliedFromThisPoll = tostring(data2.appliedFromThisPoll)
			}

			if data2.priorSequenceId ~= nil then
				v10.priorSequenceId = tostring(data2.priorSequenceId)
			end
		end

		sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", v9, v10)
	end

	local v9 = false
	local function handleReceived(turnId: number?)
		if FFlagBuildEventsUpdate1 and not v9 then
			sendBuildExperienceEvent("SEND_PROMPT_RECIEVED", {
				universeId = universeId,
				placeId = data.placeId,
				conversationId = data.getCasSessionId(),
				chatOpenId = chatOpenId,
				turnId = turnId
			})
		end

		if callback3 ~= nil then
			callback3(turnId)
		end
	end

	local fn = FFlagBuildExperienceLibrary and callback4 ~= nil and function()
		if FFlagBuildEventsUpdate1 then
			v9 = true
			sendBuildExperienceEvent("SEND_PROMPT_RECIEVED", {
				universeId = universeId,
				placeId = data.placeId,
				conversationId = data.getCasSessionId(),
				chatOpenId = chatOpenId
			})
		end

		callback4()
	end or nil

	local v10 = nil
	local v11 = nil

	local function finishPromptTelemetry(p2) -- 2 equivalent calls inferred from this helper
		if v11 ~= nil then
			v11()
			v11 = nil
		end

		p2.finish()
	end

	local function completeTurn(data2)
		local promptFailure = resolvePromptFailure(data2, v10.getSetupError(false))

		if promptFailure == nil then
			if
				FFlagBuildExperiencePromptFailureTelemetry
				and v8 ~= nil
				and data2 ~= nil
				and (data2.status == "failed" or data2.stopReason == "error")
			then
				local agentTurnFailureTelemetryParameters = getAgentTurnFailureTelemetryParameters(data2) -- inferred equivalent call
				addLifecycleTelemetryParameters(agentTurnFailureTelemetryParameters, v8.getLifecycleParameters()) -- inferred equivalent call

				sendBuildExperienceEvent(
					"AGENT_TURN_FAILED",
					{
						universeId = universeId,
						placeId = data.placeId,
						conversationId = data.getCasSessionId(),
						chatOpenId = chatOpenId
					},
					agentTurnFailureTelemetryParameters
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

			if FFlagBuildExperiencePromptFailureTelemetry and v8 ~= nil then
				addPromptFailureTelemetryParameters(promptFailureTelemetryParameters, promptFailure) -- inferred equivalent call
				addLifecycleTelemetryParameters(promptFailureTelemetryParameters, v8.getLifecycleParameters()) -- inferred equivalent call
			end

			sendBuildExperienceEvent(
				"SEND_PROMPT_FAILED",
				{
					universeId = universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId(),
					chatOpenId = chatOpenId
				},
				promptFailureTelemetryParameters
			)
		end

		if FFlagBuildExperiencePromptFailureTelemetry and v8 ~= nil then
			finishPromptTelemetry(v8) -- inferred equivalent call
		end

		callback(promptFailure)
	end

	if not FFlagBuildEventsUpdate1 and callback3 == nil then
		handleReceived = nil
	end

	local v12 = {
		prompt = prompt,
		promptMeta = {
			_roblox = {
				application = "build-on-mobile",
				localTools = localTools,
				providerConfig = { universeId = universeId }
			}
		},
		onDroppedChatMessage = onDroppedChatMessage,
		onReceived = handleReceived,
		onAccepted = fn,
		onCompleted = completeTurn
	}

	if FFlagBuildExperienceModelPicker then
		v12.sendConfiguration = sendConfiguration
		v12.expectedSessionId = expectedSessionId
		v12.isCancelled = isCancelled
	end

	v10 = data.sendPrompt(v12)

	local function getSetupErrorText(p2)
		local setupError = v10.getSetupError(p2)

		if setupError == nil then
			return nil
		end

		return formatSetupErrorMessage(setupError) -- inferred equivalent call
	end

	local function start()
		if FFlagBuildExperiencePromptFailureTelemetry and v8 ~= nil then
			v8.start()

			if v11 == nil then
				v11 = trackPromptActivity(v10, v8, localToolControllers.getOptimisticLocalTools)
			end
		end

		v10.start()
	end

	local function stop()
		localToolControllers.stopPending()
		v10.stop()
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
	local reportUserStop

	if FFlagBuildExperiencePromptFailureTelemetry and v8 ~= nil then
		reportUserStop = v8.reportUserStop
	end

	liveAssistantTurn.reportUserStop = reportUserStop
	local detach

	if FFlagBuildExperiencePromptFailureTelemetry and v8 ~= nil then
		detach = function()
			localToolControllers.stopPending()
			finishPromptTelemetry(v8) -- inferred equivalent call
		end
	else
		detach = localToolControllers.stopPending
	end

	liveAssistantTurn.detach = detach

	liveAssistantTurn.syncFromTurnState = localToolControllers.syncFromTurnState
	liveAssistantTurn.trySubmitComposerText = localToolControllers.trySubmitComposerText
	liveAssistantTurn.trySubmitAnswerText = localToolControllers.trySubmitAnswerText
	return liveAssistantTurn
end

function CreatorAgentChat_2.createResumedAssistantTurn(data, p, callback, afterSequenceId: number?, p2, callback2)
	local localToolControllers = createLocalToolControllers(data, p2, callback2)
	local chatOpenId

	if FFlagBuildExperienceChatOpenId then
		chatOpenId = CreatorAgentChat.chatOpenTelemetry.getChatOpenIdForUniverse(data.universeId)
	else
		chatOpenId = nil
	end

	local signal = Signals.createSignal(nil)

	local flag = false
	local flag2 = false
	local v8 = nil
	local v9 = nil

	local function cleanupObservers() -- 3 equivalent calls inferred from this helper
		if v9 ~= nil then
			v9()
			v9 = nil
		end

		if v8 ~= nil then
			v8()
			v8 = nil
		end
	end

	local function finish()
		if flag2 then
			return
		end

		flag2 = true
		cleanupObservers() -- inferred equivalent call

		if FFlagBuildExperiencePromptFailureTelemetry then
			local state = p.state(false)

			if isAgentTurnFailure(state) and state.requestId == nil then -- inferred equivalent call
				local agentTurnFailureTelemetryParameters = getAgentTurnFailureTelemetryParameters(state) -- inferred equivalent call
				agentTurnFailureTelemetryParameters.isResumedTurn = "true"

				sendBuildExperienceEvent(
					"AGENT_TURN_FAILED",
					{
						universeId = data.universeId,
						placeId = data.placeId,
						conversationId = data.getCasSessionId(),
						chatOpenId = chatOpenId
					},
					agentTurnFailureTelemetryParameters
				)
			end
		end

		local v10

		if FFlagBuildExperienceModelPicker then
			local state = p.state(false)

			if not (state == nil or state.status ~= "failed") then
				v10 = {
					errorCode = state.errorCode,
					outOfCreditsReason = 0,
					isContentPolicy = 0,
					requestFailure = 0
				}
				local outOfCreditsReason

				if state.errorCode == ErrorCodes.OutOfCredits then
					if FFlagBuildExperienceModelPicker then
						outOfCreditsReason = state.fundingReason
					end

					if not outOfCreditsReason then
						outOfCreditsReason = getOutOfCreditsReason(state.error) -- inferred equivalent call
					end
				end

				v10.outOfCreditsReason = outOfCreditsReason

				v10.isContentPolicy = state.errorCode == Forbidden
				local requestFailure

				if FFlagBuildExperiencePromptFailureTelemetry then
					requestFailure = state.requestFailure
				end

				v10.requestFailure = requestFailure
			end
		end

		callback(v10)
	end

	local v10 = false

	local fn = FFlagBuildExperiencePromptFailureTelemetry and function()
		if flag2 or v10 then
			return
		end

		v10 = true

		sendBuildExperienceEvent(
			"SEND_PROMPT_STOPPED",
			{
				universeId = data.universeId,
				placeId = data.placeId,
				conversationId = data.getCasSessionId(),
				chatOpenId = chatOpenId
			},
			{ isResumedTurn = "true" }
		)
	end or nil

	local function start()
		if flag then
			return
		end

		flag = true
		local v11 = {
			onDroppedChatMessage = function(messageId: number, data2)
				local v11 = {
					universeId = data.universeId,
					placeId = data.placeId,
					conversationId = data.getCasSessionId(),
					chatOpenId = chatOpenId,
					messageId = messageId
				}
				local v12

				if FFlagBuildExperienceHistoryPollTelemetry and data2 ~= nil then
					v12 = {
						pollTrigger = data2.pollTrigger,
						appliedFromThisPoll = tostring(data2.appliedFromThisPoll)
					}

					if data2.priorSequenceId ~= nil then
						v12.priorSequenceId = tostring(data2.priorSequenceId)
					end
				end

				sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", v11, v12)
			end
		}

		if afterSequenceId ~= nil then
			v11.afterSequenceId = afterSequenceId
		end

		v8 = data.startPollingActiveTurn(v11)

		v9 = Signals.createEffect(function(p3)
			if p.state(p3).isDone then
				finish()
			end
		end)
	end

	return {
		getOptimisticLocalTools = localToolControllers.getOptimisticLocalTools,
		getLocalToolActions = localToolControllers.getLocalToolActions,
		getSetupErrorText = function(p3)
			return signal(p3)
		end,
		start = start,
		stop = function()
			if not FFlagBuildExperienceModelPicker then
				flag2 = true
				cleanupObservers() -- inferred equivalent call
			end

			localToolControllers.stopPending()
			p.cancel()
		end,
		reportUserStop = fn,
		detach = function()
			flag2 = true
			cleanupObservers() -- inferred equivalent call
			localToolControllers.stopPending()
		end,
		syncFromTurnState = localToolControllers.syncFromTurnState,
		trySubmitComposerText = localToolControllers.trySubmitComposerText,
		trySubmitAnswerText = localToolControllers.trySubmitAnswerText
	}
end

CreatorAgentChat_2.getPromptFailureComposerError = getPromptFailureComposerError

function CreatorAgentChat_2.getToolResultFailureComposerError(errorCode: number?)
	return getPromptFailureComposerError({ -- inferred equivalent call
		errorCode = errorCode,
		outOfCreditsReason = nil,
		isContentPolicy = errorCode == Forbidden,
		setupStage = nil
	})
end

return CreatorAgentChat_2
