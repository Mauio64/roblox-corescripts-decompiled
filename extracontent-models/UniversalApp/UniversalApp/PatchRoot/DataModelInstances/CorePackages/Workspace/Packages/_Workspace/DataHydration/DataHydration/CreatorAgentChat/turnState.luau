require(script.Parent.types)

local function getSequenceIndex(p1) -- line: 45
	local v29 = if p1 == nil then nil else p1.sequenceNumber

	if typeof(v29) ~= "number" or v29 < 0 then
		return nil
	end

	return v29 + 1
end
local function getMessageId(p2) -- line: 53
	local messageId = p2.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end
local function cloneArray(t1: {[any]: any}) -- line: 58
	local t2 = {}

	for _, v35 in t1 do
		table.insert(t2, v35)
	end

	return t2
end
local function contentBlocksToText(t3: {[any]: any}) -- line: 66
	local t4 = {}

	for _, v39 in t3 do
		if v39.type == "text" and typeof(v39.text) == "string" then
			table.insert(t4, v39.text)
		end
	end

	return table.concat(t4)
end
local function messageMapToText(t5: {[any]: any}, t6: {[any]: any}) -- line: 76
	-- upvalues: contentBlocksToText (copy)
	local t7 = {}

	for _, v44 in t6 do
		local v45 = t5[v44]

		if v45 ~= nil then
			table.insert(t7, contentBlocksToText(v45))
		end
	end

	return table.concat(t7)
end
local function ensureMessageOrder(t8: {[any]: any}, s1: string) -- line: 87
	for _, v49 in t8 do
		if v49 == s1 then
			return t8
		end
	end

	local t9 = {}

	for _, v52 in t8 do
		table.insert(t9, v52)
	end

	table.insert(t9, s1)

	return t9
end
local function replaceMessageContent(t10: {[any]: any}, t11: {[any]: any}, s2: string, t12: {[any]: any}) -- line: 98
	local v57 = table.clone(t10)
	local t13 = {}

	for _, v60 in t12 do
		table.insert(t13, v60)
	end

	v57[s2] = t13

	for _, v62 in t11 do
		if v62 == s2 then
			return v57, t11
		end
	end

	local t14 = {}

	for _, v65 in t11 do
		table.insert(t14, v65)
	end

	table.insert(t14, s2)

	return v57, t14
end
local function appendMessageContent(t15: {[any]: any}, t16: {[any]: any}, s3: string, p3) -- line: 109
	local v70 = table.clone(t15)
	local v71 = v70[s3]
	local t17

	if v71 ~= nil then
		t17 = {}

		for _, v74 in v71 do
			table.insert(t17, v74)
		end
	else
		t17 = {}
	end

	table.insert(t17, p3)
	v70[s3] = t17

	for _, v76 in t16 do
		if v76 == s3 then
			return v70, t16
		end
	end

	local t18 = {}

	for _, v79 in t16 do
		table.insert(t18, v79)
	end

	table.insert(t18, s3)

	return v70, t18
end
local function buildContiguousThoughtText(t19: {[any]: any}) -- line: 123
	local t20 = {}

	for i = 1, #t19 do
		local v83 = t19[i]

		if v83 ~= "" then
			table.insert(t20, v83)
		end
	end

	return table.concat(t20)
end
local function buildActivityItems(t21: {[any]: any}, t22: {[any]: any}) -- line: 134
	local t23 = {}
	local t24 = {}
	local t25 = {}

	local function flushThought() -- line: 142
		-- upvalues: t24 (ref), t23 (copy)
		if #t24 == 0 then
			return
		end

		table.insert(t23, {
			kind = "thought",
			text = table.concat(t24)
		})
		t24 = {}
	end

	for v90 in t21 do
		table.insert(t25, v90)
	end

	table.sort(t25)

	for _, v92 in t25 do
		local v93 = t21[v92]

		if v93.kind == "agent_message" then
			flushThought()
			table.insert(t23, {
				kind = "agent_message",
				text = v93.text
			})
		elseif v93.kind == "thought" then
			table.insert(t24, v93.text)
		elseif v93.kind == "tool_call" then
			flushThought()

			local v94 = t22[v93.toolCallId]

			table.insert(t23, {
				kind = "tool_call",
				toolCallId = v93.toolCallId,
				title = if not v94 then nil else v94.title,
				status = if not v94 then nil else v94.status
			})
		end
	end

	flushThought()

	return t23
end
local function refreshActivityItems(p4) -- line: 184
	-- upvalues: buildActivityItems (copy)
	p4.activityItems = buildActivityItems(p4.activitySlots, p4.toolCalls)
end
local function recordActivitySlotAtIndex(p5, n1: number, p6) -- line: 188
	-- upvalues: buildActivityItems (copy)
	if n1 <= 0 then
		return
	end

	local v99 = table.clone(p5.activitySlots)

	v99[n1] = p6
	p5.activitySlots = v99
	p5.activityItems = buildActivityItems(p5.activitySlots, p5.toolCalls)
end
local function recordActivitySlot(p7, p8, p9) -- line: 199
	-- upvalues: buildActivityItems (copy)
	local v103 = if p8 == nil then nil else p8.sequenceNumber
	local v104 = if typeof(v103) == "number" and not (v103 < 0) then v103 + 1 else nil

	if v104 == nil then
		return
	end

	if v104 <= 0 then
		return
	end

	local v105 = table.clone(p7.activitySlots)

	v105[v104] = p9
	p7.activitySlots = v105
	p7.activityItems = buildActivityItems(p7.activitySlots, p7.toolCalls)
end
local function recordThoughtSequenceSlot(p10, p11, s4: string?) -- line: 208
	-- upvalues: buildContiguousThoughtText (copy), buildActivityItems (copy)
	local v109 = if p11 == nil then nil else p11.sequenceNumber
	local v110 = if typeof(v109) == "number" and not (v109 < 0) then v109 + 1 else nil

	if v110 == nil then
		return
	end

	if s4 == nil then
		local v111 = table.clone(p10.thoughtChunks)

		v111[v110] = v111[v110] or ""
		p10.thoughtChunks = v111
		p10.thoughtText = buildContiguousThoughtText(v111)

		local t26 = {
			kind = "empty"
		}
		local v113 = if p11 == nil then nil else p11.sequenceNumber
		local v114 = if typeof(v113) == "number" and not (v113 < 0) then v113 + 1 else nil

		if v114 == nil then
			return
		end

		if v114 <= 0 then
			return
		end

		local v115 = table.clone(p10.activitySlots)

		v115[v114] = t26
		p10.activitySlots = v115
		p10.activityItems = buildActivityItems(p10.activitySlots, p10.toolCalls)

		return
	end

	local v116 = table.clone(p10.thoughtChunks)

	v116[v110] = s4
	p10.thoughtChunks = v116
	p10.thoughtText = buildContiguousThoughtText(v116)

	local t27 = {
		kind = "thought",
		text = s4
	}
	local v118 = if p11 == nil then nil else p11.sequenceNumber
	local v119 = if typeof(v118) == "number" and not (v118 < 0) then v118 + 1 else nil

	if v119 == nil then
		return
	end

	if v119 <= 0 then
		return
	end

	local v120 = table.clone(p10.activitySlots)

	v120[v119] = t27
	p10.activitySlots = v120
	p10.activityItems = buildActivityItems(p10.activitySlots, p10.toolCalls)
end
local function recordToolCallSequenceSlot(p12, p13, s5: string) -- line: 230
	-- upvalues: buildActivityItems (copy)
	local t28 = {
		kind = "tool_call",
		toolCallId = s5
	}
	local v125 = if p13 == nil then nil else p13.sequenceNumber
	local v126 = if typeof(v125) == "number" and not (v125 < 0) then v125 + 1 else nil

	if v126 == nil then
		return
	end

	if v126 <= 0 then
		return
	end

	local v127 = table.clone(p12.activitySlots)

	v127[v126] = t28
	p12.activitySlots = v127
	p12.activityItems = buildActivityItems(p12.activitySlots, p12.toolCalls)
end
local function hasToolCallActivitySlot(p14, s6: string) -- line: 234
	for _, v131 in p14.activitySlots do
		if v131.kind == "tool_call" and s6 == v131.toolCallId then
			return true
		end
	end

	return false
end
local function clearPendingAgentMessage(p15) -- line: 243
	p15.pendingAgentMessageId = nil
	p15.pendingAgentMessageContent = {}
	p15.pendingAgentMessageSequenceIndex = nil
end
local function appendPendingAgentMessage(p16, s7: string, p17, p18) -- line: 249
	-- upvalues: contentBlocksToText (copy), buildActivityItems (copy)
	if p16.pendingAgentMessageId ~= nil and s7 ~= p16.pendingAgentMessageId then
		local v137 = contentBlocksToText(p16.pendingAgentMessageContent)

		if v137 ~= "" then
			local pendingAgentMessageSequenceIndex = p16.pendingAgentMessageSequenceIndex

			if pendingAgentMessageSequenceIndex ~= nil then
				local t29 = {
					kind = "agent_message",
					text = v137
				}

				if not (pendingAgentMessageSequenceIndex <= 0) then
					local v140 = table.clone(p16.activitySlots)

					v140[pendingAgentMessageSequenceIndex] = t29
					p16.activitySlots = v140
					p16.activityItems = buildActivityItems(p16.activitySlots, p16.toolCalls)
				end
			end
		end

		p16.pendingAgentMessageId = nil
		p16.pendingAgentMessageContent = {}
		p16.pendingAgentMessageSequenceIndex = nil
	end

	local t30 = {}

	for _, v143 in p16.pendingAgentMessageContent do
		table.insert(t30, v143)
	end

	table.insert(t30, p17)
	p16.pendingAgentMessageId = s7
	p16.pendingAgentMessageContent = t30

	if p16.pendingAgentMessageSequenceIndex == nil then
		local v144 = if p18 == nil then nil else p18.sequenceNumber

		p16.pendingAgentMessageSequenceIndex = if typeof(v144) == "number" and not (v144 < 0) then v144 + 1 else nil
	end
end
local function flushPendingAgentMessageToActivity(p19) -- line: 275
	-- upvalues: contentBlocksToText (copy), buildActivityItems (copy)
	local v146 = contentBlocksToText(p19.pendingAgentMessageContent)

	if v146 ~= "" then
		local pendingAgentMessageSequenceIndex = p19.pendingAgentMessageSequenceIndex

		if pendingAgentMessageSequenceIndex ~= nil then
			local t31 = {
				kind = "agent_message",
				text = v146
			}

			if not (pendingAgentMessageSequenceIndex <= 0) then
				local v149 = table.clone(p19.activitySlots)

				v149[pendingAgentMessageSequenceIndex] = t31
				p19.activitySlots = v149
				p19.activityItems = buildActivityItems(p19.activitySlots, p19.toolCalls)
			end
		end
	end

	p19.pendingAgentMessageId = nil
	p19.pendingAgentMessageContent = {}
	p19.pendingAgentMessageSequenceIndex = nil
end
local function flushPendingAgentMessageToAssistant(p20) -- line: 286
	-- upvalues: appendMessageContent (copy), messageMapToText (copy)
	local pendingAgentMessageId = p20.pendingAgentMessageId

	if pendingAgentMessageId == nil then
		p20.pendingAgentMessageId = nil
		p20.pendingAgentMessageContent = {}
		p20.pendingAgentMessageSequenceIndex = nil

		return
	end

	local assistantMessages = p20.assistantMessages
	local assistantMessageOrder = p20.assistantMessageOrder

	for _, v155 in p20.pendingAgentMessageContent do
		assistantMessages, assistantMessageOrder = appendMessageContent(assistantMessages, assistantMessageOrder, pendingAgentMessageId, v155)
	end

	p20.assistantMessages = assistantMessages
	p20.assistantMessageOrder = assistantMessageOrder
	p20.assistantText = messageMapToText(assistantMessages, assistantMessageOrder)
	p20.pendingAgentMessageId = nil
	p20.pendingAgentMessageContent = {}
	p20.pendingAgentMessageSequenceIndex = nil
end
local function extractRobloxMeta(p21) -- line: 304
	local v157 = p21._meta and p21._meta._roblox

	if typeof(v157) == "table" then
		return v157
	end

	return nil
end
local function extractTurnId(p22) -- line: 309
	local v159 = p22._meta and p22._meta._roblox
	local v160 = if typeof(v159) ~= "table" then nil else v159
	local v161 = if typeof(v160) ~= "table" then nil else v160.turnId

	if typeof(v161) == "number" and v161 > 0 then
		return v161
	end

	return nil
end
local function extractReferenceId(p23) -- line: 315
	local v163 = p23._meta and p23._meta._roblox
	local v164 = if typeof(v163) ~= "table" then nil else v163
	local v165 = if typeof(v164) ~= "table" then nil else v164.referenceId

	if typeof(v165) == "string" and v165 ~= "" then
		return v165
	end

	return nil
end
local function applyToolCallUpdate(p24, p25, p26) -- line: 321
	-- upvalues: buildActivityItems (copy)
	local toolCallId = p25.toolCallId

	if typeof(toolCallId) ~= "string" or toolCallId == "" then
		return
	end

	local v170 = p24.toolCalls[toolCallId]
	local v171 = v170 == nil
	local v172 = if v170 == nil then {
		toolCallId = toolCallId
	} else table.clone(v170)
	local g185 = nil
	local v184 = nil

	if p25.title ~= nil then
		v172.title = p25.title
	end

	if p25.kind ~= nil then
		v172.kind = p25.kind
	end

	if p25.status ~= nil then
		v172.status = p25.status
	end

	if p25.rawInput ~= nil then
		v172.rawInput = p25.rawInput
	end

	if p25.rawOutput ~= nil then
		v172.rawOutput = p25.rawOutput
	end

	if p25.content ~= nil then
		v172.content = p25.content
	end

	local v173 = p25._meta and p25._meta._roblox
	local v174 = if typeof(v173) ~= "table" then nil else v173
	local v175 = if typeof(v174) ~= "table" then nil else v174.turnId
	local v176 = if typeof(v175) ~= "number" or not (v175 > 0) then nil else v175

	if v176 ~= nil then
		v172.turnId = v176
	end

	local v177 = p25._meta and p25._meta._roblox
	local v178 = if typeof(v177) ~= "table" then nil else v177
	local v179 = if typeof(v178) ~= "table" then nil else v178.referenceId
	local v180 = if typeof(v179) ~= "string" or v179 == "" then nil else v179

	if v180 ~= nil then
		v172.referenceId = v180
	end

	local v181 = table.clone(p24.toolCalls)

	v181[toolCallId] = v172
	p24.toolCalls = v181

	if v171 then
		p24.toolCallCount = p24.toolCallCount + 1
	end

	if not v171 then
		for _, v183 in p24.activitySlots do
			if v183.kind == "tool_call" and toolCallId == v183.toolCallId then
				v184 = true
				g185 = true
			end

			if g185 then
				break
			end
		end

		if not g185 then
			v184 = false
		end

		g185 = false

		if v184 then
			p24.activityItems = buildActivityItems(p24.activitySlots, p24.toolCalls)

			return
		end
	end

	local t32 = {
		kind = "tool_call",
		toolCallId = toolCallId
	}
	local v187 = if p26 == nil then nil else p26.sequenceNumber
	local v188 = if typeof(v187) == "number" and not (v187 < 0) then v187 + 1 else nil

	if v188 == nil then
		return
	end

	if v188 <= 0 then
		return
	end

	local v189 = table.clone(p24.activitySlots)

	v189[v188] = t32
	p24.activitySlots = v189
	p24.activityItems = buildActivityItems(p24.activitySlots, p24.toolCalls)
end
local function applyToolCallContentChunk(p27, p28, p29) -- line: 370
	-- upvalues: buildActivityItems (copy)
	local toolCallId = p28.toolCallId
	local content = p28.content

	if typeof(toolCallId) ~= "string" or toolCallId == "" or typeof(content) ~= "table" then
		return
	end

	local v195 = p27.toolCalls[toolCallId]
	local v196 = v195 == nil
	local v197 = if v195 == nil then {
		toolCallId = toolCallId
	} else table.clone(v195)
	local content2 = v197.content
	local g206 = nil
	local v205 = nil
	local t33

	if content2 ~= nil then
		t33 = {}

		for _, v201 in content2 do
			table.insert(t33, v201)
		end
	else
		t33 = {}
	end

	table.insert(t33, content)
	v197.content = t33

	local v202 = table.clone(p27.toolCalls)

	v202[toolCallId] = v197
	p27.toolCalls = v202

	if v196 then
		p27.toolCallCount = p27.toolCallCount + 1
	end

	if not v196 then
		for _, v204 in p27.activitySlots do
			if v204.kind == "tool_call" and toolCallId == v204.toolCallId then
				v205 = true
				g206 = true
			end

			if g206 then
				break
			end
		end

		if not g206 then
			v205 = false
		end

		g206 = false

		if v205 then
			p27.activityItems = buildActivityItems(p27.activitySlots, p27.toolCalls)

			return
		end
	end

	local t34 = {
		kind = "tool_call",
		toolCallId = toolCallId
	}
	local v208 = if p29 == nil then nil else p29.sequenceNumber
	local v209 = if typeof(v208) == "number" and not (v208 < 0) then v208 + 1 else nil

	if v209 == nil then
		return
	end

	if v209 <= 0 then
		return
	end

	local v210 = table.clone(p27.activitySlots)

	v210[v209] = t34
	p27.activitySlots = v210
	p27.activityItems = buildActivityItems(p27.activitySlots, p27.toolCalls)
end

return {
	applySessionUpdate = function(p30, p31, p32) -- line: 399
		-- upvalues: flushPendingAgentMessageToAssistant (copy), flushPendingAgentMessageToActivity (copy), buildContiguousThoughtText (copy), buildActivityItems (copy), messageMapToText (copy), appendPendingAgentMessage (copy), recordThoughtSequenceSlot (copy), applyToolCallUpdate (copy), applyToolCallContentChunk (copy)
		local sessionUpdate = p31.sessionUpdate
		local v215 = table.clone(p30)
		local g235 = nil
		local v234 = nil
		local g253 = nil
		local v252 = nil

		if v215.status == "queued" then
			v215.status = "streaming"
		end

		if sessionUpdate ~= "agent_message_chunk" then
			if sessionUpdate == "state_change" and p31.state == "idle" then
				flushPendingAgentMessageToAssistant(v215)
			else
				flushPendingAgentMessageToActivity(v215)
			end
		end

		if sessionUpdate ~= "agent_thought" and sessionUpdate ~= "agent_thought_chunk" then
			local v216 = if p32 == nil then nil else p32.sequenceNumber
			local v217 = if typeof(v216) == "number" and not (v216 < 0) then v216 + 1 else nil

			if v217 ~= nil then
				local v218 = table.clone(v215.thoughtChunks)

				v218[v217] = v218[v217] or ""
				v215.thoughtChunks = v218
				v215.thoughtText = buildContiguousThoughtText(v218)

				local t35 = {
					kind = "empty"
				}
				local v220 = if p32 == nil then nil else p32.sequenceNumber
				local v221 = if typeof(v220) == "number" and not (v220 < 0) then v220 + 1 else nil

				if v221 ~= nil and not (v221 <= 0) then
					local v222 = table.clone(v215.activitySlots)

					v222[v221] = t35
					v215.activitySlots = v222
					v215.activityItems = buildActivityItems(v215.activitySlots, v215.toolCalls)
				end
			end
		end

		if sessionUpdate == "agent_message" then
			local messageId = p31.messageId
			local v224 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v224 ~= nil and typeof(content) == "table" then
				local assistantMessages = v215.assistantMessages
				local assistantMessageOrder = v215.assistantMessageOrder
				local v228 = table.clone(assistantMessages)
				local t36 = {}

				for _, v231 in content do
					table.insert(t36, v231)
				end

				v228[v224] = t36

				for _, v233 in assistantMessageOrder do
					if v233 == v224 then
						v234 = assistantMessageOrder
						g235 = true
					end

					if g235 then
						break
					end
				end

				if not g235 then
					v234 = {}

					for _, v237 in assistantMessageOrder do
						table.insert(v234, v237)
					end

					table.insert(v234, v224)
				end

				g235 = false
				v215.assistantMessages = v228
				v215.assistantMessageOrder = v234
				v215.assistantText = messageMapToText(v215.assistantMessages, v215.assistantMessageOrder)

				return v215
			end
		elseif sessionUpdate == "agent_message_chunk" then
			local messageId = p31.messageId
			local v239 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v239 ~= nil and typeof(content) == "table" then
				appendPendingAgentMessage(v215, v239, content, p32)

				return v215
			end
		elseif sessionUpdate == "agent_thought" then
			local messageId = p31.messageId
			local v242 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v242 ~= nil and typeof(content) == "table" then
				local thoughtMessages = v215.thoughtMessages
				local thoughtMessageOrder = v215.thoughtMessageOrder
				local v246 = table.clone(thoughtMessages)
				local t37 = {}

				for _, v249 in content do
					table.insert(t37, v249)
				end

				v246[v242] = t37

				for _, v251 in thoughtMessageOrder do
					if v251 == v242 then
						v252 = thoughtMessageOrder
						g253 = true
					end

					if g253 then
						break
					end
				end

				if not g253 then
					v252 = {}

					for _, v255 in thoughtMessageOrder do
						table.insert(v252, v255)
					end

					table.insert(v252, v242)
				end

				g253 = false
				v215.thoughtMessages = v246
				v215.thoughtMessageOrder = v252

				local v256 = messageMapToText(v215.thoughtMessages, v215.thoughtMessageOrder)

				v215.thoughtText = v256

				local t38 = {
					kind = "thought",
					text = v256
				}
				local v258 = if p32 == nil then nil else p32.sequenceNumber
				local v259 = if typeof(v258) == "number" and not (v258 < 0) then v258 + 1 else nil

				if v259 == nil then
					return v215
				end

				if v259 <= 0 then
					return v215
				end

				local v260 = table.clone(v215.activitySlots)

				v260[v259] = t38
				v215.activitySlots = v260
				v215.activityItems = buildActivityItems(v215.activitySlots, v215.toolCalls)

				return v215
			end
		elseif sessionUpdate == "agent_thought_chunk" then
			local messageId = p31.messageId
			local v262 = if typeof(messageId) ~= "string" or messageId == "" then nil else messageId
			local content = p31.content

			if v262 ~= nil and content and content.type == "text" and typeof(content.text) == "string" then
				recordThoughtSequenceSlot(v215, p32, content.text)

				return v215
			end
		else
			if sessionUpdate == "tool_call_update" then
				applyToolCallUpdate(v215, p31, p32)

				return v215
			end

			if sessionUpdate == "tool_call_content_chunk" then
				applyToolCallContentChunk(v215, p31, p32)

				return v215
			end

			if sessionUpdate == "state_change" then
				if p31.state == "running" or p31.state == "requires_action" then
					v215.status = "streaming"

					return v215
				end

				if p31.state == "idle" then
					local stop_reason = p31.stop_reason

					if typeof(stop_reason) == "string" then
						v215.stopReason = stop_reason
					else
						v215.stopReason = "end_turn"
					end

					v215.status = v215.stopReason ~= "cancelled" and "succeeded" or "cancelled"
					v215.isDone = true

					return v215
				end
			elseif sessionUpdate == "session_info_update" then
				v215.infoUpdate = {
					title = p31.title
				}
			end
		end

		return v215
	end,
	createEmptyTurnState = function(s8: string, p33) -- line: 18
		return {
			status = "queued",
			assistantText = "",
			pendingAgentMessageId = nil,
			pendingAgentMessageSequenceIndex = nil,
			thoughtText = "",
			toolCallCount = 0,
			infoUpdate = nil,
			stopReason = nil,
			error = nil,
			errorCode = nil,
			isDone = false,
			sessionId = s8,
			requestId = p33,
			assistantMessages = {},
			assistantMessageOrder = {},
			pendingAgentMessageContent = {},
			thoughtMessages = {},
			thoughtMessageOrder = {},
			thoughtChunks = {},
			activitySlots = {},
			activityItems = {},
			toolCalls = {}
		}
	end
}
