local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)
local chatConstants = require(script.Parent.chatConstants)
require(script.Parent.localToolOverlay)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function buildOptimisticPlanTool(p) -- 2 equivalent calls inferred from this helper
	return {
		toolCallId = p.toolCallId,
		callOrder = p.proposal.callOrder or 0,
		isAccepted = p.proposal.isAccepted,
		feedbackText = p.proposal.feedbackText
	}
end

local function createPlanProposalSync(setCurrentPlanProposal, setPlanFlow, getSubmittedToolCallIds) -- 1 equivalent call inferred from this helper
	local v = nil
	local v2 = nil
	local v3 = false

	return function(p): boolean
		local planInTurnState, toolCallId, v4, turnId, referenceId = StudioProposePlanTool.findPlanInTurnState(
			p,
			getSubmittedToolCallIds()
		)

		if planInTurnState == nil or toolCallId == nil then
			if not v3 then
				return false
			end

			Debug.log("info", "present_plan proposal cleared", { turn = Debug.formatTurnState(p) })

			v3 = false
			v = nil
			v2 = nil
			setCurrentPlanProposal(nil)
			setPlanFlow(nil)

			return false
		else
			v3 = true

			if toolCallId == v and v4 == v2 then
				return true
			end

			v = toolCallId
			v2 = v4
			local v5 = {
				sessionId = p.sessionId,
				toolCallId = toolCallId,
				turnId = turnId,
				referenceId = referenceId,
				proposal = {
					title = planInTurnState.title,
					textContent = planInTurnState.textContent,
					summary = planInTurnState.summary,
					toolCallId = toolCallId,
					callOrder = getToolCallOrder(p, toolCallId),
					isAccepted = false
				},
				submitted = false
			}

			setPlanFlow(v5)
			setCurrentPlanProposal(v5.proposal)
			Debug.log("info", "present_plan proposal displayed", {
				toolCallId = toolCallId,
				turnId = turnId,
				referenceId = referenceId,
				turn = Debug.formatTurnState(p)
			})

			return true
		end
	end
end

local function createProposePlanController(p, submittedToolCallIds, data, callback)
	local v = nil
	local v2 = nil

	local function setPlanFlow(p2) -- 2 equivalent calls inferred from this helper
		v = p2
	end

	local function recoverFailedSubmission(data2, p2: string?, p3: number?)
		data2.submitted = false

		if callback == nil then
			return
		end

		data2.proposal = {
			title = data2.proposal.title,
			textContent = data2.proposal.textContent,
			summary = data2.proposal.summary,
			toolCallId = data2.proposal.toolCallId,
			callOrder = data2.proposal.callOrder,
			isAccepted = false,
			feedbackText = nil
		}

		data.setPlanTool(buildOptimisticPlanTool(data2)) -- inferred equivalent call
		callback(p2, p3)
	end

	local function submitPlanResult(data2, p2, resultKind: string, p3: string?)
		Debug.log("info", "present_plan tool_result submitting", {
			sessionId = data2.sessionId,
			toolCallId = data2.toolCallId,
			turnId = data2.turnId,
			referenceId = data2.referenceId,
			resultKind = resultKind
		})

		local lastTime = os.clock()
		local submitActiveToolResult = p.submitActiveToolResult(p2, false, data2.turnId, data2.referenceId)

		if submitActiveToolResult == nil then
			Debug.log("warn", "present_plan tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId,
				resultKind = resultKind
			})

			recoverFailedSubmission(data2, p3, nil)
		else
			local v3 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)
			local durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v3.status == "succeeded" then
				Debug.log("info", "present_plan tool_result submitted", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = durationMs,
					resultKind = resultKind
				})

				submittedToolCallIds[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)
				data.removePlanAction(data2.toolCallId)
				setPlanFlow(nil) -- inferred equivalent call
			else
				recoverFailedSubmission(data2, p3, v3.errorCode)
				Debug.log("warn", "present_plan tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = durationMs,
					state = Debug.formatRequestState(v3),
					resultKind = resultKind
				})
			end
		end
	end

	local function submitPlanAccepted(p2) -- 1 equivalent call inferred from this helper
		submitPlanResult(p2, StudioProposePlanTool.formatAcceptedContent(), "accept", nil)
	end

	local function submitPlanFeedback(p2, p3: string) -- 1 equivalent call inferred from this helper
		submitPlanResult(p2, StudioProposePlanTool.formatFeedbackContent(p3), "feedback", p3)
	end

	local function setCurrentPlanProposal(proposal)
		if proposal == nil then
			local v3 = v

			if v3 ~= nil then
				data.removePlanTool(v3.toolCallId)
				data.removePlanAction(v3.toolCallId)
			end
		else
			local v3 = v

			if v3 ~= nil then
				data.setPlanTool(buildOptimisticPlanTool(v3)) -- inferred equivalent call
				data.setPlanAction(v3.toolCallId, v2)
			end
		end
	end

	local function getSubmittedToolCallIds()
		return submittedToolCallIds
	end

	local planProposalSync = createPlanProposalSync(setCurrentPlanProposal, setPlanFlow, getSubmittedToolCallIds) -- inferred equivalent call

	local function onPlanAcceptedImpl()
		local v3 = v

		if v3 == nil or v3.submitted then
			return
		end

		v3.submitted = true
		v3.proposal = {
			title = v3.proposal.title,
			textContent = v3.proposal.textContent,
			summary = v3.proposal.summary,
			toolCallId = v3.proposal.toolCallId,
			callOrder = v3.proposal.callOrder,
			isAccepted = true,
			feedbackText = nil
		}

		setCurrentPlanProposal(v3.proposal)
		task.spawn(function()
			submitPlanAccepted(v3) -- inferred equivalent call
		end)
	end
	v2 = onPlanAcceptedImpl

	local function trySubmitComposerText(feedbackText: string): boolean
		local v3 = v

		if v3 == nil or v3.submitted then
			return false
		end

		v3.submitted = true
		v3.proposal = {
			title = v3.proposal.title,
			textContent = v3.proposal.textContent,
			summary = v3.proposal.summary,
			toolCallId = v3.proposal.toolCallId,
			callOrder = v3.proposal.callOrder,
			isAccepted = false,
			feedbackText = feedbackText
		}

		setCurrentPlanProposal(v3.proposal)
		task.spawn(function()
			submitPlanFeedback(v3, feedbackText) -- inferred equivalent call
		end)
		return true
	end

	local function stopPendingPlan(): boolean
		local v3 = v

		if v3 == nil or v3.submitted then
			return false
		end

		v3.submitted = true
		setPlanFlow(nil) -- inferred equivalent call
		data.removePlanTool(v3.toolCallId)
		data.removePlanAction(v3.toolCallId)
		return true
	end

	return {
		syncPlanProposal = planProposalSync,
		stopPendingPlan = stopPendingPlan,
		trySubmitComposerText = trySubmitComposerText
	}
end

return createProposePlanController
