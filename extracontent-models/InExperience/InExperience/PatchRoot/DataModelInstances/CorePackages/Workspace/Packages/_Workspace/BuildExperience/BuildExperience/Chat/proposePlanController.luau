local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)
local composerLockSignal = require(script.Parent.composerLockSignal)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function buildOptimisticPlanTool(t1: {[any]: any}) -- line: 43
	return {
		toolCallId = t1.toolCallId,
		callOrder = t1.proposal.callOrder or 0,
		isAccepted = t1.proposal.isAccepted,
		feedbackText = t1.proposal.feedbackText
	}
end
local function createPlanProposalSync(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 52
	-- upvalues: StudioProposePlanTool (copy), debug (copy), composerLockSignal (copy), getToolCallOrder (copy)
	local u17 = nil
	local u18 = nil
	local u19 = false

	return function(p4) -- line: 61
		-- upvalues: StudioProposePlanTool (copy), p3 (copy), u19 (ref), debug (copy), u17 (ref), u18 (ref), p2 (copy), composerLockSignal (copy), getToolCallOrder (copy), p1 (copy)
		local v36, v37, v38, v39, v40 = StudioProposePlanTool.findPlanInTurnState(p4, p3())

		if v36 == nil or v37 == nil then
			if u19 then
				debug.log("info", "present_plan proposal cleared", {
					turn = debug.formatTurnState(p4)
				})
				u19 = false
				u17 = nil
				u18 = nil
				p2(nil)
				composerLockSignal.setComposerMode("normal")
			end

			return false
		end

		u19 = true

		if v37 ~= u17 or v38 ~= u18 then
			u17 = v37
			u18 = v38

			local t2 = {
				submitted = false,
				sessionId = p4.sessionId,
				toolCallId = v37,
				turnId = v39,
				referenceId = v40,
				proposal = {
					isAccepted = false,
					title = v36.title,
					textContent = v36.textContent,
					summary = v36.summary,
					toolCallId = v37,
					callOrder = getToolCallOrder(p4, v37)
				}
			}

			p2(t2)
			p1(t2.proposal)
			composerLockSignal.setComposerMode("tool_response")
			debug.log("info", "present_plan proposal displayed", {
				toolCallId = v37,
				turnId = v39,
				referenceId = v40,
				turn = debug.formatTurnState(p4)
			})
		end

		return true
	end
end
local function createProposePlanController(p5, t3: {[any]: any}, p6) -- line: 111
	-- upvalues: debug (copy), awaitRequestState (copy), chatConstants (copy), composerLockSignal (copy), StudioProposePlanTool (copy), getToolCallOrder (copy)
	local u23 = nil
	local u24 = nil

	local function setPlanFlow(t4: {[any]: any}?) -- line: 119
		-- upvalues: u23 (ref)
		u23 = t4
	end
	local function submitPlanResult(t5: {[any]: any}, t6: {[any]: any}, s1: string) -- line: 123
		-- upvalues: debug (copy), p5 (copy), awaitRequestState (copy), chatConstants (copy), t3 (copy), p6 (copy), u23 (ref), composerLockSignal (copy)
		debug.log("info", "present_plan tool_result submitting", {
			sessionId = t5.sessionId,
			toolCallId = t5.toolCallId,
			turnId = t5.turnId,
			referenceId = t5.referenceId,
			resultKind = s1
		})

		local elapsed = os.clock()
		local v47 = p5.submitActiveToolResult(t6, false, t5.turnId, t5.referenceId)

		if v47 == nil then
			debug.log("warn", "present_plan tool_result submit aborted (no active session)", {
				toolCallId = t5.toolCallId,
				resultKind = s1
			})
			t5.submitted = false

			return
		end

		local v48 = awaitRequestState(v47.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v49 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v48.status ~= "succeeded" then
			t5.submitted = false
			debug.log("warn", "present_plan tool_result submit failed", {
				sessionId = t5.sessionId,
				toolCallId = t5.toolCallId,
				turnId = t5.turnId,
				referenceId = t5.referenceId,
				durationMs = v49,
				state = debug.formatRequestState(v48),
				resultKind = s1
			})

			return
		end

		debug.log("info", "present_plan tool_result submitted", {
			sessionId = t5.sessionId,
			toolCallId = t5.toolCallId,
			turnId = t5.turnId,
			referenceId = t5.referenceId,
			durationMs = v49,
			resultKind = s1
		})
		t3[t5.toolCallId] = true
		p6.markSubmitted(t5.toolCallId)
		p6.removePlanAction(t5.toolCallId)
		u23 = nil
		composerLockSignal.setComposerMode("normal")
	end
	local function submitPlanAccepted(t7: {[any]: any}) -- line: 173
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy)
		submitPlanResult(t7, StudioProposePlanTool.formatAcceptedContent(), "accept")
	end
	local function submitPlanFeedback(t8: {[any]: any}, s2: string) -- line: 177
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy)
		submitPlanResult(t8, StudioProposePlanTool.formatFeedbackContent(s2), "feedback")
	end
	local function setCurrentPlanProposal(p7) -- line: 181
		-- upvalues: u23 (ref), p6 (copy), u24 (ref)
		if p7 ~= nil then
			local v54 = u23

			if v54 ~= nil then
				p6.setPlanTool({
					toolCallId = v54.toolCallId,
					callOrder = v54.proposal.callOrder or 0,
					isAccepted = v54.proposal.isAccepted,
					feedbackText = v54.proposal.feedbackText
				})
				p6.setPlanAction(v54.toolCallId, u24)
			end

			return
		end

		local v55 = u23

		if v55 ~= nil then
			p6.removePlanTool(v55.toolCallId)
			p6.removePlanAction(v55.toolCallId)
		end
	end
	local function getSubmittedToolCallIds() -- line: 198
		-- upvalues: t3 (copy)
		return t3
	end

	local u31 = nil
	local u32 = nil
	local u33 = false

	local function onPlanAcceptedImpl() -- line: 203
		-- upvalues: u23 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
		local v63 = u23

		if v63 == nil or v63.submitted then
			return
		end

		v63.submitted = true
		v63.proposal = {
			isAccepted = true,
			feedbackText = nil,
			title = v63.proposal.title,
			textContent = v63.proposal.textContent,
			summary = v63.proposal.summary,
			toolCallId = v63.proposal.toolCallId,
			callOrder = v63.proposal.callOrder
		}
		setCurrentPlanProposal(v63.proposal)
		task.spawn(function() -- line: 220
			-- upvalues: v63 (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
			local v67 = v63

			submitPlanResult(v67, StudioProposePlanTool.formatAcceptedContent(), "accept")
		end)
	end

	u24 = onPlanAcceptedImpl

	return {
		syncPlanProposal = function(p8) -- line: 61
			-- upvalues: StudioProposePlanTool (copy), getSubmittedToolCallIds (copy), u33 (ref), debug (copy), u31 (ref), u32 (ref), setPlanFlow (copy), composerLockSignal (copy), getToolCallOrder (copy), setCurrentPlanProposal (copy)
			local v57, v58, v59, v60, v61 = StudioProposePlanTool.findPlanInTurnState(p8, getSubmittedToolCallIds())

			if v57 == nil or v58 == nil then
				if u33 then
					debug.log("info", "present_plan proposal cleared", {
						turn = debug.formatTurnState(p8)
					})
					u33 = false
					u31 = nil
					u32 = nil
					setPlanFlow(nil)
					composerLockSignal.setComposerMode("normal")
				end

				return false
			end

			u33 = true

			if v58 ~= u31 or v59 ~= u32 then
				u31 = v58
				u32 = v59

				local t9 = {
					submitted = false,
					sessionId = p8.sessionId,
					toolCallId = v58,
					turnId = v60,
					referenceId = v61,
					proposal = {
						isAccepted = false,
						title = v57.title,
						textContent = v57.textContent,
						summary = v57.summary,
						toolCallId = v58,
						callOrder = getToolCallOrder(p8, v58)
					}
				}

				setPlanFlow(t9)
				setCurrentPlanProposal(t9.proposal)
				composerLockSignal.setComposerMode("tool_response")
				debug.log("info", "present_plan proposal displayed", {
					toolCallId = v58,
					turnId = v60,
					referenceId = v61,
					turn = debug.formatTurnState(p8)
				})
			end

			return true
		end,
		stopPendingPlan = function() -- line: 250
			-- upvalues: u23 (ref), p6 (copy), composerLockSignal (copy)
			local v66 = u23

			if v66 == nil or v66.submitted then
				return false
			end

			v66.submitted = true
			u23 = nil
			p6.removePlanTool(v66.toolCallId)
			p6.removePlanAction(v66.toolCallId)
			composerLockSignal.setComposerMode("normal")

			return true
		end,
		trySubmitComposerText = function(s3: string) -- line: 226
			-- upvalues: u23 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
			local v65 = u23

			if v65 == nil or v65.submitted then
				return false
			end

			v65.submitted = true
			v65.proposal = {
				isAccepted = false,
				title = v65.proposal.title,
				textContent = v65.proposal.textContent,
				summary = v65.proposal.summary,
				toolCallId = v65.proposal.toolCallId,
				callOrder = v65.proposal.callOrder,
				feedbackText = s3
			}
			setCurrentPlanProposal(v65.proposal)
			task.spawn(function() -- line: 244
				-- upvalues: v65 (copy), s3 (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
				local v68 = v65
				local v69 = s3

				submitPlanResult(v68, StudioProposePlanTool.formatFeedbackContent(v69), "feedback")
			end)

			return true
		end
	}
end

return createProposePlanController
