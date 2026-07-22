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
	[ErrorCodes.InvalidParams] = LocalizationStrings.CHAT_ERROR_INVALID_PARAMS,
	[ErrorCodes.Unauthorized] = LocalizationStrings.CHAT_ERROR_UNAUTHORIZED,
	[ErrorCodes.Forbidden] = LocalizationStrings.CHAT_ERROR_FORBIDDEN,
	[ErrorCodes.NotFound] = LocalizationStrings.CHAT_ERROR_NOT_FOUND,
	[ErrorCodes.Conflict] = LocalizationStrings.CHAT_ERROR_CONFLICT,
	[ErrorCodes.Gone] = LocalizationStrings.CHAT_ERROR_GONE,
	[ErrorCodes.UpstreamUnavailable] = LocalizationStrings.CHAT_ERROR_UPSTREAM_UNAVAILABLE,
	[ErrorCodes.InternalError] = LocalizationStrings.CHAT_ERROR_INTERNAL
}

local function resolvePromptFailure(p1, p2) -- line: 87
	-- upvalues: Forbidden (copy)
	if p1 == nil then
		if p2 == nil then
			return nil
		end

		return {
			isContentPolicy = false,
			errorCode = p2.errorCode,
			setupStage = p2.stage
		}
	end

	if p1.status ~= "failed" then
		return nil
	end

	return {
		errorCode = p1.errorCode,
		isContentPolicy = p1.errorCode == Forbidden
	}
end
local function getPromptFailureTelemetryParameters(t2: {[any]: any}) -- line: 107
	local t3 = {
		isContentPolicy = tostring(t2.isContentPolicy)
	}

	if t2.errorCode ~= nil then
		t3.errorCode = tostring(t2.errorCode)
	end

	if t2.setupStage ~= nil then
		t3.setupStage = t2.setupStage
	end

	return t3
end
local function formatSetupErrorMessage(p3) -- line: 120
	-- upvalues: LocalizationStrings (copy), t1 (copy)
	local t4 = {
		isContentPolicy = false,
		errorCode = p3.errorCode,
		setupStage = p3.stage
	}

	if t4.isContentPolicy then
		return LocalizationStrings.CHAT_POLICY_REJECTION
	end

	if t4.setupStage == "missing_project" then
		return LocalizationStrings.CHAT_MISSING_PROJECT
	end

	if t4.errorCode ~= nil then
		local v30 = t1[t4.errorCode]

		if v30 ~= nil then
			return v30
		end
	end

	return LocalizationStrings.CHAT_DEFAULT_FAILURE
end
local function createLocalToolControllers(p4) -- line: 131
	-- upvalues: localToolOverlay (copy), askUserController (copy), proposePlanController (copy), clientLogsController (copy)
	local t5 = {}
	local v33 = localToolOverlay()
	local v34 = askUserController(p4, t5, v33)
	local v35 = proposePlanController(p4, t5, v33)
	local v36 = clientLogsController(p4, t5)

	return {
		getOptimisticLocalTools = v33.getOptimisticLocalTools,
		getLocalToolActions = v33.getLocalToolActions,
		hasDisplayedAnswerStack = v34.hasDisplayedAnswerStack,
		syncFromTurnState = function(p5) -- line: 142
			-- upvalues: v34 (copy), v35 (copy), v36 (copy)
			v34.syncAnswerStack(p5)
			v35.syncPlanProposal(p5)
			v36.syncClientLogsRequest(p5)
		end,
		trySubmitComposerText = function(s1: string) -- line: 147
			-- upvalues: v34 (copy), v35 (copy)
			return v34.trySubmitComposerText(s1) or v35.trySubmitComposerText(s1)
		end,
		stopPending = function() -- line: 150
			-- upvalues: v34 (copy), v35 (copy)
			v34.stopPendingAnswer()
			v35.stopPendingPlan()
		end
	}
end

return {
	createLiveAssistantTurn = function(p6, s2: string, p7: ((...any) -> ...any)) -- line: 159
		-- upvalues: createLocalToolControllers (copy), StudioAskUserTool (copy), StudioProposePlanTool (copy), StudioClientLogsTool (copy), sendBuildExperienceEvent (copy), resolvePromptFailure (copy), debug (copy), LocalizationStrings (copy), t1 (copy)
		local v40 = createLocalToolControllers(p6)
		local universeId = p6.universeId
		local t6 = {
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
		local u43 = nil

		u43 = p6.sendPrompt({
			prompt = s2,
			promptMeta = t6,
			onDroppedChatMessage = function(n1: number) -- line: 182
				-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), p6 (copy)
				sendBuildExperienceEvent("DROPPED_CHAT_MESSAGE", {
					universeId = universeId,
					placeId = p6.placeId,
					conversationId = p6.getCasSessionId(),
					messageId = n1
				})
			end,
			onCompleted = function(p8) -- line: 196
				-- upvalues: resolvePromptFailure (copy), u43 (ref), debug (copy), universeId (copy), p6 (copy), sendBuildExperienceEvent (copy), p7 (copy)
				local v59 = resolvePromptFailure(p8, u43.getSetupError(false))

				if v59 ~= nil then
					debug.log("info", "prompt send failed", {
						errorCode = v59.errorCode,
						isContentPolicy = v59.isContentPolicy,
						setupStage = v59.setupStage,
						universeId = universeId,
						placeId = p6.placeId
					})

					local v60 = sendBuildExperienceEvent
					local t7 = {
						universeId = universeId,
						placeId = p6.placeId,
						conversationId = p6.getCasSessionId()
					}
					local t8 = {
						isContentPolicy = tostring(v59.isContentPolicy)
					}

					if v59.errorCode ~= nil then
						t8.errorCode = tostring(v59.errorCode)
					end

					if v59.setupStage ~= nil then
						t8.setupStage = v59.setupStage
					end

					v60("SEND_PROMPT_FAILED", t7, t8)
				end

				p7(v59)
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
			getOptimisticLocalTools = v40.getOptimisticLocalTools,
			getLocalToolActions = v40.getLocalToolActions,
			getSetupErrorText = function(p9) -- line: 219
				-- upvalues: u43 (ref), LocalizationStrings (copy), t1 (copy)
				local v64 = u43.getSetupError(p9)

				if v64 ~= nil then
					local t9 = {
						isContentPolicy = false,
						errorCode = v64.errorCode,
						setupStage = v64.stage
					}

					if t9.isContentPolicy then
						return LocalizationStrings.CHAT_POLICY_REJECTION
					end

					if t9.setupStage == "missing_project" then
						return LocalizationStrings.CHAT_MISSING_PROJECT
					end

					if t9.errorCode ~= nil then
						local v66 = t1[t9.errorCode]

						if v66 ~= nil then
							return v66
						end
					end

					return LocalizationStrings.CHAT_DEFAULT_FAILURE
				end

				return nil
			end,
			start = function() -- line: 232
				-- upvalues: u43 (ref)
				u43.start()
			end,
			stop = function() -- line: 238
				-- upvalues: v40 (copy), u43 (ref)
				v40.stopPending()
				u43.stop()
			end,
			syncFromTurnState = v40.syncFromTurnState,
			trySubmitComposerText = v40.trySubmitComposerText
		}
	end,
	createResumedAssistantTurn = function(p10, p11, p12: ((...any) -> ...any), n2: number?) -- line: 254
		-- upvalues: createLocalToolControllers (copy), Signals (copy), sendBuildExperienceEvent (copy)
		local v48 = createLocalToolControllers(p10)
		local v49 = Signals.createSignal(nil)
		local u50 = false
		local u51 = false
		local u52 = nil
		local u53 = nil

		local function finish() -- line: 274
			-- upvalues: u51 (ref), u53 (ref), u52 (ref), p12 (copy)
			if u51 then
				return
			end

			u51 = true

			if u53 ~= nil then
				u53()
				u53 = nil
			end

			if u52 ~= nil then
				u52()
				u52 = nil
			end

			p12(nil)
		end

		return {
			getOptimisticLocalTools = v48.getOptimisticLocalTools,
			getLocalToolActions = v48.getLocalToolActions,
			getSetupErrorText = v49,
			start = function() -- line: 292
				-- upvalues: u50 (ref), sendBuildExperienceEvent (copy), p10 (copy), n2 (copy), u52 (ref), u53 (ref), Signals (copy), p11 (copy), u51 (ref), p12 (copy)
				if u50 then
					return
				end

				u50 = true

				local t10 = {
					onDroppedChatMessage = function(n3: number) -- line: 298
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

				u52 = p10.startPollingActiveTurn(t10)
				u53 = Signals.createEffect(function(p13) -- line: 312
					-- upvalues: p11 (copy), u51 (ref), u53 (ref), u52 (ref), p12 (copy)
					if p11.state(p13).isDone then
						if u51 then
							return
						end

						u51 = true

						if u53 ~= nil then
							u53()
							u53 = nil
						end

						if u52 ~= nil then
							u52()
							u52 = nil
						end

						p12(nil)
					end
				end)
			end,
			stop = function() -- line: 324
				-- upvalues: u51 (ref), u53 (ref), u52 (ref), v48 (copy), p11 (copy)
				u51 = true

				if u53 ~= nil then
					u53()
					u53 = nil
				end

				if u52 ~= nil then
					u52()
					u52 = nil
				end

				v48.stopPending()
				p11.cancel()
			end,
			syncFromTurnState = v48.syncFromTurnState,
			trySubmitComposerText = v48.trySubmitComposerText
		}
	end,
	getPromptFailureComposerError = function(t11: {[any]: any}) -- line: 69
		-- upvalues: LocalizationStrings (copy), t1 (copy)
		if t11.isContentPolicy then
			return LocalizationStrings.CHAT_POLICY_REJECTION
		end

		if t11.setupStage == "missing_project" then
			return LocalizationStrings.CHAT_MISSING_PROJECT
		end

		if t11.errorCode ~= nil then
			local v23 = t1[t11.errorCode]

			if v23 ~= nil then
				return v23
			end
		end

		return LocalizationStrings.CHAT_DEFAULT_FAILURE
	end
}
