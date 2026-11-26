local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local studioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function buildOptimisticPlanTool(p2)
	return {
		toolCallId = p2.toolCallId,
		callOrder = p2.proposal.callOrder or 0,
		isAccepted = p2.proposal.isAccepted,
		feedbackText = p2.proposal.feedbackText
	}
end

local function createPlanProposalSync(callback, callback2, callback3)
	local v5 = nil
	local v6 = nil
	local v7 = false

	return function(p2): boolean
		local planInTurnState, v8, v9, v10, v11 = studioProposePlanTool.findPlanInTurnState(p2, callback3())

		if planInTurnState == nil or v8 == nil then
			if not v7 then
				return false
			end

			Debug.log("info", "present_plan proposal cleared", {
				turn = Debug.formatTurnState(p2)
			})

			v7 = false
			v5 = nil
			v6 = nil
			callback(nil)
			callback2(nil)

			return false
		else
			v7 = true

			if v8 == v5 and v9 == v6 then
				return true
			end

			v5 = v8
			v6 = v9
			local v12 = {
				sessionId = p2.sessionId,
				toolCallId = v8,
				turnId = v10,
				referenceId = v11,
				proposal = {
					title = planInTurnState.title,
					textContent = planInTurnState.textContent,
					summary = planInTurnState.summary,
					toolCallId = v8,
					callOrder = getToolCallOrder(p2, v8),
					isAccepted = false
				},
				submitted = false
			}

			callback2(v12)
			callback(v12.proposal)
			Debug.log("info", "present_plan proposal displayed", {
				toolCallId = v8,
				turnId = v10,
				referenceId = v11,
				turn = Debug.formatTurnState(p2)
			})

			return true
		end
	end
end

local function createProposePlanController(p2, submittedToolCallIds, data, callback)
	local v5 = nil
	local v6 = nil

	local function setPlanFlow(p3)
		v5 = p3
	end

	local function recoverFailedSubmission(state, p3, p4)
		state.submitted = false

		if callback == nil then
			return
		end

		state.proposal = {
			title = state.proposal.title,
			textContent = state.proposal.textContent,
			summary = state.proposal.summary,
			toolCallId = state.proposal.toolCallId,
			callOrder = state.proposal.callOrder,
			isAccepted = false,
			feedbackText = nil
		}
		data.setPlanTool({
			toolCallId = state.toolCallId,
			callOrder = state.proposal.callOrder or 0,
			isAccepted = state.proposal.isAccepted,
			feedbackText = state.proposal.feedbackText
		})
		callback(p3, p4)
	end

	local function submitPlanResult(data2, p3, p4, p5)
		Debug.log("info", "present_plan tool_result submitting", {
			sessionId = data2.sessionId,
			toolCallId = data2.toolCallId,
			turnId = data2.turnId,
			referenceId = data2.referenceId,
			resultKind = p4
		})

		local lastTime = os.clock()
		local submitActiveToolResult = p2.submitActiveToolResult(p3, false, data2.turnId, data2.referenceId)

		if submitActiveToolResult == nil then
			Debug.log("warn", "present_plan tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId,
				resultKind = p4
			})

			recoverFailedSubmission(data2, p5, nil)
		else
			local v7 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)
			local v8 = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v7.status == "succeeded" then
				Debug.log("info", "present_plan tool_result submitted", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = v8,
					resultKind = p4
				})

				submittedToolCallIds[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)
				data.removePlanAction(data2.toolCallId)
				v5 = nil
			else
				recoverFailedSubmission(data2, p5, v7.errorCode)
				Debug.log("warn", "present_plan tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = v8,
					state = Debug.formatRequestState(v7),
					resultKind = p4
				})
			end
		end
	end

	local function submitPlanAccepted(p3)
		submitPlanResult(p3, studioProposePlanTool.formatAcceptedContent(), "accept", nil)
	end

	local function submitPlanFeedback(p3, p4)
		submitPlanResult(p3, studioProposePlanTool.formatFeedbackContent(p4), "feedback", p4)
	end

	local function setCurrentPlanProposal(p3)
		if p3 == nil then
			local v7 = v5

			if v7 ~= nil then
				data.removePlanTool(v7.toolCallId)
				data.removePlanAction(v7.toolCallId)
			end
		else
			local v7 = v5

			if v7 ~= nil then
				data.setPlanTool({
					toolCallId = v7.toolCallId,
					callOrder = v7.proposal.callOrder or 0,
					isAccepted = v7.proposal.isAccepted,
					feedbackText = v7.proposal.feedbackText
				})
				data.setPlanAction(v7.toolCallId, v6)
			end
		end
	end

	local function getSubmittedToolCallIds()
		return submittedToolCallIds
	end

	local v7 = nil
	local v8 = nil
	local v9 = false

	local function fn(p3): boolean
		local planInTurnState, v10, v11, v12, v13 = studioProposePlanTool.findPlanInTurnState(
			p3,
			getSubmittedToolCallIds()
		)

		if planInTurnState == nil or v10 == nil then
			if not v9 then
				return false
			end

			Debug.log("info", "present_plan proposal cleared", {
				turn = Debug.formatTurnState(p3)
			})

			v9 = false
			v7 = nil
			v8 = nil
			setCurrentPlanProposal(nil)
			setPlanFlow(nil)

			return false
		else
			v9 = true

			if v10 == v7 and v11 == v8 then
				return true
			end

			v7 = v10
			v8 = v11
			local v14 = {
				sessionId = p3.sessionId,
				toolCallId = v10,
				turnId = v12,
				referenceId = v13,
				proposal = {
					title = planInTurnState.title,
					textContent = planInTurnState.textContent,
					summary = planInTurnState.summary,
					toolCallId = v10,
					callOrder = getToolCallOrder(p3, v10),
					isAccepted = false
				},
				submitted = false
			}

			setPlanFlow(v14)
			setCurrentPlanProposal(v14.proposal)
			Debug.log("info", "present_plan proposal displayed", {
				toolCallId = v10,
				turnId = v12,
				referenceId = v13,
				turn = Debug.formatTurnState(p3)
			})

			return true
		end
	end

	local function onPlanAcceptedImpl()
		local v10 = v5

		if v10 == nil or v10.submitted then
			return
		end

		v10.submitted = true
		v10.proposal = {
			title = v10.proposal.title,
			textContent = v10.proposal.textContent,
			summary = v10.proposal.summary,
			toolCallId = v10.proposal.toolCallId,
			callOrder = v10.proposal.callOrder,
			isAccepted = true,
			feedbackText = nil
		}

		setCurrentPlanProposal(v10.proposal)
		task.spawn(function()
			submitPlanResult(v10, studioProposePlanTool.formatAcceptedContent(), "accept", nil)
		end)
	end
	v6 = onPlanAcceptedImpl

	local function trySubmitComposerText(p3): boolean
		local v10 = v5

		if v10 == nil or v10.submitted then
			return false
		end

		v10.submitted = true
		v10.proposal = {
			title = v10.proposal.title,
			textContent = v10.proposal.textContent,
			summary = v10.proposal.summary,
			toolCallId = v10.proposal.toolCallId,
			callOrder = v10.proposal.callOrder,
			isAccepted = false,
			feedbackText = p3
		}

		setCurrentPlanProposal(v10.proposal)
		task.spawn(function()
			local v11 = p3
			submitPlanResult(v10, studioProposePlanTool.formatFeedbackContent(v11), "feedback", v11)
		end)
		return true
	end

	local function stopPendingPlan(): boolean
		local v10 = v5

		if v10 == nil or v10.submitted then
			return false
		end

		v10.submitted = true
		v5 = nil

		data.removePlanTool(v10.toolCallId)
		data.removePlanAction(v10.toolCallId)
		return true
	end

	return {
		syncPlanProposal = fn,
		stopPendingPlan = stopPendingPlan,
		trySubmitComposerText = trySubmitComposerText
	}
end

return createProposePlanController
