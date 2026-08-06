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
local getAskUserActivityLabel = turnDisplay.getAskUserActivityLabel
local getCompletedActivityLabel = turnDisplay.getCompletedActivityLabel
local getTurnWorkedDurationLabel = turnDisplay.getTurnWorkedDurationLabel
local t1 = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {}
}

local function contentBlocksToText(t2: {[any]: any}) -- line: 54
	local t3 = {}

	for _, v39 in t2 do
		if v39.type == "text" and typeof(v39.text) == "string" then
			table.insert(t3, v39.text)
		end
	end

	return table.concat(t3)
end
local function getAssistantMessageTexts(p1) -- line: 64
	-- upvalues: contentBlocksToText (copy)
	local t4 = {}

	for _, v43 in p1.assistantMessageOrder do
		local v44 = p1.assistantMessages[v43]

		if v44 ~= nil then
			local v45 = contentBlocksToText(v44)

			if v45 ~= "" then
				table.insert(t4, v45)
			end
		end
	end

	return t4
end
local function makeTurnKey(p2, t5: {[any]: any}) -- line: 78
	if t5.turnKey ~= nil then
		return t5.turnKey
	end

	local v48 = t5.sessionId or (p2 == nil and "pending-session" or p2.sessionId)
	local v49 = if t5.turnFeedbackIds == nil or typeof(t5.turnFeedbackIds) == "function" then nil else t5.turnFeedbackIds.sequenceId

	if v49 ~= nil then
		return `{ v48 }:{ v49 }`
	end

	return v48
end
local function makeSegmentKey(s1: string, ...) -- line: 90
	local t6 = { s1 }

	for _, v53 in { ... } do
		table.insert(t6, (tostring(v53)))
	end

	return table.concat(t6, ":")
end
local function getSortedActivitySlotIndexes(p3) -- line: 98
	local t7 = {}

	for v56 in p3.activitySlots do
		table.insert(t7, v56)
	end

	table.sort(t7)

	return t7
end
local function makeTurnActivityItem(p4, p5) -- line: 107
	if p5.kind == "tool_call" then
		local v59 = p4.toolCalls[p5.toolCallId]

		return {
			kind = "tool_call",
			toolCallId = p5.toolCallId,
			title = if not v59 then nil else v59.title,
			status = if not v59 then nil else v59.status
		}
	end

	return nil
end
local function makeAgentMessageSegment(s2: string, s3: string, b1: boolean?) -- line: 120
	if s3 == "" then
		return nil
	end

	return {
		kind = "agent_message",
		key = s2,
		text = s3,
		isError = b1
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
local function makeActiveActivitySummary(t9: {[any]: any}, b2: boolean, s5: string, s6: string?, b3: boolean?) -- line: 148
	-- upvalues: getActiveActivityLabel (copy)
	if #t9 == 0 and not b2 then
		return nil
	end

	return {
		kind = "activity_summary",
		summaryKind = "active",
		key = s5,
		label = s6 or getActiveActivityLabel(t9, b2),
		activityItems = t9,
		isLoading = b2,
		isWaitingForLocalTool = b3
	}
end
local function countActionsInSegments(t10: {[any]: any}) -- line: 170
	-- upvalues: countToolCalls (copy)
	local n1 = 0

	for _, v73 in t10 do
		if v73.kind == "activity_summary" then
			n1 += v73.actionCount or countToolCalls(v73.activityItems)
		end
	end

	return n1
end
local function getAnsweredPromptsByToolCallId(p6) -- line: 180
	-- upvalues: StudioAskUserTool (copy)
	local t11 = {}

	for _, v77 in StudioAskUserTool.getAnsweredPromptsFromTurnState(p6) do
		if v77.toolCallId ~= nil then
			local toolCallId = v77.toolCallId

			if t11[toolCallId] == nil then
				t11[toolCallId] = {}
			end

			table.insert(t11[toolCallId], v77)
		end
	end

	return t11
end
local function getCompletedPlansByToolCallId(p7) -- line: 194
	-- upvalues: StudioProposePlanTool (copy)
	local t12 = {}

	for _, v82 in StudioProposePlanTool.getCompletedPlansFromTurnState(p7) do
		if v82.toolCallId ~= nil then
			t12[v82.toolCallId] = v82
		end
	end

	return t12
end
local function makeClientToolSegment(s7: string, s8: string, n2: number, n3: number, b4: boolean, p8, p9) -- line: 204
	-- upvalues: makeSegmentKey (copy)
	return {
		kind = "client_tool",
		key = makeSegmentKey(s7, "client-tool", s8, n3),
		toolCallId = s8,
		callOrder = n2,
		isActive = b4,
		answerStackPrompt = p8,
		planProposal = p9
	}
end
local function projectAskUserSegments(p10, s9: string, s10: string, t13: {[any]: any}, p11) -- line: 224
	-- upvalues: makeSegmentKey (copy), StudioAskUserTool (copy)
	local v95 = p10.toolCalls[s10]

	if v95 == nil then
		return {}
	end

	local t14 = {}
	local v97 = t13[s10]

	if v97 ~= nil and #v97 > 0 then
		for v98, v99 in v97 do
			local v100 = v99.callOrder or v98

			table.insert(t14, {
				kind = "client_tool",
				isActive = false,
				planProposal = nil,
				key = makeSegmentKey(s9, "client-tool", s10, v98),
				toolCallId = s10,
				callOrder = v100,
				answerStackPrompt = v99
			})
		end

		return t14
	end

	local v101 = StudioAskUserTool.extractQuestionsFromToolCall(v95)
	local v102 = p11.askUserByToolCallId[s10]

	if v101 == nil or v102 == nil then
		return t14
	end

	for v103, v104 in v101 do
		local v105 = v102.selections[v103]

		if v103 == v102.currentIndex and not p11.submittedToolCallIds[s10] then
			local callOrder = v102.callOrder
			local t15 = {
				question = v104,
				selectedOptionId = if v105 == nil then nil else v105.selectedOptionId,
				customResponseText = if v105 == nil then nil else v105.customResponseText,
				toolCallId = s10,
				callOrder = v102.callOrder,
				isLastQuestion = v103 >= #v101
			}

			table.insert(t14, {
				kind = "client_tool",
				isActive = true,
				planProposal = nil,
				key = makeSegmentKey(s9, "client-tool", s10, v103),
				toolCallId = s10,
				callOrder = callOrder,
				answerStackPrompt = t15
			})

			return t14
		end

		if v105 == nil then
			return t14
		end

		local callOrder = v102.callOrder
		local t16 = {
			question = v104,
			selectedOptionId = v105.selectedOptionId,
			customResponseText = v105.customResponseText,
			toolCallId = s10,
			callOrder = v102.callOrder,
			isLastQuestion = v103 >= #v101
		}

		table.insert(t14, {
			kind = "client_tool",
			isActive = false,
			planProposal = nil,
			key = makeSegmentKey(s9, "client-tool", s10, v103),
			toolCallId = s10,
			callOrder = callOrder,
			answerStackPrompt = t16
		})
	end

	return t14
end
local function projectPlanSegments(p12, s11: string, s12: string, t17: {[any]: any}, p13) -- line: 291
	-- upvalues: makeSegmentKey (copy), StudioProposePlanTool (copy)
	local v115 = p12.toolCalls[s12]

	if v115 == nil then
		return {}
	end

	local v116 = t17[s12]

	if v116 ~= nil then
		local t18 = {}
		local v118 = v116.callOrder or 0
		local t19 = {
			kind = "client_tool",
			isActive = false,
			answerStackPrompt = nil,
			key = makeSegmentKey(s11, "client-tool", s12, 1),
			toolCallId = s12,
			callOrder = v118,
			planProposal = v116
		}

		t18[1] = t19

		return t18
	end

	local v120 = p13.planByToolCallId[s12]
	local v121 = StudioProposePlanTool.extractPlanFromToolCall(v115)

	if v121 == nil or v120 == nil then
		return {}
	end

	local t20 = {
		title = v121.title,
		textContent = v121.textContent,
		summary = v121.summary,
		toolCallId = s12,
		callOrder = v120.callOrder,
		isAccepted = v120.isAccepted,
		feedbackText = v120.feedbackText
	}
	local v123 = v120.isAccepted ~= true and (v120.feedbackText == nil and not p13.submittedToolCallIds[s12])
	local t21 = {}
	local callOrder = v120.callOrder
	local t22 = {
		kind = "client_tool",
		answerStackPrompt = nil,
		key = makeSegmentKey(s11, "client-tool", s12, 1),
		toolCallId = s12,
		callOrder = callOrder,
		isActive = v123,
		planProposal = t20
	}

	t21[1] = t22

	return t21
end
local function projectLocalToolSegments(p14, s13: string, s14: string, t23: {[any]: any}, t24: {[any]: any}, p15) -- line: 333
	-- upvalues: projectAskUserSegments (copy), projectPlanSegments (copy)
	local v133 = projectAskUserSegments(p14, s13, s14, t23, p15)

	if #v133 > 0 then
		return v133
	end

	return (projectPlanSegments(p14, s13, s14, t24, p15))
end
local function getActiveAskUserActivityLabel(p16, s15: string, p17) -- line: 349
	-- upvalues: StudioAskUserTool (copy), getAskUserActivityLabel (copy)
	local v137 = p17.askUserByToolCallId[s15]
	local v138 = p16.toolCalls[s15]

	if v137 == nil or v138 == nil then
		return nil
	end

	local v139 = StudioAskUserTool.extractQuestionsFromToolCall(v138)

	if v139 == nil then
		return nil
	end

	local v140 = v139[v137.currentIndex]
	local v141 = if v140 == nil then nil else #v140.options

	return getAskUserActivityLabel(#v139, v141)
end
local function projectWorkSegments(p18, s16: string, p19, b5: boolean) -- line: 370
	-- upvalues: getAnsweredPromptsByToolCallId (copy), getCompletedPlansByToolCallId (copy), makeSegmentKey (copy), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy), projectAskUserSegments (copy), projectPlanSegments (copy), StudioAskUserTool (copy), getAskUserActivityLabel (copy), contentBlocksToText (copy)
	local t25 = {}
	local t26 = {}
	local u148 = nil
	local u149 = false
	local v150 = getAnsweredPromptsByToolCallId(p18)
	local v151 = getCompletedPlansByToolCallId(p18)

	local function flushActivity(b6: boolean, n4: number?) -- line: 383
		-- upvalues: makeSegmentKey (copy), s16 (copy), t25 (copy), b5 (copy), t26 (ref), u148 (ref), u149 (ref), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy)
		local v225 = makeSegmentKey(s16, not b6 and "activity" or "activity-trailing", n4 or #t25 + 1)
		local v229

		if b5 and b6 then
			local v226 = t26
			local v227 = u148
			local v228 = u149

			v229 = if #v226 == 0 then {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v225,
				label = v227 or getActiveActivityLabel(v226, true),
				activityItems = v226,
				isWaitingForLocalTool = v228
			} else {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v225,
				label = v227 or getActiveActivityLabel(v226, true),
				activityItems = v226,
				isWaitingForLocalTool = v228
			}
		else
			v229 = makeCompletedActivitySummary(t26, v225)
		end

		if v229 ~= nil then
			table.insert(t25, v229)
		end

		t26 = {}
		u148 = nil
		u149 = false
	end

	local t27 = {}

	for v154 in p18.activitySlots do
		table.insert(t27, v154)
	end

	table.sort(t27)

	for _, v156 in t27 do
		local v157 = p18.activitySlots[v156]

		if v157.kind == "agent_message" then
			flushActivity(false, v156)

			local v158 = makeSegmentKey(s16, "agent-message", v156)
			local text = v157.text
			local v160 = if text ~= "" then {
				kind = "agent_message",
				isError = nil,
				key = v158,
				text = text
			} else nil

			if v160 ~= nil then
				table.insert(t25, v160)
			end
		elseif v157.kind == "tool_call" then
			local toolCallId = v157.toolCallId
			local v162 = projectAskUserSegments(p18, s16, toolCallId, v150, p19)
			local v163 = if not (#v162 > 0) then projectPlanSegments(p18, s16, toolCallId, v151, p19) else v162

			if #v163 > 0 then
				flushActivity(false, v156)

				for _, v165 in v163 do
					table.insert(t25, v165)

					if v165.isActive then
						u149 = true
					end
				end

				if b5 then
					local t28

					if v157.kind == "tool_call" then
						local v166 = p18.toolCalls[v157.toolCallId]

						t28 = {
							kind = "tool_call",
							toolCallId = v157.toolCallId,
							title = if not v166 then nil else v166.title,
							status = if not v166 then nil else v166.status
						}
					else
						t28 = nil
					end

					if t28 ~= nil then
						table.insert(t26, t28)
					end

					local toolCallId2 = v157.toolCallId
					local v169 = p19.askUserByToolCallId[toolCallId2]
					local v170 = p18.toolCalls[toolCallId2]

					if v169 == nil or v170 == nil then
						u148 = nil
					else
						local v171 = StudioAskUserTool.extractQuestionsFromToolCall(v170)

						if v171 == nil then
							u148 = nil
						else
							local v172 = v171[v169.currentIndex]
							local v173 = if v172 == nil then nil else #v172.options

							u148 = getAskUserActivityLabel(#v171, v173)
						end
					end
				end
			else
				local t29

				if v157.kind == "tool_call" then
					local v174 = p18.toolCalls[v157.toolCallId]

					t29 = {
						kind = "tool_call",
						toolCallId = v157.toolCallId,
						title = if not v174 then nil else v174.title,
						status = if not v174 then nil else v174.status
					}
				else
					t29 = nil
				end

				if t29 ~= nil then
					table.insert(t26, t29)
				end
			end
		end
	end

	local v176 = contentBlocksToText(p18.pendingAgentMessageContent)

	if v176 ~= "" then
		flushActivity(false, p18.pendingAgentMessageSequenceIndex)

		local v177 = if p18.pendingAgentMessageSequenceIndex == nil then makeSegmentKey(s16, "pending-agent-message") else makeSegmentKey(s16, "agent-message", p18.pendingAgentMessageSequenceIndex)
		local v178 = if v176 ~= "" then {
			kind = "agent_message",
			isError = nil,
			key = v177,
			text = v176
		} else nil

		if v178 ~= nil then
			table.insert(t25, v178)
		end
	end

	flushActivity(true, nil)

	return t25
end
local function makeTurnWorkSegment(s17: string, t30: {[any]: any}, t31: {[any]: any}?, n5: number?, n6: number?) -- line: 463
	-- upvalues: countActionsInSegments (copy), makeSegmentKey (copy), getTurnWorkedDurationLabel (copy)
	if #t30 == 0 then
		return nil
	end

	local v184 = countActionsInSegments(t30)

	return {
		kind = "turn_work",
		key = makeSegmentKey(s17, "work"),
		label = getTurnWorkedDurationLabel(t31, n5, n6, v184),
		segments = t30,
		actionCount = v184
	}
end
local function addTerminalAssistantMessageSegments(t32: {[any]: any}, p20, s18: string) -- line: 483
	-- upvalues: getAssistantMessageTexts (copy), makeSegmentKey (copy)
	for v188, v189 in getAssistantMessageTexts(p20) do
		local v190 = makeSegmentKey(s18, "terminal-agent-message", v188)
		local v191 = if v189 ~= "" then {
			kind = "agent_message",
			isError = nil,
			key = v190,
			text = v189
		} else nil

		if v191 ~= nil then
			table.insert(t32, v191)
		end
	end
end
local function projectTurnSegments(p21, t33: {[any]: any}, p22) -- line: 493
	-- upvalues: projectWorkSegments (copy), makeTurnWorkSegment (copy), addTerminalAssistantMessageSegments (copy), makeSegmentKey (copy), turnDisplay (copy), ASSISTANT_STOPPED_TEXT (copy), PublishToolUtils (copy)
	local turnKey

	if t33.turnKey ~= nil then
		turnKey = t33.turnKey
	else
		local v196 = t33.sessionId or (p21 == nil and "pending-session" or p21.sessionId)
		local v197 = if t33.turnFeedbackIds == nil or typeof(t33.turnFeedbackIds) == "function" then nil else t33.turnFeedbackIds.sequenceId

		turnKey = if v197 == nil then v196 else `{ v196 }:{ v197 }`
	end

	local t34 = {}
	local v199 = projectWorkSegments(p21, turnKey, p22, not p21.isDone)
	local v200 = makeTurnWorkSegment(turnKey, v199, p21.eventMetaBySequenceId, t33.startSequenceId, t33.endSequenceId)

	if v200 ~= nil then
		table.insert(t34, v200)
	end

	addTerminalAssistantMessageSegments(t34, p21, turnKey)

	if p21.status == "failed" or p21.stopReason == "error" then
		local v201 = makeSegmentKey(turnKey, "failure")
		local v202 = turnDisplay.formatTurnFailureMessage(p21)
		local v203 = if v202 ~= "" then {
			kind = "agent_message",
			isError = true,
			key = v201,
			text = v202
		} else nil

		if v203 ~= nil then
			table.insert(t34, v203)
		end
	elseif p21.status == "cancelled" or p21.stopReason == "cancelled" then
		local v204 = makeSegmentKey(turnKey, "cancelled")
		local v205 = ASSISTANT_STOPPED_TEXT
		local v206 = if v205 ~= "" then {
			kind = "agent_message",
			isError = nil,
			key = v204,
			text = v205
		} else nil

		if v206 ~= nil then
			table.insert(t34, v206)
		end
	end

	if p21.isDone and PublishToolUtils.includesPublishPlaceTool(p21) then
		table.insert(t34, {
			kind = "playtest_cta",
			key = makeSegmentKey(turnKey, "playtest-cta")
		})
	end

	return t34
end

return {
	formatStepCount = formatStepCount,
	projectActiveTurnSegments = function(p23, t35: {[any]: any}?) -- line: 564
		-- upvalues: projectTurnSegments (copy), t1 (copy)
		return (projectTurnSegments(p23, t35 or {}, if not t35 or not t35.optimisticLocalTools then t1 else t35.optimisticLocalTools))
	end,
	projectLoadingTurnSegments = function(t36: {[any]: any}?) -- line: 542
		-- upvalues: makeSegmentKey (copy), getActiveActivityLabel (copy), makeTurnWorkSegment (copy)
		local turnKey

		if t36 ~= nil then
			if t36.turnKey ~= nil then
				turnKey = t36.turnKey
			else
				local v209 = t36.sessionId or "pending-session"
				local v210 = if t36.turnFeedbackIds == nil or typeof(t36.turnFeedbackIds) == "function" then nil else t36.turnFeedbackIds.sequenceId

				turnKey = if v210 == nil then v209 else `{ v209 }:{ v210 }`
			end
		else
			turnKey = "loading"
		end

		local t37 = {}
		local v212 = makeSegmentKey(turnKey, "activity-trailing")

		if #t37 ~= 0 then
		end

		local t38 = {
			kind = "activity_summary",
			summaryKind = "active",
			isLoading = true,
			isWaitingForLocalTool = nil,
			key = v212,
			label = getActiveActivityLabel(t37, true),
			activityItems = t37
		}
		local t39 = {}

		if t38 ~= nil then
			table.insert(t39, t38)
		end

		local v215 = makeTurnWorkSegment(turnKey, t39)

		if v215 ~= nil then
			return { v215 }
		end

		return {}
	end,
	projectSetupErrorSegments = function(s19: string, t40: {[any]: any}?) -- line: 553
		-- upvalues: makeSegmentKey (copy)
		local turnKey

		if t40 ~= nil then
			if t40.turnKey ~= nil then
				turnKey = t40.turnKey
			else
				local v219 = t40.sessionId or "pending-session"
				local v220 = if t40.turnFeedbackIds == nil or typeof(t40.turnFeedbackIds) == "function" then nil else t40.turnFeedbackIds.sequenceId

				turnKey = if v220 == nil then v219 else `{ v219 }:{ v220 }`
			end
		else
			turnKey = "setup-error"
		end

		return {{
			kind = "agent_message",
			key = makeSegmentKey(turnKey, "setup-error"),
			text = s19
		}}
	end
}
