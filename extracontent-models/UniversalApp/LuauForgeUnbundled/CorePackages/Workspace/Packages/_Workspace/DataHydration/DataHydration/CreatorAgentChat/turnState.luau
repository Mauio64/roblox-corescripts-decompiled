require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local FFlagBuildExperienceThoughtStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagBuildExperienceThoughtStatus")

local function getSequenceIndex(p2)
	local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		return sequenceNumber + 1
	end

	return nil
end

local function getMessageId(p2)
	local messageId = p2.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end

local function cloneArray(items)
	local array = {}

	for k, item in items do
		table.insert(array, item)
	end

	return array
end

local function contentBlocksToText(items)
	local texts = {}

	for k, item in items do
		if item.type == "text" and typeof(item.text) == "string" then
			table.insert(texts, item.text)
		end
	end

	return table.concat(texts)
end

local function messageMapToText(assistantMessages, items)
	local v5 = {}

	for k, item in items do
		local v6 = assistantMessages[item]

		if v6 ~= nil then
			table.insert(v5, contentBlocksToText(v6))
		end
	end

	return table.concat(v5)
end

local function ensureMessageOrder(items, p2)
	for k, item in items do
		if item == p2 then
			return items
		end
	end

	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	table.insert(result, p2)
	return result
end

local function replaceMessageContent(p2, items, p3, items2)
	local clone = table.clone(p2)
	local v5 = {}

	for k, item in items2 do
		table.insert(v5, item)
	end

	clone[p3] = v5

	for k, item in items do
		if item == p3 then
			return clone, items
		end
	end

	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	table.insert(result, p3)
	return clone, result
end

local function appendMessageContent(assistantMessages, items, pendingAgentMessageId, p2)
	local clone = table.clone(assistantMessages)
	local v5 = clone[pendingAgentMessageId]
	local v6

	if v5 == nil then
		v6 = {}
	else
		v6 = {}

		for k, v7 in v5 do
			table.insert(v6, v7)
		end
	end

	table.insert(v6, p2)
	clone[pendingAgentMessageId] = v6

	for k, item in items do
		if item == pendingAgentMessageId then
			return clone, items
		end
	end

	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	table.insert(result, pendingAgentMessageId)
	return clone, result
end

local function buildActivityItems(activitySlots, toolCalls)
	local v5 = {}
	local activityItems = {}

	for k in activitySlots do
		table.insert(v5, k)
	end

	table.sort(v5)

	for k, v6 in v5 do
		local item = activitySlots[v6]

		if item.kind == "agent_message" then
			table.insert(activityItems, { kind = "agent_message", text = item.text })
		elseif FFlagBuildExperienceThoughtStatus and item.kind == "thought" then
			table.insert(activityItems, { kind = "thought", text = item.text })
		elseif item.kind == "tool_call" then
			local v7 = toolCalls[item.toolCallId]
			local v8 = {
				kind = "tool_call",
				toolCallId = item.toolCallId,
				title = 0,
				status = 0
			}
			local v9 = if v7 then v7.title else nil
			v8.title = v9
			local v10 = if v7 then v7.status else nil
			v8.status = v10
			table.insert(activityItems, v8)
		end
	end

	return activityItems
end

local function refreshActivityItems(state)
	state.activityItems = buildActivityItems(state.activitySlots, state.toolCalls)
end

local function recordActivitySlotAtIndex(state, p2, p3)
	if p2 <= 0 then
		return
	end

	local clone = table.clone(state.activitySlots)
	clone[p2] = p3
	state.activitySlots = clone
	state.activityItems = buildActivityItems(state.activitySlots, state.toolCalls)
end

local function recordActivitySlot(state, p2, p3)
	local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil
	local v5

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		v5 = sequenceNumber + 1
	end

	if v5 == nil or v5 <= 0 then
		return
	end

	local clone = table.clone(state.activitySlots)
	clone[v5] = p3
	state.activitySlots = clone
	state.activityItems = buildActivityItems(state.activitySlots, state.toolCalls)
end

local function recordToolCallSequenceSlot(state, p2, p3)
	local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil
	local v6

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		v6 = sequenceNumber + 1
	end

	if v6 == nil or v6 <= 0 then
		return
	end

	local clone = table.clone(state.activitySlots)
	clone[v6] = { kind = "tool_call", toolCallId = p3 }
	state.activitySlots = clone
	state.activityItems = buildActivityItems(state.activitySlots, state.toolCalls)
end

local function hasToolCallActivitySlot(p2, p3): boolean
	for k, activitySlot in p2.activitySlots do
		if activitySlot.kind == "tool_call" and activitySlot.toolCallId == p3 then
			return true
		end
	end

	return false
end

local function clearPendingAgentMessage(p2)
	p2.pendingAgentMessageId = nil
	p2.pendingAgentMessageContent = {}
	p2.pendingAgentMessageSequenceIndex = nil
end

local function appendPendingAgentMessage(clone, messageId, content, p2)
	if clone.pendingAgentMessageId ~= nil and clone.pendingAgentMessageId ~= messageId then
		local v5 = contentBlocksToText(clone.pendingAgentMessageContent)

		if v5 ~= "" then
			local pendingAgentMessageSequenceIndex = clone.pendingAgentMessageSequenceIndex

			if pendingAgentMessageSequenceIndex ~= nil then
				local v6 = { kind = "agent_message", text = v5 }

				if not (pendingAgentMessageSequenceIndex <= 0) then
					local clone2 = table.clone(clone.activitySlots)
					clone2[pendingAgentMessageSequenceIndex] = v6
					clone.activitySlots = clone2
					clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)
				end
			end
		end

		clone.pendingAgentMessageId = nil
		clone.pendingAgentMessageContent = {}
		clone.pendingAgentMessageSequenceIndex = nil
	end

	local v5 = {}

	for k, v6 in clone.pendingAgentMessageContent do
		table.insert(v5, v6)
	end

	table.insert(v5, content)
	clone.pendingAgentMessageId = messageId
	clone.pendingAgentMessageContent = v5

	if clone.pendingAgentMessageSequenceIndex == nil then
		local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil
		local v6 = if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then sequenceNumber + 1 else nil

		clone.pendingAgentMessageSequenceIndex = v6
	end
end

local function flushPendingAgentMessageToActivity(clone)
	local v5 = contentBlocksToText(clone.pendingAgentMessageContent)

	if v5 ~= "" then
		local pendingAgentMessageSequenceIndex = clone.pendingAgentMessageSequenceIndex

		if pendingAgentMessageSequenceIndex ~= nil then
			local v6 = { kind = "agent_message", text = v5 }

			if not (pendingAgentMessageSequenceIndex <= 0) then
				local clone2 = table.clone(clone.activitySlots)
				clone2[pendingAgentMessageSequenceIndex] = v6
				clone.activitySlots = clone2
				clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)
			end
		end
	end

	clone.pendingAgentMessageId = nil
	clone.pendingAgentMessageContent = {}
	clone.pendingAgentMessageSequenceIndex = nil
end

local function flushPendingAgentMessageToAssistant(clone)
	local pendingAgentMessageId = clone.pendingAgentMessageId

	if pendingAgentMessageId == nil then
		clone.pendingAgentMessageId = nil
		clone.pendingAgentMessageContent = {}
		clone.pendingAgentMessageSequenceIndex = nil
	else
		local assistantMessages = clone.assistantMessages
		local v5 = clone.assistantMessageOrder

		for k, v6 in clone.pendingAgentMessageContent do
			assistantMessages, v5 = appendMessageContent(assistantMessages, v5, pendingAgentMessageId, v6)
		end

		clone.assistantMessages = assistantMessages
		clone.assistantMessageOrder = v5
		clone.assistantText = messageMapToText(assistantMessages, v5)
		clone.pendingAgentMessageId = nil
		clone.pendingAgentMessageContent = {}
		clone.pendingAgentMessageSequenceIndex = nil
	end
end

local function extractRobloxMeta(p2)
	local roblox = p2._meta and p2._meta._roblox

	if typeof(roblox) == "table" then
		return roblox
	end

	return nil
end

local function recordEventMeta(clone, value, data)
	if typeof(value) ~= "number" or value < 0 then
		return
	end

	local roblox = data._meta and data._meta._roblox

	if typeof(roblox) ~= "table" then
		roblox = nil
	end

	if roblox == nil then
		return
	end

	local turnId = roblox.turnId
	local emittedTime = roblox.emittedTime
	local referenceId = roblox.referenceId
	local v5 = typeof(turnId) == "number" and turnId > 0
	local v6 = typeof(emittedTime) == "string" and emittedTime ~= ""
	local v7 = typeof(referenceId) == "string" and referenceId ~= ""

	if not (v5 or v6 or v7) then
		return
	end

	local v8 = clone.eventMetaBySequenceId == nil and {} or table.clone(clone.eventMetaBySequenceId)
	local v9 = v8[value] == nil and {} or table.clone(v8[value])

	if v5 then
		v9.turnId = turnId
	end

	if v6 then
		v9.emittedTime = emittedTime
	end

	if v7 then
		v9.referenceId = referenceId
	end

	v8[value] = v9
	clone.eventMetaBySequenceId = v8
end

local function extractReferenceId(p2)
	local roblox = p2._meta and p2._meta._roblox

	if typeof(roblox) ~= "table" then
		roblox = nil
	end

	local referenceId = if typeof(roblox) == "table" then roblox.referenceId else nil

	if typeof(referenceId) == "string" and referenceId ~= "" then
		return referenceId
	end

	return nil
end

local function applyToolCallUpdate(clone, data, p2)
	local toolCallId = data.toolCallId

	if typeof(toolCallId) ~= "string" or toolCallId == "" then
		return
	end

	local toolCall = clone.toolCalls[toolCallId]
	local v5 = toolCall == nil
	local v6 = toolCall == nil and { toolCallId = toolCallId } or table.clone(toolCall)

	if data.title ~= nil then
		v6.title = data.title
	end

	if data.kind ~= nil then
		v6.kind = data.kind
	end

	if data.status ~= nil then
		v6.status = data.status
	end

	if data.rawInput ~= nil then
		v6.rawInput = data.rawInput
	end

	if data.rawOutput ~= nil then
		v6.rawOutput = data.rawOutput
	end

	if data.content ~= nil then
		v6.content = data.content
	end

	local roblox = data._meta and data._meta._roblox

	if typeof(roblox) ~= "table" then
		roblox = nil
	end

	local turnId = if typeof(roblox) == "table" then roblox.turnId else nil

	if typeof(turnId) ~= "number" or not (turnId > 0) then
		turnId = nil
	end

	if turnId ~= nil then
		v6.turnId = turnId
	end

	local roblox2 = data._meta and data._meta._roblox

	if typeof(roblox2) ~= "table" then
		roblox2 = nil
	end

	local referenceId = if typeof(roblox2) == "table" then roblox2.referenceId else nil

	if typeof(referenceId) ~= "string" or referenceId == "" then
		referenceId = nil
	end

	if referenceId ~= nil then
		v6.referenceId = referenceId
	end

	local clone2 = table.clone(clone.toolCalls)
	clone2[toolCallId] = v6
	clone.toolCalls = clone2

	if v5 then
		clone.toolCallCount += 1
	end

	if not v5 then
		local flag = true
		local flag2

		for k, activitySlot in clone.activitySlots do
			if activitySlot.kind == "tool_call" and activitySlot.toolCallId == toolCallId then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)

			return
		end
	end

	local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil
	local v8

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		v8 = sequenceNumber + 1
	end

	if v8 == nil or v8 <= 0 then
		return
	end

	local clone3 = table.clone(clone.activitySlots)
	clone3[v8] = { kind = "tool_call", toolCallId = toolCallId }
	clone.activitySlots = clone3
	clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)
end

local function applyToolCallContentChunk(clone, data, p2)
	local toolCallId = data.toolCallId
	local content = data.content

	if typeof(toolCallId) ~= "string" or toolCallId == "" or typeof(content) ~= "table" then
		return
	end

	local toolCall = clone.toolCalls[toolCallId]
	local v5 = toolCall == nil
	local v6 = toolCall == nil and { toolCallId = toolCallId } or table.clone(toolCall)
	local content2 = v6.content
	local v7

	if content2 == nil then
		v7 = {}
	else
		v7 = {}

		for k, v8 in content2 do
			table.insert(v7, v8)
		end
	end

	table.insert(v7, content)
	v6.content = v7

	local clone2 = table.clone(clone.toolCalls)
	clone2[toolCallId] = v6
	clone.toolCalls = clone2

	if v5 then
		clone.toolCallCount += 1
	end

	if not v5 then
		local flag = true
		local flag2

		for k, activitySlot in clone.activitySlots do
			if activitySlot.kind == "tool_call" and activitySlot.toolCallId == toolCallId then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)

			return
		end
	end

	local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil
	local v9

	if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
		v9 = sequenceNumber + 1
	end

	if v9 == nil or v9 <= 0 then
		return
	end

	local clone3 = table.clone(clone.activitySlots)
	clone3[v9] = { kind = "tool_call", toolCallId = toolCallId }
	clone.activitySlots = clone3
	clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)
end

return {
	applySessionUpdate = function(p2, data, p3)
		local sessionUpdate = data.sessionUpdate
		local clone = table.clone(p2)
		local v5 = if p3 ~= nil then p3.sequenceNumber else nil
		recordEventMeta(clone, v5, data)

		if clone.status == "queued" then
			clone.status = "streaming"
		end

		if
			sessionUpdate ~= "agent_message_chunk"
			and (not FFlagBuildExperienceThoughtStatus or sessionUpdate ~= "agent_thought_chunk")
		then
			if sessionUpdate == "state_change" and data.state == "idle" then
				flushPendingAgentMessageToAssistant(clone)
			else
				flushPendingAgentMessageToActivity(clone)
			end
		end

		if sessionUpdate == "agent_message" then
			local messageId = data.messageId

			if typeof(messageId) ~= "string" or messageId == "" then
				messageId = nil
			end

			local content = data.content

			if messageId ~= nil and typeof(content) == "table" then
				local assistantMessages = clone.assistantMessages
				local v6 = clone.assistantMessageOrder
				local clone2 = table.clone(assistantMessages)
				local v7 = {}

				for k, v8 in content do
					table.insert(v7, v8)
				end

				clone2[messageId] = v7
				local flag = true

				for k, v8 in v6 do
					if v8 == messageId then
						flag = false
						break
					end
				end

				if flag then
					local v8 = {}

					for k, v9 in v6 do
						table.insert(v8, v9)
					end

					table.insert(v8, messageId)
					v6 = v8
				end

				clone.assistantMessages = clone2
				clone.assistantMessageOrder = v6

				clone.assistantText = messageMapToText(clone.assistantMessages, clone.assistantMessageOrder)
				return clone
			end
		elseif sessionUpdate == "agent_message_chunk" then
			local messageId = data.messageId

			if typeof(messageId) ~= "string" or messageId == "" then
				messageId = nil
			end

			local content = data.content

			if messageId ~= nil and typeof(content) == "table" then
				appendPendingAgentMessage(clone, messageId, content, p3)
				return clone
			end
		else
			if sessionUpdate == "tool_call_update" then
				applyToolCallUpdate(clone, data, p3)
				return clone
			elseif sessionUpdate == "tool_call_content_chunk" then
				applyToolCallContentChunk(clone, data, p3)
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
			elseif sessionUpdate == "agent_thought_chunk" then
				local content = data.content

				if
					FFlagBuildExperienceThoughtStatus
					and typeof(content) == "table"
					and typeof(content.text) == "string"
					and content.text ~= ""
				then
					local messageId = data.messageId

					if typeof(messageId) ~= "string" or messageId == "" then
						messageId = nil
					end

					clone.latestThought = { messageId = messageId, text = content.text }
					local v7 = { kind = "thought", text = content.text }
					local sequenceNumber = if p3 ~= nil then p3.sequenceNumber else nil
					local v8

					if typeof(sequenceNumber) == "number" and not (sequenceNumber < 0) then
						v8 = sequenceNumber + 1
					end

					if v8 == nil or v8 <= 0 then
						return clone
					end

					local clone2 = table.clone(clone.activitySlots)
					clone2[v8] = v7
					clone.activitySlots = clone2
					clone.activityItems = buildActivityItems(clone.activitySlots, clone.toolCalls)
					return clone
				end
			elseif sessionUpdate == "session_info_update" then
				clone.infoUpdate = { title = data.title }
			end
		end

		return clone
	end,
	createEmptyTurnState = function(p2, p3)
		return {
			sessionId = p2,
			requestId = p3,
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
	end,
	extractTurnId = function(p2)
		local roblox = p2._meta and p2._meta._roblox

		if typeof(roblox) ~= "table" then
			roblox = nil
		end

		local turnId = if typeof(roblox) == "table" then roblox.turnId else nil

		if typeof(turnId) == "number" and turnId > 0 then
			return turnId
		end

		return nil
	end
}
