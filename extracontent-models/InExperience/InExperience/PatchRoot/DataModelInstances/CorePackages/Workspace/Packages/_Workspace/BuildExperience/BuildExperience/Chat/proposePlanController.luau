local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function buildOptimisticPlanTool(t1: {[any]: any}) -- line: 42
	return {
		toolCallId = t1.toolCallId,
		callOrder = t1.proposal.callOrder or 0,
		isAccepted = t1.proposal.isAccepted,
		feedbackText = t1.proposal.feedbackText
	}
end
local function createPlanProposalSync(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 51
	-- upvalues: StudioProposePlanTool (copy), debug (copy), getToolCallOrder (copy)
	local u16 = nil
	local u17 = nil
	local u18 = false

	return function(p4) -- line: 60
		-- upvalues: StudioProposePlanTool (copy), p3 (copy), u18 (ref), debug (copy), u16 (ref), u17 (ref), p1 (copy), p2 (copy), getToolCallOrder (copy)
		local v35, v36, v37, v38, v39 = StudioProposePlanTool.findPlanInTurnState(p4, p3())

		if v35 == nil or v36 == nil then
			if u18 then
				debug.log("info", "present_plan proposal cleared", {
					turn = debug.formatTurnState(p4)
				})
				u18 = false
				u16 = nil
				u17 = nil
				p1(nil)
				p2(nil)
			end

			return false
		end

		u18 = true

		if v36 ~= u16 or v37 ~= u17 then
			u16 = v36
			u17 = v37

			local t2 = {
				submitted = false,
				sessionId = p4.sessionId,
				toolCallId = v36,
				turnId = v38,
				referenceId = v39,
				proposal = {
					isAccepted = false,
					title = v35.title,
					textContent = v35.textContent,
					summary = v35.summary,
					toolCallId = v36,
					callOrder = getToolCallOrder(p4, v36)
				}
			}

			p2(t2)
			p1(t2.proposal)
			debug.log("info", "present_plan proposal displayed", {
				toolCallId = v36,
				turnId = v38,
				referenceId = v39,
				turn = debug.formatTurnState(p4)
			})
		end

		return true
	end
end
local function createProposePlanController(p5, t3: {[any]: any}, p6) -- line: 109
	-- upvalues: debug (copy), awaitRequestState (copy), chatConstants (copy), StudioProposePlanTool (copy), getToolCallOrder (copy)
	local u22 = nil
	local u23 = nil

	local function setPlanFlow(t4: {[any]: any}?) -- line: 117
		-- upvalues: u22 (ref)
		u22 = t4
	end
	local function submitPlanResult(t5: {[any]: any}, t6: {[any]: any}, s1: string) -- line: 121
		-- upvalues: debug (copy), p5 (copy), awaitRequestState (copy), chatConstants (copy), t3 (copy), p6 (copy), u22 (ref)
		debug.log("info", "present_plan tool_result submitting", {
			sessionId = t5.sessionId,
			toolCallId = t5.toolCallId,
			turnId = t5.turnId,
			referenceId = t5.referenceId,
			resultKind = s1
		})

		local elapsed = os.clock()
		local v46 = p5.submitActiveToolResult(t6, false, t5.turnId, t5.referenceId)

		if v46 == nil then
			debug.log("warn", "present_plan tool_result submit aborted (no active session)", {
				toolCallId = t5.toolCallId,
				resultKind = s1
			})
			t5.submitted = false

			return
		end

		local v47 = awaitRequestState(v46.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v48 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v47.status ~= "succeeded" then
			t5.submitted = false
			debug.log("warn", "present_plan tool_result submit failed", {
				sessionId = t5.sessionId,
				toolCallId = t5.toolCallId,
				turnId = t5.turnId,
				referenceId = t5.referenceId,
				durationMs = v48,
				state = debug.formatRequestState(v47),
				resultKind = s1
			})

			return
		end

		debug.log("info", "present_plan tool_result submitted", {
			sessionId = t5.sessionId,
			toolCallId = t5.toolCallId,
			turnId = t5.turnId,
			referenceId = t5.referenceId,
			durationMs = v48,
			resultKind = s1
		})
		t3[t5.toolCallId] = true
		p6.markSubmitted(t5.toolCallId)
		p6.removePlanAction(t5.toolCallId)
		u22 = nil
	end
	local function submitPlanAccepted(t7: {[any]: any}) -- line: 170
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy)
		submitPlanResult(t7, StudioProposePlanTool.formatAcceptedContent(), "accept")
	end
	local function submitPlanFeedback(t8: {[any]: any}, s2: string) -- line: 174
		-- upvalues: submitPlanResult (copy), StudioProposePlanTool (copy)
		submitPlanResult(t8, StudioProposePlanTool.formatFeedbackContent(s2), "feedback")
	end
	local function setCurrentPlanProposal(p7) -- line: 178
		-- upvalues: u22 (ref), p6 (copy), u23 (ref)
		if p7 ~= nil then
			local v53 = u22

			if v53 ~= nil then
				p6.setPlanTool({
					toolCallId = v53.toolCallId,
					callOrder = v53.proposal.callOrder or 0,
					isAccepted = v53.proposal.isAccepted,
					feedbackText = v53.proposal.feedbackText
				})
				p6.setPlanAction(v53.toolCallId, u23)
			end

			return
		end

		local v54 = u22

		if v54 ~= nil then
			p6.removePlanTool(v54.toolCallId)
			p6.removePlanAction(v54.toolCallId)
		end
	end
	local function getSubmittedToolCallIds() -- line: 195
		-- upvalues: t3 (copy)
		return t3
	end

	local u30 = nil
	local u31 = nil
	local u32 = false

	local function onPlanAcceptedImpl() -- line: 200
		-- upvalues: u22 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
		local v62 = u22

		if v62 == nil or v62.submitted then
			return
		end

		v62.submitted = true
		v62.proposal = {
			isAccepted = true,
			feedbackText = nil,
			title = v62.proposal.title,
			textContent = v62.proposal.textContent,
			summary = v62.proposal.summary,
			toolCallId = v62.proposal.toolCallId,
			callOrder = v62.proposal.callOrder
		}
		setCurrentPlanProposal(v62.proposal)
		task.spawn(function() -- line: 217
			-- upvalues: v62 (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
			local v66 = v62

			submitPlanResult(v66, StudioProposePlanTool.formatAcceptedContent(), "accept")
		end)
	end

	u23 = onPlanAcceptedImpl

	return {
		syncPlanProposal = function(p8) -- line: 60
			-- upvalues: StudioProposePlanTool (copy), getSubmittedToolCallIds (copy), u32 (ref), debug (copy), u30 (ref), u31 (ref), setCurrentPlanProposal (copy), setPlanFlow (copy), getToolCallOrder (copy)
			local v56, v57, v58, v59, v60 = StudioProposePlanTool.findPlanInTurnState(p8, getSubmittedToolCallIds())

			if v56 == nil or v57 == nil then
				if u32 then
					debug.log("info", "present_plan proposal cleared", {
						turn = debug.formatTurnState(p8)
					})
					u32 = false
					u30 = nil
					u31 = nil
					setCurrentPlanProposal(nil)
					setPlanFlow(nil)
				end

				return false
			end

			u32 = true

			if v57 ~= u30 or v58 ~= u31 then
				u30 = v57
				u31 = v58

				local t9 = {
					submitted = false,
					sessionId = p8.sessionId,
					toolCallId = v57,
					turnId = v59,
					referenceId = v60,
					proposal = {
						isAccepted = false,
						title = v56.title,
						textContent = v56.textContent,
						summary = v56.summary,
						toolCallId = v57,
						callOrder = getToolCallOrder(p8, v57)
					}
				}

				setPlanFlow(t9)
				setCurrentPlanProposal(t9.proposal)
				debug.log("info", "present_plan proposal displayed", {
					toolCallId = v57,
					turnId = v59,
					referenceId = v60,
					turn = debug.formatTurnState(p8)
				})
			end

			return true
		end,
		stopPendingPlan = function() -- line: 247
			-- upvalues: u22 (ref), p6 (copy)
			local v65 = u22

			if v65 == nil or v65.submitted then
				return false
			end

			v65.submitted = true
			u22 = nil
			p6.removePlanTool(v65.toolCallId)
			p6.removePlanAction(v65.toolCallId)

			return true
		end,
		trySubmitComposerText = function(s3: string) -- line: 223
			-- upvalues: u22 (ref), setCurrentPlanProposal (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
			local v64 = u22

			if v64 == nil or v64.submitted then
				return false
			end

			v64.submitted = true
			v64.proposal = {
				isAccepted = false,
				title = v64.proposal.title,
				textContent = v64.proposal.textContent,
				summary = v64.proposal.summary,
				toolCallId = v64.proposal.toolCallId,
				callOrder = v64.proposal.callOrder,
				feedbackText = s3
			}
			setCurrentPlanProposal(v64.proposal)
			task.spawn(function() -- line: 241
				-- upvalues: v64 (copy), s3 (copy), submitPlanResult (copy), StudioProposePlanTool (copy)
				local v67 = v64
				local v68 = s3

				submitPlanResult(v67, StudioProposePlanTool.formatFeedbackContent(v68), "feedback")
			end)

			return true
		end
	}
end

return createProposePlanController
