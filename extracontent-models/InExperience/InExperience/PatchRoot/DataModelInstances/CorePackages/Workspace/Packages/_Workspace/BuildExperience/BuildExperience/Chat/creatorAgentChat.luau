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

local function isContentPolicyViolation(p1) -- line: 45
	if p1 == nil or p1.status ~= "failed" then
		return false
	end

	return p1.errorCode == -32001
end
local function formatSetupErrorMessage(p2) -- line: 53
	if p2.message ~= nil and p2.message ~= "" then
		return p2.message
	end

	if p2.stage == "missing_project" then
		return "An experience is required to chat with the assistant."
	end

	if p2.stage == "session_new" then
		return "The assistant couldn't start a session. Please try again."
	end

	return "The assistant couldn't connect. Please try again."
end
local function createLocalToolControllers(p3) -- line: 70
	-- upvalues: localToolOverlay (copy), askUserController (copy), proposePlanController (copy), clientLogsController (copy)
	local t1 = {}
	local v19 = localToolOverlay()
	local v20 = askUserController(p3, t1, v19)
	local v21 = proposePlanController(p3, t1, v19)
	local v22 = clientLogsController(p3, t1)

	return {
		getOptimisticLocalTools = v19.getOptimisticLocalTools,
		getLocalToolActions = v19.getLocalToolActions,
		hasDisplayedAnswerStack = v20.hasDisplayedAnswerStack,
		syncFromTurnState = function(p4) -- line: 81
			-- upvalues: v20 (copy), v21 (copy), v22 (copy)
			v20.syncAnswerStack(p4)
			v21.syncPlanProposal(p4)
			v22.syncClientLogsRequest(p4)
		end,
		trySubmitComposerText = function(s1: string) -- line: 86
			-- upvalues: v20 (copy), v21 (copy)
			return v20.trySubmitComposerText(s1) or v21.trySubmitComposerText(s1)
		end,
		stopPending = function() -- line: 89
			-- upvalues: v20 (copy), v21 (copy)
			v20.stopPendingAnswer()
			v21.stopPendingPlan()
		end
	}
end

return {
	createLiveAssistantTurn = function(p5, s2: string, p6: ((...any) -> ...any)) -- line: 98
		-- upvalues: createLocalToolControllers (copy), StudioAskUserTool (copy), StudioProposePlanTool (copy), StudioClientLogsTool (copy), debug (copy)
		local v26 = createLocalToolControllers(p5)
		local universeId = p5.universeId
		local t2 = {
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
		local u29 = p5.sendPrompt({
			prompt = s2,
			promptMeta = t2,
			onCompleted = function(p7) -- line: 125
				-- upvalues: p6 (copy)
				p6(if not (p7 ~= nil and (p7.status == "failed" and p7.errorCode == -32001)) then nil else "content_policy")
			end
		})

		debug.log("info", "creator agent local tools registered for prompt", {
			universeId = universeId,
			placeId = p5.placeId,
			toolName = StudioAskUserTool.TOOL_NAME,
			planToolName = StudioProposePlanTool.TOOL_NAME,
			logsToolName = StudioClientLogsTool.TOOL_NAME
		})

		return {
			getOptimisticLocalTools = v26.getOptimisticLocalTools,
			getLocalToolActions = v26.getLocalToolActions,
			getSetupErrorText = function(p8) -- line: 133
				-- upvalues: u29 (ref)
				local v45 = u29.getSetupError(p8)

				if v45 ~= nil then
					if v45.message ~= nil and v45.message ~= "" then
						return v45.message
					end

					if v45.stage == "missing_project" then
						return "An experience is required to chat with the assistant."
					end

					if v45.stage == "session_new" then
						return "The assistant couldn't start a session. Please try again."
					end

					return "The assistant couldn't connect. Please try again."
				end

				return nil
			end,
			start = function() -- line: 146
				-- upvalues: u29 (ref)
				u29.start()
			end,
			stop = function() -- line: 152
				-- upvalues: v26 (copy), u29 (ref)
				v26.stopPending()
				u29.stop()
			end,
			syncFromTurnState = v26.syncFromTurnState,
			trySubmitComposerText = v26.trySubmitComposerText
		}
	end,
	createResumedAssistantTurn = function(p9, p10, p11: ((...any) -> ...any), n1: number?) -- line: 168
		-- upvalues: createLocalToolControllers (copy), Signals (copy)
		local v34 = createLocalToolControllers(p9)
		local v35 = Signals.createSignal(nil)
		local u36 = false
		local u37 = false
		local u38 = nil
		local u39 = nil

		local function finish() -- line: 188
			-- upvalues: u37 (ref), u39 (ref), u38 (ref), p11 (copy)
			if u37 then
				return
			end

			u37 = true

			if u39 ~= nil then
				u39()
				u39 = nil
			end

			if u38 ~= nil then
				u38()
				u38 = nil
			end

			p11(nil)
		end

		return {
			getOptimisticLocalTools = v34.getOptimisticLocalTools,
			getLocalToolActions = v34.getLocalToolActions,
			getSetupErrorText = v35,
			start = function() -- line: 206
				-- upvalues: u36 (ref), n1 (copy), u38 (ref), p9 (copy), u39 (ref), Signals (copy), p10 (copy), u37 (ref), p11 (copy)
				if u36 then
					return
				end

				u36 = true

				local t3 = {}

				if n1 ~= nil then
					t3.afterSequenceId = n1
				end

				u38 = p9.startPollingActiveTurn(t3)
				u39 = Signals.createEffect(function(p12) -- line: 217
					-- upvalues: p10 (copy), u37 (ref), u39 (ref), u38 (ref), p11 (copy)
					if p10.state(p12).isDone then
						if u37 then
							return
						end

						u37 = true

						if u39 ~= nil then
							u39()
							u39 = nil
						end

						if u38 ~= nil then
							u38()
							u38 = nil
						end

						p11(nil)
					end
				end)
			end,
			stop = function() -- line: 229
				-- upvalues: u37 (ref), u39 (ref), u38 (ref), v34 (copy), p10 (copy)
				u37 = true

				if u39 ~= nil then
					u39()
					u39 = nil
				end

				if u38 ~= nil then
					u38()
					u38 = nil
				end

				v34.stopPending()
				p10.cancel()
			end,
			syncFromTurnState = v34.syncFromTurnState,
			trySubmitComposerText = v34.trySubmitComposerText
		}
	end
}
