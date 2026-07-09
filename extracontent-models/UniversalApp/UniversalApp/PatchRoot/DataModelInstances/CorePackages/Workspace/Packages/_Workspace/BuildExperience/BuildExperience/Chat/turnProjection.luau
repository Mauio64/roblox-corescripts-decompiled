local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local turnDisplay = require(script.Parent.turnDisplay)
local PublishToolUtils = CreatorAgentChat.PublishToolUtils
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool
local ASSISTANT_STOPPED_TEXT = turnDisplay.ASSISTANT_STOPPED_TEXT
local countToolCalls = turnDisplay.countToolCalls
local formatStepCount = turnDisplay.formatStepCount
local getActiveActivityLabel = turnDisplay.getActiveActivityLabel
local getCompletedActivityLabel = turnDisplay.getCompletedActivityLabel
local t1 = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {}
}

local function contentBlocksToText(t2: {[any]: any}) -- line: 50
	local t3 = {}

	for _, v36 in t2 do
		if v36.type == "text" and typeof(v36.text) == "string" then
			table.insert(t3, v36.text)
		end
	end

	return table.concat(t3)
end
local function getAssistantMessageTexts(p1) -- line: 60
	-- upvalues: contentBlocksToText (copy)
	local t4 = {}

	for _, v40 in p1.assistantMessageOrder do
		local v41 = p1.assistantMessages[v40]

		if v41 ~= nil then
			local v42 = contentBlocksToText(v41)

			if v42 ~= "" then
				table.insert(t4, v42)
			end
		end
	end

	return t4
end
local function makeTurnKey(p2, t5: {[any]: any}) -- line: 74
	if t5.turnKey ~= nil then
		return t5.turnKey
	end

	local v45 = t5.sessionId or (p2 == nil and "pending-session" or p2.sessionId)
	local v46 = if t5.turnFeedbackIds == nil or typeof(t5.turnFeedbackIds) == "function" then nil else t5.turnFeedbackIds.sequenceId

	if v46 ~= nil then
		return `{ v45 }:{ v46 }`
	end

	return v45
end
local function makeSegmentKey(s1: string, ...) -- line: 86
	local t6 = { s1 }

	for _, v50 in { ... } do
		table.insert(t6, (tostring(v50)))
	end

	return table.concat(t6, ":")
end
local function getSortedActivitySlotIndexes(p3) -- line: 94
	local t7 = {}

	for v53 in p3.activitySlots do
		table.insert(t7, v53)
	end

	table.sort(t7)

	return t7
end
local function makeTurnActivityItem(p4, p5) -- line: 103
	if p5.kind == "thought" then
		return {
			kind = "thought",
			text = p5.text
		}
	end

	if p5.kind == "tool_call" then
		local v56 = p4.toolCalls[p5.toolCallId]

		return {
			kind = "tool_call",
			toolCallId = p5.toolCallId,
			title = if not v56 then nil else v56.title,
			status = if not v56 then nil else v56.status
		}
	end

	return nil
end
local function makeAgentMessageSegment(s2: string, s3: string) -- line: 121
	if s3 == "" then
		return nil
	end

	return {
		kind = "agent_message",
		key = s2,
		text = s3
	}
end
local function makeCompletedActivitySummary(t8: {[any]: any}, s4: string) -- line: 132
	-- upvalues: getCompletedActivityLabel (copy), countToolCalls (copy)
	if #t8 == 0 then
		return nil
	end

	return {
		kind = "activity_summary",
		summaryKind = "completed",
		isLoading = false,
		key = s4,
		label = getCompletedActivityLabel(t8),
		activityItems = t8,
		actionCount = countToolCalls(t8)
	}
end
local function makeActiveActivitySummary(t9: {[any]: any}, b1: boolean, s5: string) -- line: 148
	-- upvalues: getActiveActivityLabel (copy)
	if #t9 == 0 and not b1 then
		return nil
	end

	return {
		kind = "activity_summary",
		summaryKind = "active",
		key = s5,
		label = getActiveActivityLabel(t9, b1),
		activityItems = t9,
		isLoading = b1
	}
end
local function countActionsInSegments(t10: {[any]: any}) -- line: 167
	-- upvalues: countToolCalls (copy)
	local n1 = 0

	for _, v67 in t10 do
		if v67.kind == "activity_summary" then
			n1 += v67.actionCount or countToolCalls(v67.activityItems)
		end
	end

	return n1
end
local function getAnsweredPromptsByToolCallId(p6) -- line: 177
	-- upvalues: StudioAskUserTool (copy)
	local t11 = {}

	for _, v71 in StudioAskUserTool.getAnsweredPromptsFromTurnState(p6) do
		if v71.toolCallId ~= nil then
			local toolCallId = v71.toolCallId

			if t11[toolCallId] == nil then
				t11[toolCallId] = {}
			end

			table.insert(t11[toolCallId], v71)
		end
	end

	return t11
end
local function getCompletedPlansByToolCallId(p7) -- line: 191
	-- upvalues: StudioProposePlanTool (copy)
	local t12 = {}

	for _, v76 in StudioProposePlanTool.getCompletedPlansFromTurnState(p7) do
		if v76.toolCallId ~= nil then
			t12[v76.toolCallId] = v76
		end
	end

	return t12
end
local function makeClientToolSegment(s6: string, s7: string, n2: number, n3: number, b2: boolean, p8, p9) -- line: 201
	-- upvalues: makeSegmentKey (copy)
	return {
		kind = "client_tool",
		key = makeSegmentKey(s6, "client-tool", s7, n3),
		toolCallId = s7,
		callOrder = n2,
		isActive = b2,
		answerStackPrompt = p8,
		planProposal = p9
	}
end
local function projectAskUserSegments(p10, s8: string, s9: string, t13: {[any]: any}, p11) -- line: 221
	-- upvalues: makeSegmentKey (copy), StudioAskUserTool (copy)
	local v89 = p10.toolCalls[s9]

	if v89 == nil then
		return {}
	end

	local t14 = {}
	local v91 = t13[s9]

	if v91 ~= nil and #v91 > 0 then
		for v92, v93 in v91 do
			local v94 = v93.callOrder or v92

			table.insert(t14, {
				kind = "client_tool",
				isActive = false,
				planProposal = nil,
				key = makeSegmentKey(s8, "client-tool", s9, v92),
				toolCallId = s9,
				callOrder = v94,
				answerStackPrompt = v93
			})
		end

		return t14
	end

	local v95 = StudioAskUserTool.extractQuestionsFromToolCall(v89)
	local v96 = p11.askUserByToolCallId[s9]

	if v95 == nil or v96 == nil then
		return t14
	end

	for v97, v98 in v95 do
		local v99 = v96.selections[v97]

		if v99 == nil then
			if v97 ~= v96.currentIndex or p11.submittedToolCallIds[s9] then
				return t14
			end

			local callOrder = v96.callOrder
			local t15 = {
				question = v98,
				toolCallId = s9,
				callOrder = v96.callOrder
			}

			table.insert(t14, {
				kind = "client_tool",
				isActive = true,
				planProposal = nil,
				key = makeSegmentKey(s8, "client-tool", s9, v97),
				toolCallId = s9,
				callOrder = callOrder,
				answerStackPrompt = t15
			})

			return t14
		end

		local callOrder = v96.callOrder
		local t16 = {
			question = v98,
			selectedOptionId = v99.selectedOptionId,
			customResponseText = v99.customResponseText,
			toolCallId = s9,
			callOrder = v96.callOrder
		}

		table.insert(t14, {
			kind = "client_tool",
			isActive = false,
			planProposal = nil,
			key = makeSegmentKey(s8, "client-tool", s9, v97),
			toolCallId = s9,
			callOrder = callOrder,
			answerStackPrompt = t16
		})
	end

	return t14
end
local function projectPlanSegments(p12, s10: string, s11: string, t17: {[any]: any}, p13) -- line: 282
	-- upvalues: makeSegmentKey (copy), StudioProposePlanTool (copy)
	local v109 = p12.toolCalls[s11]

	if v109 == nil then
		return {}
	end

	local v110 = t17[s11]

	if v110 ~= nil then
		local t18 = {}
		local v112 = v110.callOrder or 0
		local t19 = {
			kind = "client_tool",
			isActive = false,
			answerStackPrompt = nil,
			key = makeSegmentKey(s10, "client-tool", s11, 1),
			toolCallId = s11,
			callOrder = v112,
			planProposal = v110
		}

		t18[1] = t19

		return t18
	end

	local v114 = p13.planByToolCallId[s11]
	local v115 = StudioProposePlanTool.extractPlanFromToolCall(v109)

	if v115 == nil or v114 == nil then
		return {}
	end

	local t20 = {
		title = v115.title,
		textContent = v115.textContent,
		summary = v115.summary,
		toolCallId = s11,
		callOrder = v114.callOrder,
		isAccepted = v114.isAccepted,
		feedbackText = v114.feedbackText
	}
	local v117 = v114.isAccepted ~= true and (v114.feedbackText == nil and not p13.submittedToolCallIds[s11])
	local t21 = {}
	local callOrder = v114.callOrder
	local t22 = {
		kind = "client_tool",
		answerStackPrompt = nil,
		key = makeSegmentKey(s10, "client-tool", s11, 1),
		toolCallId = s11,
		callOrder = callOrder,
		isActive = v117,
		planProposal = t20
	}

	t21[1] = t22

	return t21
end
local function projectLocalToolSegments(p14, s12: string, s13: string, t23: {[any]: any}, t24: {[any]: any}, p15) -- line: 324
	-- upvalues: projectAskUserSegments (copy), projectPlanSegments (copy)
	local v127 = projectAskUserSegments(p14, s12, s13, t23, p15)

	if #v127 > 0 then
		return v127
	end

	return (projectPlanSegments(p14, s12, s13, t24, p15))
end
local function projectWorkSegments(p16, s14: string, p17, b3: boolean) -- line: 340
	-- upvalues: getAnsweredPromptsByToolCallId (copy), getCompletedPlansByToolCallId (copy), makeSegmentKey (copy), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy), projectAskUserSegments (copy), projectPlanSegments (copy), makeTurnActivityItem (copy), contentBlocksToText (copy)
	local t25 = {}
	local t26 = {}
	local v134 = getAnsweredPromptsByToolCallId(p16)
	local v135 = getCompletedPlansByToolCallId(p16)

	local function flushActivity(b4: boolean, n4: number?) -- line: 351
		-- upvalues: makeSegmentKey (copy), s14 (copy), t25 (copy), b3 (copy), t26 (ref), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy)
		local v198 = makeSegmentKey(s14, not b4 and "activity" or "activity-trailing", n4 or #t25 + 1)
		local v200

		if b3 and b4 then
			local v199 = t26

			v200 = if #v199 == 0 then {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v198,
				label = getActiveActivityLabel(v199, true),
				activityItems = v199
			} else {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v198,
				label = getActiveActivityLabel(v199, true),
				activityItems = v199
			}
		else
			v200 = makeCompletedActivitySummary(t26, v198)
		end

		if v200 ~= nil then
			table.insert(t25, v200)
		end

		t26 = {}
	end

	local t27 = {}

	for v138 in p16.activitySlots do
		table.insert(t27, v138)
	end

	table.sort(t27)

	for _, v140 in t27 do
		local v141 = p16.activitySlots[v140]

		if v141.kind == "agent_message" then
			flushActivity(false, v140)

			local v142 = makeSegmentKey(s14, "agent-message", v140)
			local text = v141.text
			local v144 = if text ~= "" then {
				kind = "agent_message",
				key = v142,
				text = text
			} else nil

			if v144 ~= nil then
				table.insert(t25, v144)
			end
		elseif v141.kind == "tool_call" then
			local toolCallId = v141.toolCallId
			local v146 = projectAskUserSegments(p16, s14, toolCallId, v134, p17)
			local v147 = if not (#v146 > 0) then projectPlanSegments(p16, s14, toolCallId, v135, p17) else v146

			if #v147 > 0 then
				flushActivity(false, v140)

				for _, v149 in v147 do
					table.insert(t25, v149)
				end
			else
				local v150 = makeTurnActivityItem(p16, v141)

				if v150 ~= nil then
					table.insert(t26, v150)
				end
			end
		else
			local v151 = makeTurnActivityItem(p16, v141)

			if v151 ~= nil then
				table.insert(t26, v151)
			end
		end
	end

	local v152 = contentBlocksToText(p16.pendingAgentMessageContent)

	if v152 ~= "" then
		flushActivity(false, p16.pendingAgentMessageSequenceIndex)

		local v153 = makeSegmentKey(s14, "pending-agent-message")
		local v154 = if v152 ~= "" then {
			kind = "agent_message",
			key = v153,
			text = v152
		} else nil

		if v154 ~= nil then
			table.insert(t25, v154)
		end
	end

	flushActivity(true, nil)

	return t25
end
local function makeTurnWorkSegment(s15: string, t28: {[any]: any}) -- line: 420
	-- upvalues: countActionsInSegments (copy), makeSegmentKey (copy), formatStepCount (copy)
	if #t28 == 0 then
		return nil
	end

	local v157 = countActionsInSegments(t28)

	return {
		kind = "turn_work",
		key = makeSegmentKey(s15, "work"),
		label = not (v157 > 0) and "Turn activity" or formatStepCount(v157),
		segments = t28,
		actionCount = v157
	}
end
local function addTerminalAssistantMessageSegments(t29: {[any]: any}, p18, s16: string) -- line: 434
	-- upvalues: getAssistantMessageTexts (copy), makeSegmentKey (copy)
	for v161, v162 in getAssistantMessageTexts(p18) do
		local v163 = makeSegmentKey(s16, "terminal-agent-message", v161)
		local v164 = if v162 ~= "" then {
			kind = "agent_message",
			key = v163,
			text = v162
		} else nil

		if v164 ~= nil then
			table.insert(t29, v164)
		end
	end
end
local function projectTurnSegments(p19, t30: {[any]: any}, p20) -- line: 444
	-- upvalues: projectWorkSegments (copy), makeTurnWorkSegment (copy), addTerminalAssistantMessageSegments (copy), makeSegmentKey (copy), turnDisplay (copy), ASSISTANT_STOPPED_TEXT (copy), PublishToolUtils (copy)
	local turnKey

	if t30.turnKey ~= nil then
		turnKey = t30.turnKey
	else
		local v169 = t30.sessionId or (p19 == nil and "pending-session" or p19.sessionId)
		local v170 = if t30.turnFeedbackIds == nil or typeof(t30.turnFeedbackIds) == "function" then nil else t30.turnFeedbackIds.sequenceId

		turnKey = if v170 == nil then v169 else `{ v169 }:{ v170 }`
	end

	local t31 = {}
	local v172 = projectWorkSegments(p19, turnKey, p20, not p19.isDone)
	local v173 = makeTurnWorkSegment(turnKey, v172)

	if v173 ~= nil then
		table.insert(t31, v173)
	end

	addTerminalAssistantMessageSegments(t31, p19, turnKey)

	if p19.status == "failed" then
		local v174 = makeSegmentKey(turnKey, "failure")
		local v175 = turnDisplay.formatTurnFailureMessage(p19)
		local v176 = if v175 ~= "" then {
			kind = "agent_message",
			key = v174,
			text = v175
		} else nil

		if v176 ~= nil then
			table.insert(t31, v176)
		end
	elseif p19.status == "cancelled" or p19.stopReason == "cancelled" then
		local v177 = makeSegmentKey(turnKey, "cancelled")
		local v178 = ASSISTANT_STOPPED_TEXT
		local v179 = if v178 ~= "" then {
			kind = "agent_message",
			key = v177,
			text = v178
		} else nil

		if v179 ~= nil then
			table.insert(t31, v179)
		end
	end

	if p19.isDone and PublishToolUtils.includesPublishPlaceTool(p19) then
		table.insert(t31, {
			kind = "playtest_cta",
			key = makeSegmentKey(turnKey, "playtest-cta")
		})
	end

	return t31
end

return {
	formatStepCount = formatStepCount,
	projectActiveTurnSegments = function(p21, t32: {[any]: any}?) -- line: 506
		-- upvalues: projectTurnSegments (copy), t1 (copy)
		return (projectTurnSegments(p21, t32 or {}, if not t32 or not t32.optimisticLocalTools then t1 else t32.optimisticLocalTools))
	end,
	projectLoadingTurnSegments = function(t33: {[any]: any}?) -- line: 484
		-- upvalues: makeSegmentKey (copy), getActiveActivityLabel (copy), makeTurnWorkSegment (copy)
		local turnKey

		if t33 ~= nil then
			if t33.turnKey ~= nil then
				turnKey = t33.turnKey
			else
				local v182 = t33.sessionId or "pending-session"
				local v183 = if t33.turnFeedbackIds == nil or typeof(t33.turnFeedbackIds) == "function" then nil else t33.turnFeedbackIds.sequenceId

				turnKey = if v183 == nil then v182 else `{ v182 }:{ v183 }`
			end
		else
			turnKey = "loading"
		end

		local t34 = {}
		local v185 = makeSegmentKey(turnKey, "activity-trailing")

		if #t34 ~= 0 then
		end

		local t35 = {
			kind = "activity_summary",
			summaryKind = "active",
			isLoading = true,
			key = v185,
			label = getActiveActivityLabel(t34, true),
			activityItems = t34
		}
		local t36 = {}

		if t35 ~= nil then
			table.insert(t36, t35)
		end

		local v188 = makeTurnWorkSegment(turnKey, t36)

		if v188 ~= nil then
			return { v188 }
		end

		return {}
	end,
	projectSetupErrorSegments = function(s17: string, t37: {[any]: any}?) -- line: 495
		-- upvalues: makeSegmentKey (copy)
		local turnKey

		if t37 ~= nil then
			if t37.turnKey ~= nil then
				turnKey = t37.turnKey
			else
				local v192 = t37.sessionId or "pending-session"
				local v193 = if t37.turnFeedbackIds == nil or typeof(t37.turnFeedbackIds) == "function" then nil else t37.turnFeedbackIds.sequenceId

				turnKey = if v193 == nil then v192 else `{ v192 }:{ v193 }`
			end
		else
			turnKey = "setup-error"
		end

		return {{
			kind = "agent_message",
			key = makeSegmentKey(turnKey, "setup-error"),
			text = s17
		}}
	end
}
