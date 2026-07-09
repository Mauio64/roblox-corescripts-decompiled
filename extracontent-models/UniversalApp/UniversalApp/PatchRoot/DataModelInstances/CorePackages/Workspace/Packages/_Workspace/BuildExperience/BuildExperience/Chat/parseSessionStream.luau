local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local PublishToolUtils = CreatorAgentChat.PublishToolUtils
local TurnStateReducer = CreatorAgentChat.TurnStateReducer
local SubagentTasks = CreatorAgentChat.SubagentTasks

local function contentBlockToText(p1) -- line: 76
	if p1 ~= nil and (p1.type == "text" and typeof(p1.text) == "string") then
		return p1.text
	end

	return ""
end
local function contentBlocksToText(t1: {[any]: any}?) -- line: 83
	if typeof(t1) ~= "table" then
		return ""
	end

	local t2 = {}

	for _, v23 in t1 do
		local v24 = (v23 == nil or (v23.type ~= "text" or typeof(v23.text) ~= "string")) and "" or v23.text

		if v24 ~= "" then
			table.insert(t2, v24)
		end
	end

	return table.concat(t2)
end
local function getSequenceId(p2) -- line: 97
	local sequenceId = p2.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end
local function asOptimisticallyCancelled(p3) -- line: 105
	-- upvalues: TurnStateReducer (copy)
	return TurnStateReducer.applySessionUpdate(p3, {
		sessionUpdate = "state_change",
		state = "idle",
		stop_reason = "cancelled"
	}, nil)
end
local function getMessageId(p4) -- line: 113
	local messageId = p4.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end
local function isAssistantTurnUpdate(p5) -- line: 118
	return p5 == "agent_message" or (p5 == "agent_message_chunk" or (p5 == "agent_thought" or (p5 == "agent_thought_chunk" or (p5 == "tool_call_update" or (p5 == "tool_call_content_chunk" or p5 == "state_change")))))
end
local function hasAssistantTurnContent(p6) -- line: 128
	return p6.assistantText ~= "" or (p6.thoughtText ~= "" or (#p6.activityItems > 0 or p6.toolCallCount > 0))
end
local function shouldEmitAssistantTurn(p7) -- line: 136
	return p7.assistantText ~= "" or (p7.thoughtText ~= "" or (#p7.activityItems > 0 or p7.toolCallCount > 0)) or (#p7.pendingAgentMessageContent > 0 or (p7.status == "cancelled" or p7.stopReason == "cancelled"))
end
local function orderedBySequenceId(t3: {[any]: any}) -- line: 143
	local v34 = table.clone(t3)

	table.sort(v34, function(p8, p9) -- line: 145
		local sequenceId = p8.sequenceId
		local v99 = ((if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId)) or -1
		local sequenceId2 = p9.sequenceId

		return v99 < (((if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then nil else sequenceId2)) or -1)
	end)

	return v34
end
local function parseChatItems(t4: {[any]: any}, s1: string) -- line: 155
	-- upvalues: contentBlocksToText (copy), TurnStateReducer (copy)
	local t5 = {}
	local u38 = nil
	local n1 = 0
	local u40 = nil
	local u41 = nil
	local t6 = {}
	local u43 = false

	local function flushActiveTurn() -- line: 164
		-- upvalues: u38 (ref), u43 (ref), t5 (copy), u40 (ref), u41 (ref), t6 (ref), n1 (ref)
		if u38 ~= nil and u43 then
			local v101 = u38

			if v101.assistantText ~= "" or (v101.thoughtText ~= "" or (#v101.activityItems > 0 or v101.toolCallCount > 0)) or (#v101.pendingAgentMessageContent > 0 or (v101.status == "cancelled" or v101.stopReason == "cancelled")) then
				table.insert(t5, {
					kind = "assistant_turn",
					startSequenceId = u40,
					endSequenceId = u41,
					sequenceIds = t6,
					turnState = u38
				})
			end
		end

		u38 = nil
		n1 = 0
		u40 = nil
		u41 = nil
		t6 = {}
		u43 = false
	end
	local function appendUserMessage(s2: string?, n2: number?, s3: string) -- line: 182
		-- upvalues: t5 (copy)
		if s3 == "" then
			return
		end

		local v105 = t5[#t5]

		if v105 ~= nil and v105.kind == "user_message" and s2 == v105.messageId then
			v105.text = v105.text .. s3

			return
		end

		table.insert(t5, {
			kind = "user_message",
			messageId = s2,
			sequenceId = n2,
			text = s3
		})
	end

	for _, v47 in t4 do
		local sessionUpdate = v47.sessionUpdate
		local sequenceId = v47.sequenceId
		local v50 = if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId

		if sessionUpdate == "user_message" or sessionUpdate == "user_message_chunk" then
			if u38 ~= nil then
				local v51 = u38

				if v51.assistantText ~= "" or (v51.thoughtText ~= "" or (#v51.activityItems > 0 or v51.toolCallCount > 0)) then
					flushActiveTurn()
				end
			end

			local v52

			if sessionUpdate == "user_message" then
				v52 = contentBlocksToText(v47.content)
			else
				local content = v47.content

				v52 = (content == nil or (content.type ~= "text" or typeof(content.text) ~= "string")) and "" or content.text
			end

			local messageId = v47.messageId

			appendUserMessage(if typeof(messageId) ~= "string" or messageId == "" then nil else messageId, v50, v52)
		elseif sessionUpdate == "agent_message" or (sessionUpdate == "agent_message_chunk" or (sessionUpdate == "agent_thought" or (sessionUpdate == "agent_thought_chunk" or (sessionUpdate == "tool_call_update" or (sessionUpdate == "tool_call_content_chunk" or sessionUpdate == "state_change"))))) then
			if u38 == nil then
				u38 = TurnStateReducer.createEmptyTurnState(s1)
			end

			if sessionUpdate == "state_change" and v47.state == "running" then
				u43 = true
			end

			if v50 ~= nil then
				table.insert(t6, v50)

				if u40 == nil or v50 < u40 then
					u40 = v50
				end

				if u41 == nil or v50 > u41 then
					u41 = v50
				end
			end

			u38 = TurnStateReducer.applySessionUpdate(u38, v47, {
				sequenceNumber = n1
			})
			n1 += 1

			if u38.isDone then
				flushActiveTurn()
			end
		end
	end

	flushActiveTurn()

	return t5
end
local function buildUserMessageItem(t7: {[any]: any}, s4: string?) -- line: 240
	local v57 = if s4 == nil or t7.sequenceId == nil then t7.messageId else `{ s4 }:{ t7.sequenceId }:user`

	return {
		kind = "user_message",
		id = v57,
		text = t7.text
	}
end
local function buildTurnFeedbackIds(t8: {[any]: any}, t9: {[any]: any}) -- line: 251
	-- upvalues: PublishToolUtils (copy)
	local v60 = PublishToolUtils.getLatestSuccessfulResult(t8.turnState)

	return {
		universeId = t9.universeId,
		placeId = t9.placeId,
		sessionId = t9.sessionId,
		sequenceId = t8.endSequenceId,
		publishedVersionNumber = if v60 == nil then nil else v60.publishedVersionNumber,
		rollbackTargetVersionNumber = if v60 == nil then nil else v60.rollbackTargetVersionNumber
	}
end
local function parseSessionStream(t10: {[any]: any}, t11: {[any]: any}) -- line: 263
	-- upvalues: parseChatItems (copy), TurnStateReducer (copy), PublishToolUtils (copy), SubagentTasks (copy), buildTurnFeedbackIds (copy)
	local sessionId = t11.sessionId
	local v64 = parseChatItems
	local v65 = table.clone(t10)

	table.sort(v65, function(p10, p11) -- line: 145
		local sequenceId = p10.sequenceId
		local v109 = ((if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId)) or -1
		local sequenceId3 = p11.sequenceId

		return v109 < (((if typeof(sequenceId3) ~= "number" or not (sequenceId3 >= 0) then nil else sequenceId3)) or -1)
	end)

	local v66 = v64(v65, sessionId or "")
	local v67 = nil

	for _, v69 in t10 do
		local sequenceId = v69.sequenceId
		local v71 = if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId

		if v71 ~= nil and (v67 == nil or v67 < v71) then
			v67 = v71
		end
	end

	local t12 = {}
	local v73 = false
	local v74 = nil
	local v75 = nil
	local v76 = nil
	local startSequenceId = nil
	local sequenceIds = nil

	for _, v80 in v66 do
		if v80.kind == "user_message" then
			local v81 = if sessionId == nil or v80.sequenceId == nil then v80.messageId else `{ sessionId }:{ v80.sequenceId }:user`

			table.insert(t12, {
				kind = "user_message",
				id = v81,
				text = v80.text
			})
		else
			local turnState = v80.turnState

			if t11.optimisticCancelledStartSequenceId ~= nil and v80.startSequenceId == t11.optimisticCancelledStartSequenceId and not turnState.isDone then
				turnState = TurnStateReducer.applySessionUpdate(turnState, {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = "cancelled"
				}, nil)
			end

			if PublishToolUtils.includesPublishPlaceTool(turnState) then
				v73 = true
			end

			local v83 = SubagentTasks.fromTurnState(turnState)

			if v83 ~= nil then
				v74 = v83
			end

			local v84 = if sessionId == nil or v80.startSequenceId == nil then nil else `{ sessionId }:{ v80.startSequenceId }`
			local v85 = not turnState.isDone

			table.insert(t12, {
				kind = "assistant_turn",
				id = v84,
				isDone = turnState.isDone,
				turnState = turnState,
				turnKey = v84,
				optimisticLocalTools = if not v85 then nil else t11.optimisticLocalTools,
				universeId = t11.universeId,
				sessionId = sessionId,
				turnFeedbackIds = buildTurnFeedbackIds(v80, t11)
			})

			if v85 then
				v75 = #t12
				v76 = turnState
				startSequenceId = v80.startSequenceId
				sequenceIds = v80.sequenceIds
			end
		end
	end

	local pendingUserMessage = t11.pendingUserMessage

	if pendingUserMessage ~= nil and pendingUserMessage ~= "" then
		local v87 = t11.pendingUserMessageAfterSequenceId or -1
		local v88 = false

		for _, v90 in v66 do
			if v90.kind ~= "user_message" then
				continue
			end

			local sequenceId = v90.sequenceId

			if sequenceId ~= nil and v87 < sequenceId then
				v88 = true

				break
			end
		end

		if not v88 then
			table.insert(t12, {
				kind = "user_message",
				id = if sessionId == nil then nil else `{ sessionId }:pending`,
				text = pendingUserMessage
			})
		end
	end

	local liveAssistantMessage = t11.liveAssistantMessage
	local v93 = t12[#t12]
	local v94 = v93 ~= nil and v93.kind == "assistant_turn"

	if liveAssistantMessage ~= nil and not v94 then
		local v95 = if sessionId == nil then nil else `{ sessionId }:live`

		table.insert(t12, {
			kind = "assistant_turn",
			isDone = false,
			id = v95,
			turnKey = v95,
			loading = liveAssistantMessage.setupErrorText == nil or nil,
			setupErrorText = liveAssistantMessage.setupErrorText,
			universeId = t11.universeId,
			turnFeedbackIds = {}
		})
	end

	return {
		messages = t12,
		includesPublishTool = v73,
		activeTurnItemIndex = v75,
		activeTurnState = v76,
		activeTurnStartSequenceId = startSequenceId,
		activeTurnSequenceIds = sequenceIds,
		subagentTaskState = v74,
		latestSequenceId = v67
	}
end

return parseSessionStream
