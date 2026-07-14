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

local function contentBlocksToText(t2: {[any]: any}) -- line: 55
	local t3 = {}

	for _, v39 in t2 do
		if v39.type == "text" and typeof(v39.text) == "string" then
			table.insert(t3, v39.text)
		end
	end

	return table.concat(t3)
end
local function getAssistantMessageTexts(p1) -- line: 65
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
local function makeTurnKey(p2, t5: {[any]: any}) -- line: 79
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
local function makeSegmentKey(s1: string, ...) -- line: 91
	local t6 = { s1 }

	for _, v53 in { ... } do
		table.insert(t6, (tostring(v53)))
	end

	return table.concat(t6, ":")
end
local function getSortedActivitySlotIndexes(p3) -- line: 99
	local t7 = {}

	for v56 in p3.activitySlots do
		table.insert(t7, v56)
	end

	table.sort(t7)

	return t7
end
local function makeTurnActivityItem(p4, p5) -- line: 108
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
local function makeActiveActivitySummary(t9: {[any]: any}, b1: boolean, s5: string, s6: string?) -- line: 148
	-- upvalues: getActiveActivityLabel (copy)
	if #t9 == 0 and not b1 then
		return nil
	end

	return {
		kind = "activity_summary",
		summaryKind = "active",
		key = s5,
		label = s6 or getActiveActivityLabel(t9, b1),
		activityItems = t9,
		isLoading = b1
	}
end
local function countActionsInSegments(t10: {[any]: any}) -- line: 168
	-- upvalues: countToolCalls (copy)
	local n1 = 0

	for _, v71 in t10 do
		if v71.kind == "activity_summary" then
			n1 += v71.actionCount or countToolCalls(v71.activityItems)
		end
	end

	return n1
end
local function getAnsweredPromptsByToolCallId(p6) -- line: 178
	-- upvalues: StudioAskUserTool (copy)
	local t11 = {}

	for _, v75 in StudioAskUserTool.getAnsweredPromptsFromTurnState(p6) do
		if v75.toolCallId ~= nil then
			local toolCallId = v75.toolCallId

			if t11[toolCallId] == nil then
				t11[toolCallId] = {}
			end

			table.insert(t11[toolCallId], v75)
		end
	end

	return t11
end
local function getCompletedPlansByToolCallId(p7) -- line: 192
	-- upvalues: StudioProposePlanTool (copy)
	local t12 = {}

	for _, v80 in StudioProposePlanTool.getCompletedPlansFromTurnState(p7) do
		if v80.toolCallId ~= nil then
			t12[v80.toolCallId] = v80
		end
	end

	return t12
end
local function makeClientToolSegment(s7: string, s8: string, n2: number, n3: number, b2: boolean, p8, p9) -- line: 202
	-- upvalues: makeSegmentKey (copy)
	return {
		kind = "client_tool",
		key = makeSegmentKey(s7, "client-tool", s8, n3),
		toolCallId = s8,
		callOrder = n2,
		isActive = b2,
		answerStackPrompt = p8,
		planProposal = p9
	}
end
local function projectAskUserSegments(p10, s9: string, s10: string, t13: {[any]: any}, p11) -- line: 222
	-- upvalues: makeSegmentKey (copy), StudioAskUserTool (copy)
	local v93 = p10.toolCalls[s10]

	if v93 == nil then
		return {}
	end

	local t14 = {}
	local v95 = t13[s10]

	if v95 ~= nil and #v95 > 0 then
		for v96, v97 in v95 do
			local v98 = v97.callOrder or v96

			table.insert(t14, {
				kind = "client_tool",
				isActive = false,
				planProposal = nil,
				key = makeSegmentKey(s9, "client-tool", s10, v96),
				toolCallId = s10,
				callOrder = v98,
				answerStackPrompt = v97
			})
		end

		return t14
	end

	local v99 = StudioAskUserTool.extractQuestionsFromToolCall(v93)
	local v100 = p11.askUserByToolCallId[s10]

	if v99 == nil or v100 == nil then
		return t14
	end

	for v101, v102 in v99 do
		local v103 = v100.selections[v101]

		if v101 == v100.currentIndex and not p11.submittedToolCallIds[s10] then
			local callOrder = v100.callOrder
			local t15 = {
				question = v102,
				selectedOptionId = if v103 == nil then nil else v103.selectedOptionId,
				customResponseText = if v103 == nil then nil else v103.customResponseText,
				toolCallId = s10,
				callOrder = v100.callOrder,
				isLastQuestion = v101 >= #v99
			}

			table.insert(t14, {
				kind = "client_tool",
				isActive = true,
				planProposal = nil,
				key = makeSegmentKey(s9, "client-tool", s10, v101),
				toolCallId = s10,
				callOrder = callOrder,
				answerStackPrompt = t15
			})

			return t14
		end

		if v103 == nil then
			return t14
		end

		local callOrder = v100.callOrder
		local t16 = {
			question = v102,
			selectedOptionId = v103.selectedOptionId,
			customResponseText = v103.customResponseText,
			toolCallId = s10,
			callOrder = v100.callOrder,
			isLastQuestion = v101 >= #v99
		}

		table.insert(t14, {
			kind = "client_tool",
			isActive = false,
			planProposal = nil,
			key = makeSegmentKey(s9, "client-tool", s10, v101),
			toolCallId = s10,
			callOrder = callOrder,
			answerStackPrompt = t16
		})
	end

	return t14
end
local function projectPlanSegments(p12, s11: string, s12: string, t17: {[any]: any}, p13) -- line: 289
	-- upvalues: makeSegmentKey (copy), StudioProposePlanTool (copy)
	local v113 = p12.toolCalls[s12]

	if v113 == nil then
		return {}
	end

	local v114 = t17[s12]

	if v114 ~= nil then
		local t18 = {}
		local v116 = v114.callOrder or 0
		local t19 = {
			kind = "client_tool",
			isActive = false,
			answerStackPrompt = nil,
			key = makeSegmentKey(s11, "client-tool", s12, 1),
			toolCallId = s12,
			callOrder = v116,
			planProposal = v114
		}

		t18[1] = t19

		return t18
	end

	local v118 = p13.planByToolCallId[s12]
	local v119 = StudioProposePlanTool.extractPlanFromToolCall(v113)

	if v119 == nil or v118 == nil then
		return {}
	end

	local t20 = {
		title = v119.title,
		textContent = v119.textContent,
		summary = v119.summary,
		toolCallId = s12,
		callOrder = v118.callOrder,
		isAccepted = v118.isAccepted,
		feedbackText = v118.feedbackText
	}
	local v121 = v118.isAccepted ~= true and (v118.feedbackText == nil and not p13.submittedToolCallIds[s12])
	local t21 = {}
	local callOrder = v118.callOrder
	local t22 = {
		kind = "client_tool",
		answerStackPrompt = nil,
		key = makeSegmentKey(s11, "client-tool", s12, 1),
		toolCallId = s12,
		callOrder = callOrder,
		isActive = v121,
		planProposal = t20
	}

	t21[1] = t22

	return t21
end
local function projectLocalToolSegments(p14, s13: string, s14: string, t23: {[any]: any}, t24: {[any]: any}, p15) -- line: 331
	-- upvalues: projectAskUserSegments (copy), projectPlanSegments (copy)
	local v131 = projectAskUserSegments(p14, s13, s14, t23, p15)

	if #v131 > 0 then
		return v131
	end

	return (projectPlanSegments(p14, s13, s14, t24, p15))
end
local function getActiveAskUserActivityLabel(p16, s15: string, p17) -- line: 347
	-- upvalues: StudioAskUserTool (copy), getAskUserActivityLabel (copy)
	local v135 = p17.askUserByToolCallId[s15]
	local v136 = p16.toolCalls[s15]

	if v135 == nil or v136 == nil then
		return nil
	end

	local v137 = StudioAskUserTool.extractQuestionsFromToolCall(v136)

	if v137 == nil then
		return nil
	end

	local v138 = v137[v135.currentIndex]
	local v139 = if v138 == nil then nil else #v138.options

	return getAskUserActivityLabel(#v137, v139)
end
local function projectWorkSegments(p18, s16: string, p19, b3: boolean) -- line: 368
	-- upvalues: getAnsweredPromptsByToolCallId (copy), getCompletedPlansByToolCallId (copy), makeSegmentKey (copy), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy), projectAskUserSegments (copy), projectPlanSegments (copy), StudioAskUserTool (copy), getAskUserActivityLabel (copy), contentBlocksToText (copy)
	local t25 = {}
	local t26 = {}
	local u146 = nil
	local v147 = getAnsweredPromptsByToolCallId(p18)
	local v148 = getCompletedPlansByToolCallId(p18)

	local function flushActivity(b4: boolean, n4: number?) -- line: 380
		-- upvalues: makeSegmentKey (copy), s16 (copy), t25 (copy), b3 (copy), t26 (ref), u146 (ref), getActiveActivityLabel (copy), makeCompletedActivitySummary (copy)
		local v222 = makeSegmentKey(s16, not b4 and "activity" or "activity-trailing", n4 or #t25 + 1)
		local v225

		if b3 and b4 then
			local v223 = t26
			local v224 = u146

			v225 = if #v223 == 0 then {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v222,
				label = v224 or getActiveActivityLabel(v223, true),
				activityItems = v223
			} else {
				kind = "activity_summary",
				summaryKind = "active",
				isLoading = true,
				key = v222,
				label = v224 or getActiveActivityLabel(v223, true),
				activityItems = v223
			}
		else
			v225 = makeCompletedActivitySummary(t26, v222)
		end

		if v225 ~= nil then
			table.insert(t25, v225)
		end

		t26 = {}
		u146 = nil
	end

	local t27 = {}

	for v151 in p18.activitySlots do
		table.insert(t27, v151)
	end

	table.sort(t27)

	for _, v153 in t27 do
		local v154 = p18.activitySlots[v153]

		if v154.kind == "agent_message" then
			flushActivity(false, v153)

			local v155 = makeSegmentKey(s16, "agent-message", v153)
			local text = v154.text
			local v157 = if text ~= "" then {
				kind = "agent_message",
				key = v155,
				text = text
			} else nil

			if v157 ~= nil then
				table.insert(t25, v157)
			end
		elseif v154.kind == "tool_call" then
			local toolCallId = v154.toolCallId
			local v159 = projectAskUserSegments(p18, s16, toolCallId, v147, p19)
			local v160 = if not (#v159 > 0) then projectPlanSegments(p18, s16, toolCallId, v148, p19) else v159

			if #v160 > 0 then
				flushActivity(false, v153)

				for _, v162 in v160 do
					table.insert(t25, v162)
				end

				if b3 then
					local t28

					if v154.kind == "tool_call" then
						local v163 = p18.toolCalls[v154.toolCallId]

						t28 = {
							kind = "tool_call",
							toolCallId = v154.toolCallId,
							title = if not v163 then nil else v163.title,
							status = if not v163 then nil else v163.status
						}
					else
						t28 = nil
					end

					if t28 ~= nil then
						table.insert(t26, t28)
					end

					local toolCallId2 = v154.toolCallId
					local v166 = p19.askUserByToolCallId[toolCallId2]
					local v167 = p18.toolCalls[toolCallId2]

					if v166 == nil or v167 == nil then
						u146 = nil
					else
						local v168 = StudioAskUserTool.extractQuestionsFromToolCall(v167)

						if v168 == nil then
							u146 = nil
						else
							local v169 = v168[v166.currentIndex]
							local v170 = if v169 == nil then nil else #v169.options

							u146 = getAskUserActivityLabel(#v168, v170)
						end
					end
				end
			else
				local t29

				if v154.kind == "tool_call" then
					local v171 = p18.toolCalls[v154.toolCallId]

					t29 = {
						kind = "tool_call",
						toolCallId = v154.toolCallId,
						title = if not v171 then nil else v171.title,
						status = if not v171 then nil else v171.status
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

	local v173 = contentBlocksToText(p18.pendingAgentMessageContent)

	if v173 ~= "" then
		flushActivity(false, p18.pendingAgentMessageSequenceIndex)

		local v174 = makeSegmentKey(s16, "pending-agent-message")
		local v175 = if v173 ~= "" then {
			kind = "agent_message",
			key = v174,
			text = v173
		} else nil

		if v175 ~= nil then
			table.insert(t25, v175)
		end
	end

	flushActivity(true, nil)

	return t25
end
local function makeTurnWorkSegment(s17: string, t30: {[any]: any}, t31: {[any]: any}?, n5: number?, n6: number?) -- line: 453
	-- upvalues: countActionsInSegments (copy), makeSegmentKey (copy), getTurnWorkedDurationLabel (copy)
	if #t30 == 0 then
		return nil
	end

	local v181 = countActionsInSegments(t30)

	return {
		kind = "turn_work",
		key = makeSegmentKey(s17, "work"),
		label = getTurnWorkedDurationLabel(t31, n5, n6, v181),
		segments = t30,
		actionCount = v181
	}
end
local function addTerminalAssistantMessageSegments(t32: {[any]: any}, p20, s18: string) -- line: 473
	-- upvalues: getAssistantMessageTexts (copy), makeSegmentKey (copy)
	for v185, v186 in getAssistantMessageTexts(p20) do
		local v187 = makeSegmentKey(s18, "terminal-agent-message", v185)
		local v188 = if v186 ~= "" then {
			kind = "agent_message",
			key = v187,
			text = v186
		} else nil

		if v188 ~= nil then
			table.insert(t32, v188)
		end
	end
end
local function projectTurnSegments(p21, t33: {[any]: any}, p22) -- line: 483
	-- upvalues: projectWorkSegments (copy), makeTurnWorkSegment (copy), addTerminalAssistantMessageSegments (copy), makeSegmentKey (copy), turnDisplay (copy), ASSISTANT_STOPPED_TEXT (copy), PublishToolUtils (copy)
	local turnKey

	if t33.turnKey ~= nil then
		turnKey = t33.turnKey
	else
		local v193 = t33.sessionId or (p21 == nil and "pending-session" or p21.sessionId)
		local v194 = if t33.turnFeedbackIds == nil or typeof(t33.turnFeedbackIds) == "function" then nil else t33.turnFeedbackIds.sequenceId

		turnKey = if v194 == nil then v193 else `{ v193 }:{ v194 }`
	end

	local t34 = {}
	local v196 = projectWorkSegments(p21, turnKey, p22, not p21.isDone)
	local v197 = makeTurnWorkSegment(turnKey, v196, p21.eventMetaBySequenceId, t33.startSequenceId, t33.endSequenceId)

	if v197 ~= nil then
		table.insert(t34, v197)
	end

	addTerminalAssistantMessageSegments(t34, p21, turnKey)

	if p21.status == "failed" then
		local v198 = makeSegmentKey(turnKey, "failure")
		local v199 = turnDisplay.formatTurnFailureMessage(p21)
		local v200 = if v199 ~= "" then {
			kind = "agent_message",
			key = v198,
			text = v199
		} else nil

		if v200 ~= nil then
			table.insert(t34, v200)
		end
	elseif p21.status == "cancelled" or p21.stopReason == "cancelled" then
		local v201 = makeSegmentKey(turnKey, "cancelled")
		local v202 = ASSISTANT_STOPPED_TEXT
		local v203 = if v202 ~= "" then {
			kind = "agent_message",
			key = v201,
			text = v202
		} else nil

		if v203 ~= nil then
			table.insert(t34, v203)
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
	projectActiveTurnSegments = function(p23, t35: {[any]: any}?) -- line: 551
		-- upvalues: projectTurnSegments (copy), t1 (copy)
		return (projectTurnSegments(p23, t35 or {}, if not t35 or not t35.optimisticLocalTools then t1 else t35.optimisticLocalTools))
	end,
	projectLoadingTurnSegments = function(t36: {[any]: any}?) -- line: 529
		-- upvalues: makeSegmentKey (copy), getActiveActivityLabel (copy), makeTurnWorkSegment (copy)
		local turnKey

		if t36 ~= nil then
			if t36.turnKey ~= nil then
				turnKey = t36.turnKey
			else
				local v206 = t36.sessionId or "pending-session"
				local v207 = if t36.turnFeedbackIds == nil or typeof(t36.turnFeedbackIds) == "function" then nil else t36.turnFeedbackIds.sequenceId

				turnKey = if v207 == nil then v206 else `{ v206 }:{ v207 }`
			end
		else
			turnKey = "loading"
		end

		local t37 = {}
		local v209 = makeSegmentKey(turnKey, "activity-trailing")

		if #t37 ~= 0 then
		end

		local t38 = {
			kind = "activity_summary",
			summaryKind = "active",
			isLoading = true,
			key = v209,
			label = getActiveActivityLabel(t37, true),
			activityItems = t37
		}
		local t39 = {}

		if t38 ~= nil then
			table.insert(t39, t38)
		end

		local v212 = makeTurnWorkSegment(turnKey, t39)

		if v212 ~= nil then
			return { v212 }
		end

		return {}
	end,
	projectSetupErrorSegments = function(s19: string, t40: {[any]: any}?) -- line: 540
		-- upvalues: makeSegmentKey (copy)
		local turnKey

		if t40 ~= nil then
			if t40.turnKey ~= nil then
				turnKey = t40.turnKey
			else
				local v216 = t40.sessionId or "pending-session"
				local v217 = if t40.turnFeedbackIds == nil or typeof(t40.turnFeedbackIds) == "function" then nil else t40.turnFeedbackIds.sequenceId

				turnKey = if v217 == nil then v216 else `{ v216 }:{ v217 }`
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
