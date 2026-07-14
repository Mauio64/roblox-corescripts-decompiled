local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local Signals = require(Parent.Signals)

require(script.Parent.chatTypes)

local askUserController = require(script.Parent.askUserController)
local clientLogsController = require(script.Parent.clientLogsController)
local localToolOverlay = require(script.Parent.localToolOverlay)
local proposePlanController = require(script.Parent.proposePlanController)
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local debug = CreatorAgentChat.debug
local ErrorCodes = CreatorAgentChat.ErrorCodes
local Forbidden = ErrorCodes.Forbidden
local t1 = {
	[ErrorCodes.InvalidParams] = "Something went wrong with your message. Please edit it and try again.",
	[ErrorCodes.Unauthorized] = "You're signed out. Please sign in and try again.",
	[ErrorCodes.Forbidden] = "The assistant isn't available for your account right now.",
	[ErrorCodes.NotFound] = "We couldn't find this chat. Please start a new one.",
	[ErrorCodes.Conflict] = "The assistant is busy with another request. Please wait a moment and try again.",
	[ErrorCodes.Gone] = "This chat is no longer available. Please start a new one.",
	[ErrorCodes.UpstreamUnavailable] = "The assistant is temporarily unavailable. Please try again in a moment.",
	[ErrorCodes.InternalError] = "The assistant ran into a problem. Please try again."
}

local function resolvePromptFailure(p1, p2) -- line: 89
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
local function formatSetupErrorMessage(p3) -- line: 109
	-- upvalues: t1 (copy)
	local t2 = {
		isContentPolicy = false,
		errorCode = p3.errorCode,
		setupStage = p3.stage
	}

	if t2.isContentPolicy then
		return "Your message violates Roblox safety policy. Edit it and try again."
	end

	if t2.setupStage == "missing_project" then
		return "An experience is required to chat with the assistant."
	end

	if t2.errorCode ~= nil then
		local v24 = t1[t2.errorCode]

		if v24 ~= nil then
			return v24
		end
	end

	return "The assistant couldn't connect. Please try again."
end
local function createLocalToolControllers(p4) -- line: 120
	-- upvalues: localToolOverlay (copy), askUserController (copy), proposePlanController (copy), clientLogsController (copy)
	local t3 = {}
	local v27 = localToolOverlay()
	local v28 = askUserController(p4, t3, v27)
	local v29 = proposePlanController(p4, t3, v27)
	local v30 = clientLogsController(p4, t3)

	return {
		getOptimisticLocalTools = v27.getOptimisticLocalTools,
		getLocalToolActions = v27.getLocalToolActions,
		hasDisplayedAnswerStack = v28.hasDisplayedAnswerStack,
		syncFromTurnState = function(p5) -- line: 131
			-- upvalues: v28 (copy), v29 (copy), v30 (copy)
			v28.syncAnswerStack(p5)
			v29.syncPlanProposal(p5)
			v30.syncClientLogsRequest(p5)
		end,
		trySubmitComposerText = function(s1: string) -- line: 136
			-- upvalues: v28 (copy), v29 (copy)
			return v28.trySubmitComposerText(s1) or v29.trySubmitComposerText(s1)
		end,
		stopPending = function() -- line: 139
			-- upvalues: v28 (copy), v29 (copy)
			v28.stopPendingAnswer()
			v29.stopPendingPlan()
		end
	}
end

return {
	createLiveAssistantTurn = function(p6, s2: string, p7: ((...any) -> ...any)) -- line: 148
		-- upvalues: createLocalToolControllers (copy), StudioAskUserTool (copy), StudioProposePlanTool (copy), StudioClientLogsTool (copy), resolvePromptFailure (copy), debug (copy), t1 (copy)
		local v34 = createLocalToolControllers(p6)
		local universeId = p6.universeId
		local t4 = {
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
		local u37 = nil

		u37 = p6.sendPrompt({
			prompt = s2,
			promptMeta = t4,
			onCompleted = function(p8) -- line: 175
				-- upvalues: resolvePromptFailure (copy), u37 (ref), debug (copy), universeId (copy), p6 (copy), p7 (copy)
				local v52 = resolvePromptFailure(p8, u37.getSetupError(false))

				if v52 ~= nil then
					debug.log("info", "prompt send failed", {
						errorCode = v52.errorCode,
						isContentPolicy = v52.isContentPolicy,
						setupStage = v52.setupStage,
						universeId = universeId,
						placeId = p6.placeId
					})
				end

				p7(v52)
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
			getOptimisticLocalTools = v34.getOptimisticLocalTools,
			getLocalToolActions = v34.getLocalToolActions,
			getSetupErrorText = function(p9) -- line: 193
				-- upvalues: u37 (ref), t1 (copy)
				local v54 = u37.getSetupError(p9)

				if v54 ~= nil then
					local t5 = {
						isContentPolicy = false,
						errorCode = v54.errorCode,
						setupStage = v54.stage
					}

					if t5.isContentPolicy then
						return "Your message violates Roblox safety policy. Edit it and try again."
					end

					if t5.setupStage == "missing_project" then
						return "An experience is required to chat with the assistant."
					end

					if t5.errorCode ~= nil then
						local v56 = t1[t5.errorCode]

						if v56 ~= nil then
							return v56
						end
					end

					return "The assistant couldn't connect. Please try again."
				end

				return nil
			end,
			start = function() -- line: 206
				-- upvalues: u37 (ref)
				u37.start()
			end,
			stop = function() -- line: 212
				-- upvalues: v34 (copy), u37 (ref)
				v34.stopPending()
				u37.stop()
			end,
			syncFromTurnState = v34.syncFromTurnState,
			trySubmitComposerText = v34.trySubmitComposerText
		}
	end,
	createResumedAssistantTurn = function(p10, p11, p12: ((...any) -> ...any), n1: number?) -- line: 228
		-- upvalues: createLocalToolControllers (copy), Signals (copy)
		local v42 = createLocalToolControllers(p10)
		local v43 = Signals.createSignal(nil)
		local u44 = false
		local u45 = false
		local u46 = nil
		local u47 = nil

		local function finish() -- line: 248
			-- upvalues: u45 (ref), u47 (ref), u46 (ref), p12 (copy)
			if u45 then
				return
			end

			u45 = true

			if u47 ~= nil then
				u47()
				u47 = nil
			end

			if u46 ~= nil then
				u46()
				u46 = nil
			end

			p12(nil)
		end

		return {
			getOptimisticLocalTools = v42.getOptimisticLocalTools,
			getLocalToolActions = v42.getLocalToolActions,
			getSetupErrorText = v43,
			start = function() -- line: 266
				-- upvalues: u44 (ref), n1 (copy), u46 (ref), p10 (copy), u47 (ref), Signals (copy), p11 (copy), u45 (ref), p12 (copy)
				if u44 then
					return
				end

				u44 = true

				local t6 = {}

				if n1 ~= nil then
					t6.afterSequenceId = n1
				end

				u46 = p10.startPollingActiveTurn(t6)
				u47 = Signals.createEffect(function(p13) -- line: 277
					-- upvalues: p11 (copy), u45 (ref), u47 (ref), u46 (ref), p12 (copy)
					if p11.state(p13).isDone then
						if u45 then
							return
						end

						u45 = true

						if u47 ~= nil then
							u47()
							u47 = nil
						end

						if u46 ~= nil then
							u46()
							u46 = nil
						end

						p12(nil)
					end
				end)
			end,
			stop = function() -- line: 289
				-- upvalues: u45 (ref), u47 (ref), u46 (ref), v42 (copy), p11 (copy)
				u45 = true

				if u47 ~= nil then
					u47()
					u47 = nil
				end

				if u46 ~= nil then
					u46()
					u46 = nil
				end

				v42.stopPending()
				p11.cancel()
			end,
			syncFromTurnState = v42.syncFromTurnState,
			trySubmitComposerText = v42.trySubmitComposerText
		}
	end,
	getPromptFailureComposerError = function(t7: {[any]: any}) -- line: 71
		-- upvalues: t1 (copy)
		if t7.isContentPolicy then
			return "Your message violates Roblox safety policy. Edit it and try again."
		end

		if t7.setupStage == "missing_project" then
			return "An experience is required to chat with the assistant."
		end

		if t7.errorCode ~= nil then
			local v19 = t1[t7.errorCode]

			if v19 ~= nil then
				return v19
			end
		end

		return "The assistant couldn't connect. Please try again."
	end
}
