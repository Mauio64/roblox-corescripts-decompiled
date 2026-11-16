require(script.Parent.types)

local function getSequenceIndex(p) -- 2 equivalent calls inferred from this helper
	local sequenceNumber

	if p ~= nil then
		sequenceNumber = p.sequenceNumber
	end

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		return sequenceNumber + 1
	end

	return nil
end

local function getMessageId(data) -- 2 equivalent calls inferred from this helper
	local messageId = data.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end

local function cloneArray(items) -- 6 equivalent calls inferred from this helper
	local array = {}

	for _, item in items do
		table.insert(array, item)
	end

	return array
end

local function contentBlocksToText(items)
	local texts = {}

	for _, item in items do
		if item.type == "text" and typeof(item.text) == "string" then
			table.insert(texts, item.text)
		end
	end

	return table.concat(texts)
end

local function messageMapToText(assistantMessages, items)
	local v = {}

	for _, item in items do
		local v2 = assistantMessages[item]

		if v2 ~= nil then
			table.insert(v, contentBlocksToText(v2))
		end
	end

	return table.concat(v)
end

local function ensureMessageOrder(items, p: string)
	for _, item in items do
		if item == p then
			return items
		end
	end

	local array = cloneArray(items) -- inferred equivalent call
	table.insert(array, p)
	return array
end

local function replaceMessageContent(p, items, p2: string, items2)
	local clone = table.clone(p)
	clone[p2] = cloneArray(items2) -- inferred equivalent call

	for _, item in items do
		if item == p2 then
			return clone, items
		end
	end

	local array = cloneArray(items) -- inferred equivalent call
	table.insert(array, p2)
	return clone, array
end

local function appendMessageContent(assistantMessages, items, pendingAgentMessageId: string, p)
	local clone = table.clone(assistantMessages)
	local v = clone[pendingAgentMessageId]
	local v2

	if v == nil then
		v2 = {}
	else
		v2 = {}

		for _, v3 in v do
			table.insert(v2, v3)
		end
	end

	table.insert(v2, p)
	clone[pendingAgentMessageId] = v2

	for _, item in items do
		if item == pendingAgentMessageId then
			return clone, items
		end
	end

	local array = cloneArray(items) -- inferred equivalent call
	table.insert(array, pendingAgentMessageId)
	return clone, array
end

local function buildActivityItems(activitySlots, toolCalls)
	local v = {}
	local activityItems = {}

	for k in activitySlots do
		table.insert(v, k)
	end

	table.sort(v)

	for _, v2 in v do
		local item = activitySlots[v2]

		if item.kind == "agent_message" then
			table.insert(activityItems, { kind = "agent_message", text = item.text })
		elseif item.kind == "tool_call" then
			local v3 = toolCalls[item.toolCallId]
			local v4 = { kind = "tool_call", toolCallId = item.toolCallId, title = 0, status = 0 }
			local title

			if v3 then
				title = v3.title
			end

			v4.title = title
			local status

			if v3 then
				status = v3.status
			end

			v4.status = status
			table.insert(activityItems, v4)
		end
	end

	return activityItems
end

local function refreshActivityItems(state) -- 3 equivalent calls inferred from this helper
	state.activityItems = buildActivityItems(state.activitySlots, state.toolCalls)
end

local function recordActivitySlotAtIndex(state, p: number, p2) -- 3 equivalent calls inferred from this helper
	if p <= 0 then
		return
	end

	local clone = table.clone(state.activitySlots)
	clone[p] = p2
	state.activitySlots = clone
	refreshActivityItems(state) -- inferred equivalent call
end

local function recordActivitySlot(p, p2, p3) -- 1 equivalent call inferred from this helper
	local sequenceIndex = getSequenceIndex(p2) -- inferred equivalent call

	if sequenceIndex == nil then
		return
	end

	recordActivitySlotAtIndex(p, sequenceIndex, p3) -- inferred equivalent call
end

local function recordToolCallSequenceSlot(state, p, toolCallId: string) -- 2 equivalent calls inferred from this helper
	recordActivitySlot(state, p, { kind = "tool_call", toolCallId = toolCallId }) -- inferred equivalent call
end

local function hasToolCallActivitySlot(state, toolCallId: string): boolean -- 2 equivalent calls inferred from this helper
	for _, activitySlot in state.activitySlots do
		if activitySlot.kind == "tool_call" and activitySlot.toolCallId == toolCallId then
			return true
		end
	end

	return false
end

local function clearPendingAgentMessage(p) -- 4 equivalent calls inferred from this helper
	p.pendingAgentMessageId = nil
	p.pendingAgentMessageContent = {}
	p.pendingAgentMessageSequenceIndex = nil
end

local function appendPendingAgentMessage(clone, messageId: string, content, p)
	if clone.pendingAgentMessageId ~= nil and clone.pendingAgentMessageId ~= messageId then
		local text = contentBlocksToText(clone.pendingAgentMessageContent)

		if text ~= "" then
			local pendingAgentMessageSequenceIndex = clone.pendingAgentMessageSequenceIndex

			if pendingAgentMessageSequenceIndex ~= nil then
				recordActivitySlotAtIndex(clone, pendingAgentMessageSequenceIndex, { -- inferred equivalent call
					kind = "agent_message",
					text = text
				})
			end
		end

		clearPendingAgentMessage(clone) -- inferred equivalent call
	end

	local pendingAgentMessageContent = {}

	for _, v in clone.pendingAgentMessageContent do
		table.insert(pendingAgentMessageContent, v)
	end

	table.insert(pendingAgentMessageContent, content)
	clone.pendingAgentMessageId = messageId
	clone.pendingAgentMessageContent = pendingAgentMessageContent

	if clone.pendingAgentMessageSequenceIndex == nil then
		clone.pendingAgentMessageSequenceIndex = getSequenceIndex(p) -- inferred equivalent call
	end
end

local function flushPendingAgentMessageToActivity(clone)
	local text = contentBlocksToText(clone.pendingAgentMessageContent)

	if text ~= "" then
		local pendingAgentMessageSequenceIndex = clone.pendingAgentMessageSequenceIndex

		if pendingAgentMessageSequenceIndex ~= nil then
			recordActivitySlotAtIndex(clone, pendingAgentMessageSequenceIndex, { -- inferred equivalent call
				kind = "agent_message",
				text = text
			})
		end
	end

	clearPendingAgentMessage(clone) -- inferred equivalent call
end

local function flushPendingAgentMessageToAssistant(clone)
	local pendingAgentMessageId = clone.pendingAgentMessageId

	if pendingAgentMessageId == nil then
		clearPendingAgentMessage(clone) -- inferred equivalent call
	else
		local assistantMessages = clone.assistantMessages
		local assistantMessageOrder = clone.assistantMessageOrder

		for _, v in clone.pendingAgentMessageContent do
			assistantMessages, assistantMessageOrder = appendMessageContent(
				assistantMessages,
				assistantMessageOrder,
				pendingAgentMessageId,
				v
			)
		end

		clone.assistantMessages = assistantMessages
		clone.assistantMessageOrder = assistantMessageOrder
		clone.assistantText = messageMapToText(assistantMessages, assistantMessageOrder)
		clearPendingAgentMessage(clone) -- inferred equivalent call
	end
end

local function extractRobloxMeta(p) -- 3 equivalent calls inferred from this helper
	local roblox = p._meta and p._meta._roblox
	return if typeof(roblox) == "table" then roblox else nil
end

local function recordEventMeta(clone, value: number?, data)
	if typeof(value) ~= "number" or value < 0 then
		return
	end

	local roblox = extractRobloxMeta(data) -- inferred equivalent call

	if roblox == nil then
		return
	end

	local turnId = roblox.turnId
	local emittedTime = roblox.emittedTime
	local referenceId = roblox.referenceId
	local v

	if typeof(turnId) == "number" then
		v = turnId > 0
	else
		v = false
	end

	local v2

	if typeof(emittedTime) == "string" then
		v2 = emittedTime ~= ""
	else
		v2 = false
	end

	local v3

	if typeof(referenceId) == "string" then
		v3 = referenceId ~= ""
	else
		v3 = false
	end

	if not (v or v2 or v3) then
		return
	end

	local eventMetaBySequenceId = clone.eventMetaBySequenceId == nil and {} or table.clone(clone.eventMetaBySequenceId)
	local v4 = eventMetaBySequenceId[value] == nil and {} or table.clone(eventMetaBySequenceId[value])

	if v then
		v4.turnId = turnId
	end

	if v2 then
		v4.emittedTime = emittedTime
	end

	if v3 then
		v4.referenceId = referenceId
	end

	eventMetaBySequenceId[value] = v4
	clone.eventMetaBySequenceId = eventMetaBySequenceId
end

local function extractTurnId(data) -- 1 equivalent call inferred from this helper
	local roblox = extractRobloxMeta(data) -- inferred equivalent call
	local turnId

	if typeof(roblox) == "table" then
		turnId = roblox.turnId
	end

	if typeof(turnId) == "number" and turnId > 0 then
		return turnId
	end

	return nil
end

local function extractReferenceId(data) -- 1 equivalent call inferred from this helper
	local roblox = extractRobloxMeta(data) -- inferred equivalent call
	local referenceId

	if typeof(roblox) == "table" then
		referenceId = roblox.referenceId
	end

	if typeof(referenceId) == "string" and referenceId ~= "" then
		return referenceId
	end

	return nil
end

local function applyToolCallUpdate(clone, data, p)
	local toolCallId = data.toolCallId

	if typeof(toolCallId) ~= "string" or toolCallId == "" then
		return
	end

	local toolCall = clone.toolCalls[toolCallId]
	local v = toolCall == nil
	local v2 = toolCall == nil and { toolCallId = toolCallId } or table.clone(toolCall)

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.kind ~= nil then
		v2.kind = data.kind
	end

	if data.status ~= nil then
		v2.status = data.status
	end

	if data.rawInput ~= nil then
		v2.rawInput = data.rawInput
	end

	if data.rawOutput ~= nil then
		v2.rawOutput = data.rawOutput
	end

	if data.content ~= nil then
		v2.content = data.content
	end

	local turnId = extractTurnId(data) -- inferred equivalent call

	if turnId ~= nil then
		v2.turnId = turnId
	end

	local referenceId = extractReferenceId(data) -- inferred equivalent call

	if referenceId ~= nil then
		v2.referenceId = referenceId
	end

	local clone2 = table.clone(clone.toolCalls)
	clone2[toolCallId] = v2
	clone.toolCalls = clone2

	if v then
		clone.toolCallCount += 1
	end

	if not v and hasToolCallActivitySlot(clone, toolCallId) then -- inferred equivalent call
		refreshActivityItems(clone) -- inferred equivalent call
		return
	end

	recordToolCallSequenceSlot(clone, p, toolCallId) -- inferred equivalent call
end

local function applyToolCallContentChunk(clone, data, p)
	local toolCallId = data.toolCallId
	local content = data.content

	if typeof(toolCallId) ~= "string" or toolCallId == "" or typeof(content) ~= "table" then
		return
	end

	local toolCall = clone.toolCalls[toolCallId]
	local v = toolCall == nil
	local v2 = toolCall == nil and { toolCallId = toolCallId } or table.clone(toolCall)
	local content2 = v2.content
	local content3

	if content2 == nil then
		content3 = {}
	else
		content3 = {}

		for _, v3 in content2 do
			table.insert(content3, v3)
		end
	end

	table.insert(content3, content)
	v2.content = content3

	local clone2 = table.clone(clone.toolCalls)
	clone2[toolCallId] = v2
	clone.toolCalls = clone2

	if v then
		clone.toolCallCount += 1
	end

	if not v and hasToolCallActivitySlot(clone, toolCallId) then -- inferred equivalent call
		refreshActivityItems(clone) -- inferred equivalent call
		return
	end

	recordToolCallSequenceSlot(clone, p, toolCallId) -- inferred equivalent call
end

local TurnState = {}

function TurnState.applySessionUpdate(p, data, p2)
	local sessionUpdate = data.sessionUpdate
	local clone = table.clone(p)
	local v

	if p2 ~= nil then
		v = p2.sequenceNumber
	end

	recordEventMeta(clone, v, data)

	if clone.status == "queued" then
		clone.status = "streaming"
	end

	if sessionUpdate ~= "agent_message_chunk" then
		if sessionUpdate == "state_change" and data.state == "idle" then
			flushPendingAgentMessageToAssistant(clone)
		else
			flushPendingAgentMessageToActivity(clone)
		end
	end

	if sessionUpdate == "agent_message" then
		local messageId = getMessageId(data) -- inferred equivalent call
		local content = data.content

		if messageId ~= nil and typeof(content) == "table" then
			local assistantMessages = clone.assistantMessages
			local assistantMessageOrder = clone.assistantMessageOrder
			local clone2 = table.clone(assistantMessages)
			clone2[messageId] = cloneArray(content) -- inferred equivalent call
			local flag = true

			for _, v2 in assistantMessageOrder do
				if v2 == messageId then
					flag = false
					break
				end
			end

			if flag then
				local array = cloneArray(assistantMessageOrder) -- inferred equivalent call
				table.insert(array, messageId)
				assistantMessageOrder = array
			end

			clone.assistantMessages = clone2
			clone.assistantMessageOrder = assistantMessageOrder

			clone.assistantText = messageMapToText(clone.assistantMessages, clone.assistantMessageOrder)
			return clone
		end
	elseif sessionUpdate == "agent_message_chunk" then
		local messageId = getMessageId(data) -- inferred equivalent call
		local content = data.content

		if messageId ~= nil and typeof(content) == "table" then
			appendPendingAgentMessage(clone, messageId, content, p2)
			return clone
		end
	else
		if sessionUpdate == "tool_call_update" then
			applyToolCallUpdate(clone, data, p2)
			return clone
		elseif sessionUpdate == "tool_call_content_chunk" then
			applyToolCallContentChunk(clone, data, p2)
			return clone
		end

		if sessionUpdate == "state_change" then
			if data.state == "running" or data.state == "requires_action" then
				clone.status = "streaming"
				return clone
			end

			if data.state == "idle" then
				local stop_reason = data.stop_reason

				if typeof(stop_reason) == "string" then
					clone.stopReason = stop_reason
				else
					clone.stopReason = "end_turn"
				end

				clone.status = clone.stopReason == "cancelled" and "cancelled" or "succeeded"
				clone.isDone = true
				return clone
			end
		elseif sessionUpdate == "session_info_update" then
			clone.infoUpdate = { title = data.title }
		end
	end

	return clone
end

function TurnState.createEmptyTurnState(sessionId: string, requestId)
	return {
		sessionId = sessionId,
		requestId = requestId,
		status = "queued",
		assistantText = "",
		assistantMessages = {},
		assistantMessageOrder = {},
		pendingAgentMessageId = nil,
		pendingAgentMessageContent = {},
		pendingAgentMessageSequenceIndex = nil,
		activitySlots = {},
		activityItems = {},
		toolCalls = {},
		toolCallCount = 0,
		infoUpdate = nil,
		stopReason = nil,
		error = nil,
		errorCode = nil,
		isDone = false,
		eventMetaBySequenceId = {}
	}
end

TurnState.extractTurnId = extractTurnId
return TurnState
