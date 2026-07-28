local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Signals = require(BuildExperienceParent.Signals)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(script.Parent.chatTypes)

local askUserController = require(script.Parent.askUserController)
local clientLogsController = require(script.Parent.clientLogsController)
local localToolOverlay = require(script.Parent.localToolOverlay)
local proposePlanController = require(script.Parent.proposePlanController)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local debug = CreatorAgentChat.debug
local ErrorCodes = CreatorAgentChat.ErrorCodes
local Forbidden = ErrorCodes.Forbidden
local t1 = {
	FreeTrialExhausted = "FreeTrialExhausted",
	DailyLimitReached = "DailyLimitReached",
	InsufficientRobuxBalance = "InsufficientRobuxBalance"
}
local t2 = {
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

local function getOutOfCreditsReason(s1: string?) -- line: 94
	-- upvalues: t1 (copy)
	if s1 == nil then
		return nil
	end

	return t1[s1]
end
local function resolvePromptFailure(p1, p2) -- line: 103
	-- upvalues: ErrorCodes (copy), t1 (copy), Forbidden (copy)
	if p1 == nil then
		if p2 == nil then
			return nil
		end

		return {
			outOfCreditsReason = nil,
			isContentPolicy = false,
			errorCode = p2.errorCode,
			setupStage = p2.stage
		}
	end

	if p1.status ~= "failed" then
		return nil
	end

	local t3 = {
		errorCode = p1.errorCode
	}
	local v31

	if p1.errorCode == ErrorCodes.OutOfCredits then
		local error = p1.error

		v31 = if error ~= nil then t1[error] else nil
	else
		v31 = nil
	end

	t3.outOfCreditsReason = v31
	t3.isContentPolicy = p1.errorCode == Forbidden

	return t3
end
local function getPromptFailureTelemetryParameters(t4: {[any]: any}) -- line: 127
	local t5 = {
		isContentPolicy = tostring(t4.isContentPolicy)
	}

	if t4.errorCode ~= nil then
		t5.errorCode = tostring(t4.errorCode)
	end

	if t4.outOfCreditsReason ~= nil then
		t5.outOfCreditsReason = t4.outOfCreditsReason
	end

	if t4.setupStage ~= nil then
		t5.setupStage = t4.setupStage
	end

	return t5
end
local function formatSetupErrorMessage(p3) -- line: 143
	-- upvalues: LocalizationStrings (copy), t2 (copy)
	local t6 = {
		isContentPolicy = false,
		errorCode = p3.errorCode,
		setupStage = p3.stage
	}

	if t6.isContentPolicy then
		return LocalizationStrings.CHAT_POLICY_REJECTION
	end

	if t6.setupStage == "missing_project" then
		return LocalizationStrings.CHAT_MISSING_PROJECT
	end

	if t6.errorCode ~= nil then
		local v36 = t2[t6.errorCode]

		if v36 ~= nil then
			return v36
		end
	end

	return LocalizationStrings.CHAT_DEFAULT_FAILURE
end
local function createLocalToolControllers(p4) -- line: 154
	-- upvalues: localToolOverlay (copy), askUserController (copy), proposePlanController (copy), clientLogsController (copy)
	local t7 = {}
	local v39 = localToolOverlay()
	local v40 = askUserController(p4, t7, v39)
	local v41 = proposePlanController(p4, t7, v39)
	local v42 = clientLogsController(p4, t7)

	return {
		getOptimisticLocalTools = v39.getOptimisticLocalTools,
		getLocalToolActions = v39.getLocalToolActions,
		hasDisplayedAnswerStack = v40.hasDisplayedAnswerStack,
		syncFromTurnState = function(p5) -- line: 165
			-- upvalues: v40 (copy), v41 (copy), v42 (copy)
			v40.syncAnswerStack(p5)
			v41.syncPlanProposal(p5)
			v42.syncClientLogsRequest(p5)
		end,
		trySubmitComposerText = function(s2: string) -- line: 170
			-- upvalues: v40 (copy), v41 (copy)
			return v40.trySubmitComposerText(s2) or v41.trySubmitComposerText(s2)
		end,
		stopPending = function() -- line: 173
			-- upvalues: v40 (copy), v41 (copy)
			v40.stopPendingAnswer()
			v41.stopPendingPlan()
		end
	}
end

return {
	createLiveAssistantTurn = function(p6, s3: string, p7: ((...any) -> ...any)) -- line: 182
		-- upvalues: createLocalToolControllers (copy), StudioAskUserTool (copy), StudioProposePlanTool (copy), StudioClientLogsTool (copy), sendBuildExperienceEvent (copy), resolvePromptFailure (copy), debug (copy), getPromptFailureTelemetryParameters (copy), LocalizationStrings (copy), t2 (copy)
		local v46 = createLocalToolControllers(p6)
		local universeId = p6.universeId
		local t8 = {
			_roblox = {
				localTools = {
					StudioAskUserTool.LOCAL_TOOL_DEFINITION,
					StudioProposePlanTool.LOCAL_TOOL_DEFINITION,
					StudioClientLogsTool.LOCAL_TOOL_DEFINITION
				},
				providerConfig = {
					universeId = universeId
				}
			}
		}
		local u49 = nil

		u49 = p6.sendPrompt({
			prompt = s3,
			promptMeta = t8,
			onDroppedChatMessage = function(n1: number) -- line: 205
				-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), p6 (copy)
				sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", {
					universeId = universeId,
					placeId = p6.placeId,
					conversationId = p6.getCasSessionId(),
					messageId = n1
				})
			end,
			onCompleted = function(p8) -- line: 219
				-- upvalues: resolvePromptFailure (copy), u49 (ref), debug (copy), universeId (copy), p6 (copy), sendBuildExperienceEvent (copy), getPromptFailureTelemetryParameters (copy), p7 (copy)
				local v66 = resolvePromptFailure(p8, u49.getSetupError(false))

				if v66 ~= nil then
					debug.log("info", "prompt send failed", {
						errorCode = v66.errorCode,
						isContentPolicy = v66.isContentPolicy,
						setupStage = v66.setupStage,
						universeId = universeId,
						placeId = p6.placeId
					})
					sendBuildExperienceEvent("SEND_PROMPT_FAILED", {
						universeId = universeId,
						placeId = p6.placeId,
						conversationId = p6.getCasSessionId()
					}, (getPromptFailureTelemetryParameters(v66)))
				end

				p7(v66)
			end
		})
		debug.log("info", "creator agent local tools registered for prompt", {
			universeId = universeId,
			placeId = p6.placeId,
			toolName = StudioAskUserTool.TOOL_NAME,
			planToolName = StudioProposePlanTool.TOOL_NAME,
			logsToolName = StudioClientLogsTool.TOOL_NAME
		})

		return {
			getOptimisticLocalTools = v46.getOptimisticLocalTools,
			getLocalToolActions = v46.getLocalToolActions,
			getSetupErrorText = function(p9) -- line: 242
				-- upvalues: u49 (ref), LocalizationStrings (copy), t2 (copy)
				local v68 = u49.getSetupError(p9)

				if v68 ~= nil then
					local t9 = {
						isContentPolicy = false,
						errorCode = v68.errorCode,
						setupStage = v68.stage
					}

					if t9.isContentPolicy then
						return LocalizationStrings.CHAT_POLICY_REJECTION
					end

					if t9.setupStage == "missing_project" then
						return LocalizationStrings.CHAT_MISSING_PROJECT
					end

					if t9.errorCode ~= nil then
						local v70 = t2[t9.errorCode]

						if v70 ~= nil then
							return v70
						end
					end

					return LocalizationStrings.CHAT_DEFAULT_FAILURE
				end

				return nil
			end,
			start = function() -- line: 255
				-- upvalues: u49 (ref)
				u49.start()
			end,
			stop = function() -- line: 261
				-- upvalues: v46 (copy), u49 (ref)
				v46.stopPending()
				u49.stop()
			end,
			detach = v46.stopPending,
			syncFromTurnState = v46.syncFromTurnState,
			trySubmitComposerText = v46.trySubmitComposerText
		}
	end,
	createResumedAssistantTurn = function(p10, p11, p12: ((...any) -> ...any), n2: number?) -- line: 278
		-- upvalues: createLocalToolControllers (copy), Signals (copy), sendBuildExperienceEvent (copy)
		local v54 = createLocalToolControllers(p10)
		local v55 = Signals.createSignal(nil)
		local u56 = false
		local u57 = false
		local u58 = nil
		local u59 = nil

		local function cleanupObservers() -- line: 298
			-- upvalues: u59 (ref), u58 (ref)
			if u59 ~= nil then
				u59()
				u59 = nil
			end

			if u58 ~= nil then
				u58()
				u58 = nil
			end
		end
		local function finish() -- line: 309
			-- upvalues: u57 (ref), u59 (ref), u58 (ref), p12 (copy)
			if u57 then
				return
			end

			u57 = true

			if u59 ~= nil then
				u59()
				u59 = nil
			end

			if u58 ~= nil then
				u58()
				u58 = nil
			end

			p12(nil)
		end

		return {
			getOptimisticLocalTools = v54.getOptimisticLocalTools,
			getLocalToolActions = v54.getLocalToolActions,
			getSetupErrorText = v55,
			start = function() -- line: 320
				-- upvalues: u56 (ref), sendBuildExperienceEvent (copy), p10 (copy), n2 (copy), u58 (ref), u59 (ref), Signals (copy), p11 (copy), u57 (ref), p12 (copy)
				if u56 then
					return
				end

				u56 = true

				local t10 = {
					onDroppedChatMessage = function(n3: number) -- line: 326
						-- upvalues: sendBuildExperienceEvent (copy), p10 (copy)
						sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", {
							universeId = p10.universeId,
							placeId = p10.placeId,
							conversationId = p10.getCasSessionId(),
							messageId = n3
						})
					end
				}

				if n2 ~= nil then
					t10.afterSequenceId = n2
				end

				u58 = p10.startPollingActiveTurn(t10)
				u59 = Signals.createEffect(function(p13) -- line: 340
					-- upvalues: p11 (copy), u57 (ref), u59 (ref), u58 (ref), p12 (copy)
					if p11.state(p13).isDone then
						if u57 then
							return
						end

						u57 = true

						if u59 ~= nil then
							u59()
							u59 = nil
						end

						if u58 ~= nil then
							u58()
							u58 = nil
						end

						p12(nil)
					end
				end)
			end,
			stop = function() -- line: 352
				-- upvalues: u57 (ref), u59 (ref), u58 (ref), v54 (copy), p11 (copy)
				u57 = true

				if u59 ~= nil then
					u59()
					u59 = nil
				end

				if u58 ~= nil then
					u58()
					u58 = nil
				end

				v54.stopPending()
				p11.cancel()
			end,
			detach = function() -- line: 358
				-- upvalues: u57 (ref), u59 (ref), u58 (ref), v54 (copy)
				u57 = true

				if u59 ~= nil then
					u59()
					u59 = nil
				end

				if u58 ~= nil then
					u58()
					u58 = nil
				end

				v54.stopPending()
			end,
			syncFromTurnState = v54.syncFromTurnState,
			trySubmitComposerText = v54.trySubmitComposerText
		}
	end,
	getPromptFailureComposerError = function(t11: {[any]: any}) -- line: 78
		-- upvalues: LocalizationStrings (copy), t2 (copy)
		if t11.isContentPolicy then
			return LocalizationStrings.CHAT_POLICY_REJECTION
		end

		if t11.setupStage == "missing_project" then
			return LocalizationStrings.CHAT_MISSING_PROJECT
		end

		if t11.errorCode ~= nil then
			local v25 = t2[t11.errorCode]

			if v25 ~= nil then
				return v25
			end
		end

		return LocalizationStrings.CHAT_DEFAULT_FAILURE
	end
}
