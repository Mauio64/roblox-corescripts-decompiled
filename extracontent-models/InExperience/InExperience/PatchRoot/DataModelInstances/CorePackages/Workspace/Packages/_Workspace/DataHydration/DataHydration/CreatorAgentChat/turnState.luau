require(script.Parent.types)

local function getSequenceIndex(p1) -- line: 43
	local v28 = if p1 == nil then nil else p1.sequenceNumber

	if typeof(v28) ~= "number" or v28 < 0 then
		return nil
	end

	return v28 + 1
end
local function getMessageId(p2) -- line: 51
	local messageId = p2.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end
local function cloneArray(t1: {[any]: any}) -- line: 56
	local t2 = {}

	for _, v34 in t1 do
		table.insert(t2, v34)
	end

	return t2
end
local function contentBlocksToText(t3: {[any]: any}) -- line: 64
	local t4 = {}

	for _, v38 in t3 do
		if v38.type == "text" and typeof(v38.text) == "string" then
			table.insert(t4, v38.text)
		end
	end

	return table.concat(t4)
end
local function messageMapToText(t5: {[any]: any}, t6: {[any]: any}) -- line: 74
	-- upvalues: contentBlocksToText (copy)
	local t7 = {}

	for _, v43 in t6 do
		local v44 = t5[v43]

		if v44 ~= nil then
			table.insert(t7, contentBlocksToText(v44))
		end
	end

	return table.concat(t7)
end
local function ensureMessageOrder(t8: {[any]: any}, s1: string) -- line: 85
	for _, v48 in t8 do
		if v48 == s1 then
			return t8
		end
	end

	local t9 = {}

	for _, v51 in t8 do
		table.insert(t9, v51)
	end

	table.insert(t9, s1)

	return t9
end
local function replaceMessageContent(t10: {[any]: any}, t11: {[any]: any}, s2: string, t12: {[any]: any}) -- line: 96
	local v56 = table.clone(t10)
	local t13 = {}

	for _, v59 in t12 do
		table.insert(t13, v59)
	end

	v56[s2] = t13

	for _, v61 in t11 do
		if v61 == s2 then
			return v56, t11
		end
	end

	local t14 = {}

	for _, v64 in t11 do
		table.insert(t14, v64)
	end

	table.insert(t14, s2)

	return v56, t14
end
local function appendMessageContent(t15: {[any]: any}, t16: {[any]: any}, s3: string, p3) -- line: 107
	local v69 = table.clone(t15)
	local v70 = v69[s3]
	local t17

	if v70 ~= nil then
		t17 = {}

		for _, v73 in v70 do
			table.insert(t17, v73)
		end
	else
		t17 = {}
	end

	table.insert(t17, p3)
	v69[s3] = t17

	for _, v75 in t16 do
		if v75 == s3 then
			return v69, t16
		end
	end

	local t18 = {}

	for _, v78 in t16 do
		table.insert(t18, v78)
	end

	table.insert(t18, s3)

	return v69, t18
end
local function buildActivityItems(t19: {[any]: any}, t20: {[any]: any}) -- line: 121
	local t21 = {}
	local t22 = {}

	for v83 in t19 do
		table.insert(t22, v83)
	end

	table.sort(t22)

	for _, v85 in t22 do
		local v86 = t19[v85]

		if v86.kind == "agent_message" then
			table.insert(t21, {
				kind = "agent_message",
				text = v86.text
			})
		elseif v86.kind == "tool_call" then
			local v87 = t20[v86.toolCallId]

			table.insert(t21, {
				kind = "tool_call",
				toolCallId = v86.toolCallId,
				title = if not v87 then nil else v87.title,
				status = if not v87 then nil else v87.status
			})
		end
	end

	return t21
end
local function refreshActivityItems(p4) -- line: 154
	-- upvalues: buildActivityItems (copy)
	p4.activityItems = buildActivityItems(p4.activitySlots, p4.toolCalls)
end
local function recordActivitySlotAtIndex(p5, n1: number, p6) -- line: 158
	-- upvalues: buildActivityItems (copy)
	if n1 <= 0 then
		return
	end

	local v92 = table.clone(p5.activitySlots)

	v92[n1] = p6
	p5.activitySlots = v92
	p5.activityItems = buildActivityItems(p5.activitySlots, p5.toolCalls)
end
local function recordActivitySlot(p7, p8, p9) -- line: 169
	-- upvalues: buildActivityItems (copy)
	local v96 = if p8 == nil then nil else p8.sequenceNumber
	local v97 = if typeof(v96) == "number" and not (v96 < 0) then v96 + 1 else nil

	if v97 == nil then
		return
	end

	if v97 <= 0 then
		return
	end

	local v98 = table.clone(p7.activitySlots)

	v98[v97] = p9
	p7.activitySlots = v98
	p7.activityItems = buildActivityItems(p7.activitySlots, p7.toolCalls)
end
local function recordToolCallSequenceSlot(p10, p11, s4: string) -- line: 178
	-- upvalues: buildActivityItems (copy)
	local t23 = {
		kind = "tool_call",
		toolCallId = s4
	}
	local v103 = if p11 == nil then nil else p11.sequenceNumber
	local v104 = if typeof(v103) == "number" and not (v103 < 0) then v103 + 1 else nil

	if v104 == nil then
		return
	end

	if v104 <= 0 then
		return
	end

	local v105 = table.clone(p10.activitySlots)

	v105[v104] = t23
	p10.activitySlots = v105
	p10.activityItems = buildActivityItems(p10.activitySlots, p10.toolCalls)
end
local function hasToolCallActivitySlot(p12, s5: string) -- line: 182
	for _, v109 in p12.activitySlots do
		if v109.kind == "tool_call" and s5 == v109.toolCallId then
			return true
		end
	end

	return false
end
local function clearPendingAgentMessage(p13) -- line: 191
	p13.pendingAgentMessageId = nil
	p13.pendingAgentMessageContent = {}
	p13.pendingAgentMessageSequenceIndex = nil
end
local function appendPendingAgentMessage(p14, s6: string, p15, p16) -- line: 197
	-- upvalues: contentBlocksToText (copy), buildActivityItems (copy)
	if p14.pendingAgentMessageId ~= nil and s6 ~= p14.pendingAgentMessageId then
		local v115 = contentBlocksToText(p14.pendingAgentMessageContent)

		if v115 ~= "" then
			local pendingAgentMessageSequenceIndex = p14.pendingAgentMessageSequenceIndex

			if pendingAgentMessageSequenceIndex ~= nil then
				local t24 = {
					kind = "agent_message",
					text = v115
				}

				if not (pendingAgentMessageSequenceIndex <= 0) then
					local v118 = table.clone(p14.activitySlots)

					v118[pendingAgentMessageSequenceIndex] = t24
					p14.activitySlots = v118
					p14.activityItems = buildActivityItems(p14.activitySlots, p14.toolCalls)
				end
			end
		end

		p14.pendingAgentMessageId = nil
		p14.pendingAgentMessageContent = {}
		p14.pendingAgentMessageSequenceIndex = nil
	end

	local t25 = {}

	for _, v121 in p14.pendingAgentMessageContent do
		table.insert(t25, v121)
	end

	table.insert(t25, p15)
	p14.pendingAgentMessageId = s6
	p14.pendingAgentMessageContent = t25

	if p14.pendingAgentMessageSequenceIndex == nil then
		local v122 = if p16 == nil then nil else p16.sequenceNumber

		p14.pendingAgentMessageSequenceIndex = if typeof(v122) == "number" and not (v122 < 0) then v122 + 1 else nil
	end
end
local function flushPendingAgentMessageToActivity(p17) -- line: 223
	-- upvalues: contentBlocksToText (copy), buildActivityItems (copy)
	local v124 = contentBlocksToText(p17.pendingAgentMessageContent)

	if v124 ~= "" then
		local pendingAgentMessageSequenceIndex = p17.pendingAgentMessageSequenceIndex

		if pendingAgentMessageSequenceIndex ~= nil then
			local t26 = {
				kind = "agent_message",
				text = v124
			}

			if not (pendingAgentMessageSequenceIndex <= 0) then
				local v127 = table.clone(p17.activitySlots)

				v127[pendingAgentMessageSequenceIndex] = t26
				p17.activitySlots = v127
				p17.activityItems = buildActivityItems(p17.activitySlots, p17.toolCalls)
			end
		end
	end

	p17.pendingAgentMessageId = nil
	p17.pendingAgentMessageContent = {}
	p17.pendingAgentMessageSequenceIndex = nil
end
local function flushPendingAgentMessageToAssistant(p18) -- line: 234
	-- upvalues: appendMessageContent (copy), messageMapToText (copy)
	local pendingAgentMessageId = p18.pendingAgentMessageId

	if pendingAgentMessageId == nil then
		p18.pendingAgentMessageId = nil
		p18.pendingAgentMessageContent = {}
		p18.pendingAgentMessageSequenceIndex = nil

		return
	end

	local assistantMessages = p18.assistantMessages
	local assistantMessageOrder = p18.assistantMessageOrder

	for _, v133 in p18.pendingAgentMessageContent do
		assistantMessages, assistantMessageOrder = appendMessageContent(assistantMessages, assistantMessageOrder, pendingAgentMessageId, v133)
	end

	p18.assistantMessages = assistantMessages
	p18.assistantMessageOrder = assistantMessageOrder
	p18.assistantText = messageMapToText(assistantMessages, assistantMessageOrder)
	p18.pendingAgentMessageId = nil
	p18.pendingAgentMessageContent = {}
	p18.pendingAgentMessageSequenceIndex = nil
end
local function extractRobloxMeta(p19) -- line: 252
	local v135 = p19._meta and p19._meta._roblox

	if typeof(v135) == "table" then
		return v135
	end

	return nil
end
local function recordEventMeta(p20, n2: number?, p21) -- line: 257
	if typeof(n2) ~= "number" or n2 < 0 then
		return
	end

	local v139 = p21._meta and p21._meta._roblox
	local v140 = if typeof(v139) ~= "table" then nil else v139

	if v140 == nil then
		return
	end

	local turnId = v140.turnId
	local emittedTime = v140.emittedTime
	local referenceId = v140.referenceId
	local v144 = typeof(turnId) == "number" and turnId > 0
	local v145 = typeof(emittedTime) == "string" and emittedTime ~= ""
	local v146 = typeof(referenceId) == "string" and referenceId ~= ""

	if not v144 and not v145 and not v146 then
		return
	end

	local v147 = if p20.eventMetaBySequenceId == nil then {} else table.clone(p20.eventMetaBySequenceId)
	local v148 = if v147[n2] == nil then {} else table.clone(v147[n2])

	if v144 then
		v148.turnId = turnId
	end

	if v145 then
		v148.emittedTime = emittedTime
	end

	if v146 then
		v148.referenceId = referenceId
	end

	v147[n2] = v148
	p20.eventMetaBySequenceId = v147
end
local function extractTurnId(p22) -- line: 296
	local v150 = p22._meta and p22._meta._roblox
	local v151 = if typeof(v150) ~= "table" then nil else v150
	local v152 = if typeof(v151) ~= "table" then nil else v151.turnId

	if typeof(v152) == "number" and v152 > 0 then
		return v152
	end

	return nil
end
local function extractReferenceId(p23) -- line: 302
	local v154 = p23._meta and p23._meta._roblox
	local v155 = if typeof(v154) ~= "table" then nil else v154
	local v156 = if typeof(v155) ~= "table" then nil else v155.referenceId

	if typeof(v156) == "string" and v156 ~= "" then
		return v156
	end

	return nil
end
local function applyToolCallUpdate(p24, p25, p26) -- line: 308
	-- upvalues: buildActivityItems (copy)
	local toolCallId = p25.toolCallId

	if typeof(toolCallId) ~= "string" or toolCallId == "" then
		return
	end

	local v161 = p24.toolCalls[toolCallId]
	local v162 = v161 == nil
	local v163 = if v161 == nil then {
		toolCallId = toolCallId
	} else table.clone(v161)
	local g176 = nil
	local v175 = nil

	if p25.title ~= nil then
		v163.title = p25.title
	end

	if p25.kind ~= nil then
		v163.kind = p25.kind
	end

	if p25.status ~= nil then
		v163.status = p25.status
	end

	if p25.rawInput ~= nil then
		v163.rawInput = p25.rawInput
	end

	if p25.rawOutput ~= nil then
		v163.rawOutput = p25.rawOutput
	end

	if p25.content ~= nil then
		v163.content = p25.content
	end

	local v164 = p25._meta and p25._meta._roblox
	local v165 = if typeof(v164) ~= "table" then nil else v164
	local v166 = if typeof(v165) ~= "table" then nil else v165.turnId
	local v167 = if typeof(v166) ~= "number" or not (v166 > 0) then nil else v166

	if v167 ~= nil then
		v163.turnId = v167
	end

	local v168 = p25._meta and p25._meta._roblox
	local v169 = if typeof(v168) ~= "table" then nil else v168
	local v170 = if typeof(v169) ~= "table" then nil else v169.referenceId
	local v171 = if typeof(v170) ~= "string" or v170 == "" then nil else v170

	if v171 ~= nil then
		v163.referenceId = v171
	end

	local v172 = table.clone(p24.toolCalls)

	v172[toolCallId] = v163
	p24.toolCalls = v172

	if v162 then
		p24.toolCallCount = p24.toolCallCount + 1
	end

	if not v162 then
		for _, v174 in p24.activitySlots do
			if v174.kind == "tool_call" and toolCallId == v174.toolCallId then
				v175 = true
				g176 = true
			end

			if g176 then
				break
			end
		end

		if not g176 then
			v175 = false
		end

		g176 = false

		if v175 then
			p24.activityItems = buildActivityItems(p24.activitySlots, p24.toolCalls)

			return
		end
	end

	local t27 = {
		kind = "tool_call",
		toolCallId = toolCallId
	}
	local v178 = if p26 == nil then nil else p26.sequenceNumber
	local v179 = if typeof(v178) == "number" and not (v178 < 0) then v178 + 1 else nil

	if v179 == nil then
		return
	end

	if v179 <= 0 then
		return
	end

	local v180 = table.clone(p24.activitySlots)

	v180[v179] = t27
	p24.activitySlots = v180
	p24.activityItems = buildActivityItems(p24.activitySlots, p24.toolCalls)
end
local function applyToolCallContentChunk(p27, p28, p29) -- line: 357
	-- upvalues: buildActivityItems (copy)
	local toolCallId = p28.toolCallId
	local content = p28.content

	if typeof(toolCallId) ~= "string" or toolCallId == "" or typeof(content) ~= "table" then
		return
	end

	local v186 = p27.toolCalls[toolCallId]
	local v187 = v186 == nil
	local v188 = if v186 == nil then {
		toolCallId = toolCallId
	} else table.clone(v186)
	local content2 = v188.content
	local g197 = nil
	local v196 = nil
	local t28

	if content2 ~= nil then
		t28 = {}

		for _, v192 in content2 do
			table.insert(t28, v192)
		end
	else
		t28 = {}
	end

	table.insert(t28, content)
	v188.content = t28

	local v193 = table.clone(p27.toolCalls)

	v193[toolCallId] = v188
	p27.toolCalls = v193

	if v187 then
		p27.toolCallCount = p27.toolCallCount + 1
	end

	if not v187 then
		for _, v195 in p27.activitySlots do
			if v195.kind == "tool_call" and toolCallId == v195.toolCallId then
				v196 = true
				g197 = true
			end

			if g197 then
				break
			end
		end

		if not g197 then
			v196 = false
		end

		g197 = false

		if v196 then
			p27.activityItems = buildActivityItems(p27.activitySlots, p27.toolCalls)

			return
		end
	end

	local t29 = {
		kind = "tool_call",
		toolCallId = toolCallId
	}
	local v199 = if p29 == nil then nil else p29.sequenceNumber
	local v200 = if typeof(v199) == "number" and not (v199 < 0) then v199 + 1 else nil

	if v200 == nil then
		return
	end

	if v200 <= 0 then
		return
	end

	local v201 = table.clone(p27.activitySlots)

	v201[v200] = t29
	p27.activitySlots = v201
	p27.activityItems = buildActivityItems(p27.activitySlots, p27.toolCalls)
end

return {
	applySessionUpdate = function(p30, p31, p32) -- line: 386
		-- upvalues: recordEventMeta (copy), flushPendingAgentMessageToAssistant (copy), flushPendingAgentMessageToActivity (copy), messageMapToText (copy), appendPendingAgentMessage (copy), applyToolCallUpdate (copy), applyToolCallContentChunk (copy)
		local sessionUpdate = p31.sessionUpdate
		local v206 = table.clone(p30)
		local v207 = if p32 == nil then nil else p32.sequenceNumber

		recordEventMeta(v206, v207, p31)

		local g220 = nil
		local v219 = nil

		if v206.status == "queued" then
			v206.status = "streaming"
		end

		if sessionUpdate ~= "agent_message_chunk" then
			if sessionUpdate == "state_change" and p31.state == "idle" then
				flushPendingAgentMessageToAssistant(v206)
			else
				flushPendingAgentMessageToActivity(v206)
			end
		end

		if sessionUpdate == "agent_message" then
			local messageId = p31.messageId
			local v209 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v209 ~= nil and typeof(content) == "table" then
				local assistantMessages = v206.assistantMessages
				local assistantMessageOrder = v206.assistantMessageOrder
				local v213 = table.clone(assistantMessages)
				local t30 = {}

				for _, v216 in content do
					table.insert(t30, v216)
				end

				v213[v209] = t30

				for _, v218 in assistantMessageOrder do
					if v218 == v209 then
						v219 = assistantMessageOrder
						g220 = true
					end

					if g220 then
						break
					end
				end

				if not g220 then
					v219 = {}

					for _, v222 in assistantMessageOrder do
						table.insert(v219, v222)
					end

					table.insert(v219, v209)
				end

				g220 = false
				v206.assistantMessages = v213
				v206.assistantMessageOrder = v219
				v206.assistantText = messageMapToText(v206.assistantMessages, v206.assistantMessageOrder)

				return v206
			end
		elseif sessionUpdate == "agent_message_chunk" then
			local messageId = p31.messageId
			local v224 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v224 ~= nil and typeof(content) == "table" then
				appendPendingAgentMessage(v206, v224, content, p32)

				return v206
			end
		else
			if sessionUpdate == "tool_call_update" then
				applyToolCallUpdate(v206, p31, p32)

				return v206
			end

			if sessionUpdate == "tool_call_content_chunk" then
				applyToolCallContentChunk(v206, p31, p32)

				return v206
			end

			if sessionUpdate == "state_change" then
				if p31.state == "running" or p31.state == "requires_action" then
					v206.status = "streaming"

					return v206
				end

				if p31.state == "idle" then
					local stop_reason = p31.stop_reason

					if typeof(stop_reason) == "string" then
						v206.stopReason = stop_reason
					else
						v206.stopReason = "end_turn"
					end

					v206.status = v206.stopReason ~= "cancelled" and "succeeded" or "cancelled"
					v206.isDone = true

					return v206
				end
			elseif sessionUpdate == "session_info_update" then
				v206.infoUpdate = {
					title = p31.title
				}
			end
		end

		return v206
	end,
	createEmptyTurnState = function(s7: string, p33) -- line: 19
		return {
			status = "queued",
			assistantText = "",
			pendingAgentMessageId = nil,
			pendingAgentMessageSequenceIndex = nil,
			toolCallCount = 0,
			infoUpdate = nil,
			stopReason = nil,
			error = nil,
			errorCode = nil,
			isDone = false,
			sessionId = s7,
			requestId = p33,
			assistantMessages = {},
			assistantMessageOrder = {},
			pendingAgentMessageContent = {},
			activitySlots = {},
			activityItems = {},
			toolCalls = {},
			eventMetaBySequenceId = {}
		}
	end
}
