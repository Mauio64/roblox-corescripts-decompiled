local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local PublishToolUtils = CreatorAgentChat.PublishToolUtils
local TurnStateReducer = CreatorAgentChat.TurnStateReducer
local SubagentTasks = CreatorAgentChat.SubagentTasks

local function contentBlockToText(p1) -- line: 77
	if p1 ~= nil and (p1.type == "text" and typeof(p1.text) == "string") then
		return p1.text
	end

	return ""
end
local function contentBlocksToText(t1: {[any]: any}?) -- line: 84
	if typeof(t1) ~= "table" then
		return ""
	end

	local t2 = {}

	for _, v25 in t1 do
		local v26 = (v25 == nil or (v25.type ~= "text" or typeof(v25.text) ~= "string")) and "" or v25.text

		if v26 ~= "" then
			table.insert(t2, v26)
		end
	end

	return table.concat(t2)
end
local function getSequenceId(p2) -- line: 98
	local sequenceId = p2.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end
local function asOptimisticallyCancelled(p3) -- line: 106
	-- upvalues: TurnStateReducer (copy)
	return TurnStateReducer.applySessionUpdate(p3, {
		sessionUpdate = "state_change",
		state = "idle",
		stop_reason = "cancelled"
	}, nil)
end
local function getMessageId(p4) -- line: 114
	local messageId = p4.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end
local function isAssistantTurnUpdate(p5) -- line: 119
	return p5 == "agent_message" or (p5 == "agent_message_chunk" or (p5 == "tool_call_update" or (p5 == "tool_call_content_chunk" or p5 == "state_change")))
end
local function hasAssistantTurnContent(p6) -- line: 127
	return p6.assistantText ~= "" or (#p6.activityItems > 0 or p6.toolCallCount > 0)
end
local function shouldEmitAssistantTurn(p7) -- line: 135
	return p7.assistantText ~= "" or (#p7.activityItems > 0 or p7.toolCallCount > 0) or (#p7.pendingAgentMessageContent > 0 or (p7.status == "cancelled" or (p7.stopReason == "cancelled" or p7.stopReason == "error")))
end
local function orderedBySequenceId(t3: {[any]: any}) -- line: 143
	local v36 = table.clone(t3)

	table.sort(v36, function(p8, p9) -- line: 145
		local sequenceId = p8.sequenceId
		local v109 = ((if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId)) or -1
		local sequenceId2 = p9.sequenceId

		return v109 < (((if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then nil else sequenceId2)) or -1)
	end)

	return v36
end
local function parseChatItems(t4: {[any]: any}, s1: string) -- line: 155
	-- upvalues: contentBlocksToText (copy), TurnStateReducer (copy)
	local t5 = {}
	local u40 = nil
	local u41 = nil
	local u42 = nil
	local t6 = {}
	local u44 = false

	local function flushActiveTurn() -- line: 163
		-- upvalues: u40 (ref), u44 (ref), t5 (copy), u41 (ref), u42 (ref), t6 (ref)
		if u40 ~= nil and u44 then
			local v111 = u40

			if v111.assistantText ~= "" or (#v111.activityItems > 0 or v111.toolCallCount > 0) or (#v111.pendingAgentMessageContent > 0 or (v111.status == "cancelled" or (v111.stopReason == "cancelled" or v111.stopReason == "error"))) then
				table.insert(t5, {
					kind = "assistant_turn",
					startSequenceId = u41,
					endSequenceId = u42,
					sequenceIds = t6,
					turnState = u40
				})
			end
		end

		u40 = nil
		u41 = nil
		u42 = nil
		t6 = {}
		u44 = false
	end
	local function appendUserMessage(s2: string?, n1: number?, s3: string) -- line: 180
		-- upvalues: t5 (copy)
		if s3 == "" then
			return
		end

		local v115 = t5[#t5]

		if v115 ~= nil and v115.kind == "user_message" and s2 == v115.messageId then
			v115.text = v115.text .. s3

			return
		end

		table.insert(t5, {
			kind = "user_message",
			messageId = s2,
			sequenceId = n1,
			text = s3
		})
	end

	for _, v48 in t4 do
		local sessionUpdate = v48.sessionUpdate
		local sequenceId = v48.sequenceId
		local v51 = if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId

		if sessionUpdate == "user_message" or sessionUpdate == "user_message_chunk" then
			if u40 ~= nil then
				local v52 = u40

				if v52.assistantText ~= "" or (#v52.activityItems > 0 or v52.toolCallCount > 0) then
					flushActiveTurn()
				end
			end

			local v53

			if sessionUpdate == "user_message" then
				v53 = contentBlocksToText(v48.content)
			else
				local content = v48.content

				v53 = (content == nil or (content.type ~= "text" or typeof(content.text) ~= "string")) and "" or content.text
			end

			local messageId = v48.messageId

			appendUserMessage(if typeof(messageId) ~= "string" or messageId == "" then nil else messageId, v51, v53)
		elseif sessionUpdate == "agent_message" or (sessionUpdate == "agent_message_chunk" or (sessionUpdate == "tool_call_update" or (sessionUpdate == "tool_call_content_chunk" or sessionUpdate == "state_change"))) then
			if u40 == nil then
				u40 = TurnStateReducer.createEmptyTurnState(s1)
			end

			if sessionUpdate == "state_change" and v48.state == "running" then
				u44 = true
			end

			if v51 ~= nil then
				table.insert(t6, v51)

				if u41 == nil or v51 < u41 then
					u41 = v51
				end

				if u42 == nil or v51 > u42 then
					u42 = v51
				end
			end

			u40 = TurnStateReducer.applySessionUpdate(u40, v48, {
				sequenceNumber = v51
			})

			if u40.isDone then
				flushActiveTurn()
			end
		end
	end

	flushActiveTurn()

	return t5
end
local function buildUserMessageItem(t7: {[any]: any}, s4: string?) -- line: 237
	local v58 = if s4 == nil or t7.sequenceId == nil then t7.messageId else `{ s4 }:{ t7.sequenceId }:user`

	return {
		kind = "user_message",
		id = v58,
		text = t7.text
	}
end
local function getEventMeta(p10, n2: number?) -- line: 248
	if n2 == nil or p10.eventMetaBySequenceId == nil then
		return nil
	end

	return p10.eventMetaBySequenceId[n2]
end
local function resolveTurnId(p11, t8: {[any]: any}) -- line: 255
	local endSequenceId = t8.endSequenceId
	local v64 = if endSequenceId ~= nil and p11.eventMetaBySequenceId ~= nil then p11.eventMetaBySequenceId[endSequenceId] else nil

	if v64 ~= nil and v64.turnId ~= nil then
		return v64.turnId
	end

	for _, v66 in t8.sequenceIds do
		local v67 = if v66 ~= nil and p11.eventMetaBySequenceId ~= nil then p11.eventMetaBySequenceId[v66] else nil

		if v67 ~= nil and v67.turnId ~= nil then
			return v67.turnId
		end
	end

	return nil
end
local function buildTurnFeedbackIds(t9: {[any]: any}, t10: {[any]: any}) -- line: 269
	-- upvalues: PublishToolUtils (copy), resolveTurnId (copy)
	local v70 = PublishToolUtils.getLatestSuccessfulResult(t9.turnState)

	return {
		universeId = t10.universeId,
		placeId = t10.placeId,
		sessionId = t10.sessionId,
		sequenceId = t9.endSequenceId,
		turnId = resolveTurnId(t9.turnState, t9),
		publishedVersionNumber = if v70 == nil then nil else v70.publishedVersionNumber,
		rollbackTargetVersionNumber = if v70 == nil then nil else v70.rollbackTargetVersionNumber
	}
end
local function parseSessionStream(t11: {[any]: any}, t12: {[any]: any}) -- line: 282
	-- upvalues: parseChatItems (copy), TurnStateReducer (copy), PublishToolUtils (copy), SubagentTasks (copy), buildTurnFeedbackIds (copy)
	local sessionId = t12.sessionId
	local v74 = parseChatItems
	local v75 = table.clone(t11)

	table.sort(v75, function(p12, p13) -- line: 145
		local sequenceId = p12.sequenceId
		local v119 = ((if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId)) or -1
		local sequenceId3 = p13.sequenceId

		return v119 < (((if typeof(sequenceId3) ~= "number" or not (sequenceId3 >= 0) then nil else sequenceId3)) or -1)
	end)

	local v76 = v74(v75, sessionId or "")
	local v77 = nil

	for _, v79 in t11 do
		local sequenceId = v79.sequenceId
		local v81 = if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId

		if v81 ~= nil and (v77 == nil or v77 < v81) then
			v77 = v81
		end
	end

	local t13 = {}
	local v83 = false
	local v84 = nil
	local v85 = nil
	local v86 = nil
	local startSequenceId = nil
	local sequenceIds = nil

	for _, v90 in v76 do
		if v90.kind == "user_message" then
			local v91 = if sessionId == nil or v90.sequenceId == nil then v90.messageId else `{ sessionId }:{ v90.sequenceId }:user`

			table.insert(t13, {
				kind = "user_message",
				id = v91,
				text = v90.text
			})
		else
			local turnState = v90.turnState

			if t12.optimisticCancelledStartSequenceId ~= nil and v90.startSequenceId == t12.optimisticCancelledStartSequenceId and not turnState.isDone then
				turnState = TurnStateReducer.applySessionUpdate(turnState, {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = "cancelled"
				}, nil)
			end

			if PublishToolUtils.includesPublishPlaceTool(turnState) then
				v83 = true
			end

			local v93 = SubagentTasks.fromTurnState(turnState)

			if v93 ~= nil then
				v84 = v93
			end

			local v94 = if sessionId == nil or v90.startSequenceId == nil then nil else `{ sessionId }:{ v90.startSequenceId }`
			local v95 = not turnState.isDone

			table.insert(t13, {
				kind = "assistant_turn",
				id = v94,
				isDone = turnState.isDone,
				turnState = turnState,
				turnKey = v94,
				startSequenceId = v90.startSequenceId,
				endSequenceId = v90.endSequenceId,
				optimisticLocalTools = if not v95 then nil else t12.optimisticLocalTools,
				universeId = t12.universeId,
				sessionId = sessionId,
				turnFeedbackIds = buildTurnFeedbackIds(v90, t12)
			})

			if v95 then
				v85 = #t13
				v86 = turnState
				startSequenceId = v90.startSequenceId
				sequenceIds = v90.sequenceIds
			end
		end
	end

	local pendingUserMessage = t12.pendingUserMessage

	if pendingUserMessage ~= nil and pendingUserMessage ~= "" then
		local v97 = t12.pendingUserMessageAfterSequenceId or -1
		local v98 = false

		for _, v100 in v76 do
			if v100.kind ~= "user_message" then
				continue
			end

			local sequenceId = v100.sequenceId

			if sequenceId ~= nil and v97 < sequenceId then
				v98 = true

				break
			end
		end

		if not v98 then
			table.insert(t13, {
				kind = "user_message",
				id = if sessionId == nil then nil else `{ sessionId }:pending`,
				text = pendingUserMessage
			})
		end
	end

	local liveAssistantMessage = t12.liveAssistantMessage
	local v103 = t13[#t13]
	local v104 = v103 ~= nil and v103.kind == "assistant_turn"

	if liveAssistantMessage ~= nil and not v104 then
		local v105 = if sessionId == nil then nil else `{ sessionId }:live`

		table.insert(t13, {
			kind = "assistant_turn",
			isDone = false,
			id = v105,
			turnKey = v105,
			loading = liveAssistantMessage.setupErrorText == nil or nil,
			setupErrorText = liveAssistantMessage.setupErrorText,
			universeId = t12.universeId,
			turnFeedbackIds = {}
		})
	end

	return {
		messages = t13,
		includesPublishTool = v83,
		activeTurnItemIndex = v85,
		activeTurnState = v86,
		activeTurnStartSequenceId = startSequenceId,
		activeTurnSequenceIds = sequenceIds,
		subagentTaskState = v84,
		latestSequenceId = v77
	}
end

return parseSessionStream
