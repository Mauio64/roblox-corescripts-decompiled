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

local function getOutOfCreditsReason(s1: string?) -- line: 103
	-- upvalues: t1 (copy)
	if s1 == nil then
		return nil
	end

	return t1[s1]
end
local function resolvePromptFailure(p1, p2) -- line: 112
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
	local v34

	if p1.errorCode == ErrorCodes.OutOfCredits then
		local error = p1.error

		v34 = if error ~= nil then t1[error] else nil
	else
		v34 = nil
	end

	t3.outOfCreditsReason = v34
	t3.isContentPolicy = p1.errorCode == Forbidden

	return t3
end
local function getPromptFailureTelemetryParameters(t4: {[any]: any}) -- line: 136
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
local function formatSetupErrorMessage(p3) -- line: 152
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
		local v39 = t2[t6.errorCode]

		if v39 ~= nil then
			return v39
		end
	end

	return LocalizationStrings.CHAT_DEFAULT_FAILURE
end
local function createLocalToolControllers(p4, p5) -- line: 163
	-- upvalues: localToolOverlay (copy), askUserController (copy), proposePlanController (copy), clientLogsController (copy)
	local t7 = {}
	local v43 = localToolOverlay()
	local v44 = askUserController(p4, t7, v43, p5)
	local v45 = proposePlanController(p4, t7, v43, p5)
	local v46 = clientLogsController(p4, t7)

	return {
		getOptimisticLocalTools = v43.getOptimisticLocalTools,
		getLocalToolActions = v43.getLocalToolActions,
		hasDisplayedAnswerStack = v44.hasDisplayedAnswerStack,
		syncFromTurnState = function(p6) -- line: 178
			-- upvalues: v44 (copy), v45 (copy), v46 (copy)
			v44.syncAnswerStack(p6)
			v45.syncPlanProposal(p6)
			v46.syncClientLogsRequest(p6)
		end,
		trySubmitComposerText = function(s2: string) -- line: 183
			-- upvalues: v44 (copy), v45 (copy)
			return v44.trySubmitComposerText(s2) or v45.trySubmitComposerText(s2)
		end,
		stopPending = function() -- line: 186
			-- upvalues: v44 (copy), v45 (copy)
			v44.stopPendingAnswer()
			v45.stopPendingPlan()
		end
	}
end

return {
	createLiveAssistantTurn = function(p7, s3: string, p8: ((...any) -> ...any), p9) -- line: 195
		-- upvalues: createLocalToolControllers (copy), StudioAskUserTool (copy), StudioProposePlanTool (copy), StudioClientLogsTool (copy), sendBuildExperienceEvent (copy), resolvePromptFailure (copy), debug (copy), getPromptFailureTelemetryParameters (copy), LocalizationStrings (copy), t2 (copy)
		local v51 = createLocalToolControllers(p7, p9)
		local universeId = p7.universeId
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
		local u54 = nil

		u54 = p7.sendPrompt({
			prompt = s3,
			promptMeta = t8,
			onDroppedChatMessage = function(n1: number) -- line: 219
				-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), p7 (copy)
				sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", {
					universeId = universeId,
					placeId = p7.placeId,
					conversationId = p7.getCasSessionId(),
					messageId = n1
				})
			end,
			onCompleted = function(p10) -- line: 233
				-- upvalues: resolvePromptFailure (copy), u54 (ref), debug (copy), universeId (copy), p7 (copy), sendBuildExperienceEvent (copy), getPromptFailureTelemetryParameters (copy), p8 (copy)
				local v72 = resolvePromptFailure(p10, u54.getSetupError(false))

				if v72 ~= nil then
					debug.log("info", "prompt send failed", {
						errorCode = v72.errorCode,
						isContentPolicy = v72.isContentPolicy,
						setupStage = v72.setupStage,
						universeId = universeId,
						placeId = p7.placeId
					})
					sendBuildExperienceEvent("SEND_PROMPT_FAILED", {
						universeId = universeId,
						placeId = p7.placeId,
						conversationId = p7.getCasSessionId()
					}, (getPromptFailureTelemetryParameters(v72)))
				end

				p8(v72)
			end
		})
		debug.log("info", "creator agent local tools registered for prompt", {
			universeId = universeId,
			placeId = p7.placeId,
			toolName = StudioAskUserTool.TOOL_NAME,
			planToolName = StudioProposePlanTool.TOOL_NAME,
			logsToolName = StudioClientLogsTool.TOOL_NAME
		})

		return {
			getOptimisticLocalTools = v51.getOptimisticLocalTools,
			getLocalToolActions = v51.getLocalToolActions,
			getSetupErrorText = function(p11) -- line: 256
				-- upvalues: u54 (ref), LocalizationStrings (copy), t2 (copy)
				local v74 = u54.getSetupError(p11)

				if v74 ~= nil then
					local t9 = {
						isContentPolicy = false,
						errorCode = v74.errorCode,
						setupStage = v74.stage
					}

					if t9.isContentPolicy then
						return LocalizationStrings.CHAT_POLICY_REJECTION
					end

					if t9.setupStage == "missing_project" then
						return LocalizationStrings.CHAT_MISSING_PROJECT
					end

					if t9.errorCode ~= nil then
						local v76 = t2[t9.errorCode]

						if v76 ~= nil then
							return v76
						end
					end

					return LocalizationStrings.CHAT_DEFAULT_FAILURE
				end

				return nil
			end,
			start = function() -- line: 269
				-- upvalues: u54 (ref)
				u54.start()
			end,
			stop = function() -- line: 275
				-- upvalues: v51 (copy), u54 (ref)
				v51.stopPending()
				u54.stop()
			end,
			detach = v51.stopPending,
			syncFromTurnState = v51.syncFromTurnState,
			trySubmitComposerText = v51.trySubmitComposerText
		}
	end,
	createResumedAssistantTurn = function(p12, p13, p14: ((...any) -> ...any), n2: number?, p15) -- line: 292
		-- upvalues: createLocalToolControllers (copy), Signals (copy), sendBuildExperienceEvent (copy)
		local v60 = createLocalToolControllers(p12, p15)
		local v61 = Signals.createSignal(nil)
		local u62 = false
		local u63 = false
		local u64 = nil
		local u65 = nil

		local function cleanupObservers() -- line: 313
			-- upvalues: u65 (ref), u64 (ref)
			if u65 ~= nil then
				u65()
				u65 = nil
			end

			if u64 ~= nil then
				u64()
				u64 = nil
			end
		end
		local function finish() -- line: 324
			-- upvalues: u63 (ref), u65 (ref), u64 (ref), p14 (copy)
			if u63 then
				return
			end

			u63 = true

			if u65 ~= nil then
				u65()
				u65 = nil
			end

			if u64 ~= nil then
				u64()
				u64 = nil
			end

			p14(nil)
		end

		return {
			getOptimisticLocalTools = v60.getOptimisticLocalTools,
			getLocalToolActions = v60.getLocalToolActions,
			getSetupErrorText = v61,
			start = function() -- line: 335
				-- upvalues: u62 (ref), sendBuildExperienceEvent (copy), p12 (copy), n2 (copy), u64 (ref), u65 (ref), Signals (copy), p13 (copy), u63 (ref), p14 (copy)
				if u62 then
					return
				end

				u62 = true

				local t10 = {
					onDroppedChatMessage = function(n3: number) -- line: 341
						-- upvalues: sendBuildExperienceEvent (copy), p12 (copy)
						sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", {
							universeId = p12.universeId,
							placeId = p12.placeId,
							conversationId = p12.getCasSessionId(),
							messageId = n3
						})
					end
				}

				if n2 ~= nil then
					t10.afterSequenceId = n2
				end

				u64 = p12.startPollingActiveTurn(t10)
				u65 = Signals.createEffect(function(p16) -- line: 355
					-- upvalues: p13 (copy), u63 (ref), u65 (ref), u64 (ref), p14 (copy)
					if p13.state(p16).isDone then
						if u63 then
							return
						end

						u63 = true

						if u65 ~= nil then
							u65()
							u65 = nil
						end

						if u64 ~= nil then
							u64()
							u64 = nil
						end

						p14(nil)
					end
				end)
			end,
			stop = function() -- line: 367
				-- upvalues: u63 (ref), u65 (ref), u64 (ref), v60 (copy), p13 (copy)
				u63 = true

				if u65 ~= nil then
					u65()
					u65 = nil
				end

				if u64 ~= nil then
					u64()
					u64 = nil
				end

				v60.stopPending()
				p13.cancel()
			end,
			detach = function() -- line: 373
				-- upvalues: u63 (ref), u65 (ref), u64 (ref), v60 (copy)
				u63 = true

				if u65 ~= nil then
					u65()
					u65 = nil
				end

				if u64 ~= nil then
					u64()
					u64 = nil
				end

				v60.stopPending()
			end,
			syncFromTurnState = v60.syncFromTurnState,
			trySubmitComposerText = v60.trySubmitComposerText
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
	end,
	getToolResultFailureComposerError = function(n4: number?) -- line: 94
		-- upvalues: Forbidden (copy), LocalizationStrings (copy), t2 (copy)
		local t12 = {
			outOfCreditsReason = nil,
			setupStage = nil,
			errorCode = n4,
			isContentPolicy = n4 == Forbidden
		}

		if t12.isContentPolicy then
			return LocalizationStrings.CHAT_POLICY_REJECTION
		end

		if t12.setupStage == "missing_project" then
			return LocalizationStrings.CHAT_MISSING_PROJECT
		end

		if t12.errorCode ~= nil then
			local v28 = t2[t12.errorCode]

			if v28 ~= nil then
				return v28
			end
		end

		return LocalizationStrings.CHAT_DEFAULT_FAILURE
	end
}
