local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local FFlagBuildExperienceToolResultFailureRecovery = require(BuildExperience.Flags.FFlagBuildExperienceToolResultFailureRecovery)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function buildOptimisticPlanTool(t1: {[any]: any}) -- line: 44
	return {
		toolCallId = t1.toolCallId,
		callOrder = t1.proposal.callOrder or 0,
		isAccepted = t1.proposal.isAccepted,
		feedbackText = t1.proposal.feedbackText
	}
end
local function createPlanProposalSync(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 53
	-- upvalues: StudioProposePlanTool (copy), debug (copy), getToolCallOrder (copy)
	local u18 = nil
	local u19 = nil
	local u20 = false

	return function(p4) -- line: 62
		-- upvalues: StudioProposePlanTool (copy), p3 (copy), u20 (ref), debug (copy), u18 (ref), u19 (ref), p1 (copy), p2 (copy), getToolCallOrder (copy)
		local v39, v40, v41, v42, v43 = StudioProposePlanTool.findPlanInTurnState(p4, p3())

		if v39 == nil or v40 == nil then
			if u20 then
				debug.log("info", "present_plan proposal cleared", {
					turn = debug.formatTurnState(p4)
				})
				u20 = false
				u18 = nil
				u19 = nil
				p1(nil)
				p2(nil)
			end

			return false
		end

		u20 = true

		if v40 ~= u18 or v41 ~= u19 then
			u18 = v40
			u19 = v41

			local t2 = {
				submitted = false,
				sessionId = p4.sessionId,
				toolCallId = v40,
				turnId = v42,
				referenceId = v43,
				proposal = {
					isAccepted = false,
					title = v39.title,
					textContent = v39.textContent,
					summary = v39.summary,
					toolCallId = v40,
					callOrder = getToolCallOrder(p4, v40)
				}
			}

			p2(t2)
			p1(t2.proposal)
			debug.log("info", "present_plan proposal displayed", {
				toolCallId = v40,
				turnId = v42,
				referenceId = v43,
				turn = debug.formatTurnState(p4)
			})
		end

		return true
	end
end
local function createProposePlanController(p5, t3: {[any]: any}, p6, p7) -- line: 111
	-- upvalues: debug (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), awaitRequestState (copy), chatConstants (copy), StudioProposePlanTool (copy), getToolCallOrder (copy)
	local u25 = nil
	local u26 = nil

	local function setPlanFlow(t4: {[any]: any}?) -- line: 120
		-- upvalues: u25 (ref)
		u25 = t4
	end
	local function recoverFailedSubmission(t5: {[any]: any}, s1: string?, n1: number?) -- line: 124
		-- upvalues: p7 (copy), p6 (copy)
		t5.submitted = false

		if p7 == nil then
			return
		end

		t5.proposal = {
			isAccepted = false,
			feedbackText = nil,
			title = t5.proposal.title,
			textContent = t5.proposal.textContent,
			summary = t5.proposal.summary,
			toolCallId = t5.proposal.toolCallId,
			callOrder = t5.proposal.callOrder
		}
		p6.setPlanTool({
			toolCallId = t5.toolCallId,
			callOrder = t5.proposal.callOrder or 0,
			isAccepted = t5.proposal.isAccepted,
			feedbackText = t5.proposal.feedbackText
		})
		p7(s1, n1)
	end
	local function submitPlanResult(t6: {[any]: any}, t7: {[any]: any}, s2: string, s3: string?) -- line: 143
		-- upvalues: debug (copy), p5 (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), recoverFailedSubmission (copy), awaitRequestState (copy), chatConstants (copy), t3 (copy), p6 (copy), u25 (ref)
		debug.log("info", "present_plan tool_result submitting", {
			sessionId = t6.sessionId,
			toolCallId = t6.toolCallId,
			turnId = t6.turnId,
			referenceId = t6.referenceId,
			resultKind = s2
		})

		local elapsed = os.clock()
		local v54 = p5.submitActiveToolResult(t7, false, t6.turnId, t6.referenceId)

		if v54 == nil then
			debug.log("warn", "present_plan tool_result submit aborted (no active session)", {
				toolCallId = t6.toolCallId,
				resultKind = s2
			})

			if FFlagBuildExperienceToolResultFailureRecovery then
				recoverFailedSubmission(t6, s3, nil)

				return
			end

			t6.submitted = false

			return
		end

		local v55 = awaitRequestState(v54.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v56 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v55.status ~= "succeeded" then
			if FFlagBuildExperienceToolResultFailureRecovery then
				recoverFailedSubmission(t6, s3, v55.errorCode)
			else
				t6.submitted = false
			end

			debug.log("warn", "present_plan tool_result submit failed", {
				sessionId = t6.sessionId,
				toolCallId = t6.toolCallId,
				turnId = t6.turnId,
				referenceId = t6.referenceId,
				durationMs = v56,
				state = debug.formatRequestState(v55),
				resultKind = s2
			})

			return
		end

		debug.log("info", "present_plan tool_result submitted", {
			sessionId = t6.sessionId,
			toolCallId = t6.toolCallId,
			turnId = t6.turnId,
			referenceId = t6.referenceId,
			durationMs = v56,
			resultKind = s2
		})
		t3[t6.toolCallId] = true
		p6.markSubmitted(t6.toolCallId)
		p6.removePlanAction(t6.toolCallId)
		u25 = nil
	end
	local function submitPlanAccepted(t8: {[any]: any}) -- line: 205
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy)
		submitPlanResult(t8, StudioProposePlanTool.formatAcceptedContent(), "accept", nil)
	end
	local function submitPlanFeedback(t9: {[any]: any}, s4: string) -- line: 209
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy), FFlagBuildExperienceToolResultFailureRecovery (copy)
		submitPlanResult(t9, StudioProposePlanTool.formatFeedbackContent(s4), "feedback", if not FFlagBuildExperienceToolResultFailureRecovery then nil else s4)
	end
	local function setCurrentPlanProposal(p8) -- line: 218
		-- upvalues: u25 (ref), p6 (copy), u26 (ref)
		if p8 ~= nil then
			local v61 = u25

			if v61 ~= nil then
				p6.setPlanTool({
					toolCallId = v61.toolCallId,
					callOrder = v61.proposal.callOrder or 0,
					isAccepted = v61.proposal.isAccepted,
					feedbackText = v61.proposal.feedbackText
				})
				p6.setPlanAction(v61.toolCallId, u26)
			end

			return
		end

		local v62 = u25

		if v62 ~= nil then
			p6.removePlanTool(v62.toolCallId)
			p6.removePlanAction(v62.toolCallId)
		end
	end
	local function getSubmittedToolCallIds() -- line: 235
		-- upvalues: t3 (copy)
		return t3
	end

	local u34 = nil
	local u35 = nil
	local u36 = false

	local function onPlanAcceptedImpl() -- line: 240
		-- upvalues: u25 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
		local v70 = u25

		if v70 == nil or v70.submitted then
			return
		end

		v70.submitted = true
		v70.proposal = {
			isAccepted = true,
			feedbackText = nil,
			title = v70.proposal.title,
			textContent = v70.proposal.textContent,
			summary = v70.proposal.summary,
			toolCallId = v70.proposal.toolCallId,
			callOrder = v70.proposal.callOrder
		}
		setCurrentPlanProposal(v70.proposal)
		task.spawn(function() -- line: 257
			-- upvalues: v70 (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
			local v74 = v70

			submitPlanResult(v74, StudioProposePlanTool.formatAcceptedContent(), "accept", nil)
		end)
	end

	u26 = onPlanAcceptedImpl

	return {
		syncPlanProposal = function(p9) -- line: 62
			-- upvalues: StudioProposePlanTool (copy), getSubmittedToolCallIds (copy), u36 (ref), debug (copy), u34 (ref), u35 (ref), setCurrentPlanProposal (copy), setPlanFlow (copy), getToolCallOrder (copy)
			local v64, v65, v66, v67, v68 = StudioProposePlanTool.findPlanInTurnState(p9, getSubmittedToolCallIds())

			if v64 == nil or v65 == nil then
				if u36 then
					debug.log("info", "present_plan proposal cleared", {
						turn = debug.formatTurnState(p9)
					})
					u36 = false
					u34 = nil
					u35 = nil
					setCurrentPlanProposal(nil)
					setPlanFlow(nil)
				end

				return false
			end

			u36 = true

			if v65 ~= u34 or v66 ~= u35 then
				u34 = v65
				u35 = v66

				local t10 = {
					submitted = false,
					sessionId = p9.sessionId,
					toolCallId = v65,
					turnId = v67,
					referenceId = v68,
					proposal = {
						isAccepted = false,
						title = v64.title,
						textContent = v64.textContent,
						summary = v64.summary,
						toolCallId = v65,
						callOrder = getToolCallOrder(p9, v65)
					}
				}

				setPlanFlow(t10)
				setCurrentPlanProposal(t10.proposal)
				debug.log("info", "present_plan proposal displayed", {
					toolCallId = v65,
					turnId = v67,
					referenceId = v68,
					turn = debug.formatTurnState(p9)
				})
			end

			return true
		end,
		stopPendingPlan = function() -- line: 287
			-- upvalues: u25 (ref), p6 (copy)
			local v73 = u25

			if v73 == nil or v73.submitted then
				return false
			end

			v73.submitted = true
			u25 = nil
			p6.removePlanTool(v73.toolCallId)
			p6.removePlanAction(v73.toolCallId)

			return true
		end,
		trySubmitComposerText = function(s5: string) -- line: 263
			-- upvalues: u25 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy), FFlagBuildExperienceToolResultFailureRecovery (copy)
			local v72 = u25

			if v72 == nil or v72.submitted then
				return false
			end

			v72.submitted = true
			v72.proposal = {
				isAccepted = false,
				title = v72.proposal.title,
				textContent = v72.proposal.textContent,
				summary = v72.proposal.summary,
				toolCallId = v72.proposal.toolCallId,
				callOrder = v72.proposal.callOrder,
				feedbackText = s5
			}
			setCurrentPlanProposal(v72.proposal)
			task.spawn(function() -- line: 281
				-- upvalues: v72 (copy), s5 (copy), submitPlanResult (copy), StudioProposePlanTool (copy), FFlagBuildExperienceToolResultFailureRecovery (copy)
				local v75 = v72
				local v76 = s5

				submitPlanResult(v75, StudioProposePlanTool.formatFeedbackContent(v76), "feedback", if not FFlagBuildExperienceToolResultFailureRecovery then nil else v76)
			end)

			return true
		end
	}
end

return createProposePlanController
