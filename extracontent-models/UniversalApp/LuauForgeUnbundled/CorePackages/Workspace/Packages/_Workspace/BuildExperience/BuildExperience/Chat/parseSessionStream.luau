local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")

local fFlagBuildExperienceChatResourceAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceChatResourceAttachments

local publishToolUtils = CreatorAgentChat.PublishToolUtils
local turnStateReducer = CreatorAgentChat.TurnStateReducer
local subagentTasks = CreatorAgentChat.SubagentTasks

local function contentBlockToText(p2)
	if p2 == nil or p2.type ~= "text" or typeof(p2.text) ~= "string" then
		return ""
	end

	return p2.text
end

local function contentBlockToImage(p2)
	if FFlagBuildExperienceChatImageAttachments and p2 ~= nil and p2.type == "image" and typeof(p2.uri) == "string" and p2.uri ~= "" then
		return { uri = p2.uri }
	end

	return nil
end

local function contentBlockToResourceAttachment(data)
	if
		data == nil
		or data.type ~= "resource_link"
		or typeof(data.name) ~= "string"
		or data.name == ""
		or typeof(data.uri) ~= "string"
		or data.uri == ""
	then
		if
			data == nil
			or data.type ~= "resource"
			or typeof(data.resource) ~= "table"
			or typeof(data.resource.uri) ~= "string"
			or data.resource.uri == ""
			or typeof(data.resource.text) ~= "string"
		then
			return nil
		end

		return { type = "resource", resource = data.resource }
	else
		local v5 = {
			type = "resource_link",
			name = data.name,
			uri = data.uri,
			mimeType = 0
		}
		local v6 = if typeof(data.mimeType) == "string" then data.mimeType else nil
		v5.mimeType = v6
		return v5
	end
end

local function contentBlocksToText(content)
	if typeof(content) ~= "table" then
		return ""
	end

	local v5 = {}

	for k, item in content do
		local v6 = (item == nil or item.type ~= "text" or typeof(item.text) ~= "string") and "" or item.text

		if v6 ~= "" then
			table.insert(v5, v6)
		end
	end

	return table.concat(v5)
end

local function contentBlocksToImages(content)
	local result = {}

	if typeof(content) ~= "table" then
		return result
	end

	for k, item in content do
		local v5 = FFlagBuildExperienceChatImageAttachments
			and item ~= nil
			and item.type == "image"
			and typeof(item.uri) == "string"
			and item.uri ~= ""
			and { uri = item.uri }
			or nil

		if v5 ~= nil then
			table.insert(result, v5)
		end
	end

	return result
end

local function contentBlocksToResourceAttachments(content)
	local result = {}

	if typeof(content) ~= "table" then
		return result
	end

	for k, item in content do
		local v5 = contentBlockToResourceAttachment(item)

		if v5 ~= nil then
			table.insert(result, v5)
		end
	end

	return result
end

local function getSequenceId(p2)
	local sequenceId = p2.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end

local function asOptimisticallyCancelled(p2)
	return turnStateReducer.applySessionUpdate(
		p2,
		{ sessionUpdate = "state_change", state = "idle", stop_reason = "cancelled" },
		nil
	)
end

local function getMessageId(p2)
	local messageId = p2.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end

local function isAssistantTurnUpdate(p2): boolean
	return p2 == "agent_message"
		or p2 == "agent_message_chunk"
		or p2 == "tool_call_update"
		or p2 == "tool_call_content_chunk"
		or p2 == "state_change"
end

local function hasAssistantTurnContent(data): boolean
	return data.assistantText ~= "" or #data.activityItems > 0 or data.toolCallCount > 0
end

local function shouldEmitAssistantTurn(data): boolean
	return data.assistantText ~= ""
		or #data.activityItems > 0
		or data.toolCallCount > 0
		or #data.pendingAgentMessageContent > 0
		or data.status == "cancelled"
		or data.stopReason == "cancelled"
		or data.stopReason == "error"
end

local function orderedBySequenceId(p2)
	local clone = table.clone(p2)
	table.sort(clone, function(a, b): boolean
		local sequenceId = a.sequenceId

		if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
			sequenceId = nil
		end

		local sequenceId2 = b.sequenceId

		if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then
			sequenceId2 = nil
		end

		return (sequenceId or -1) < (sequenceId2 or -1)
	end)

	return clone
end

local function parseChatItems(items, p2)
	local chatItems = {}
	local v5 = nil
	local v6 = nil
	local v7 = nil
	local sequenceIds = {}
	local v8 = false

	local function flushActiveTurn()
		if v5 ~= nil and v8 then
			local v9 = v5

			if
				v9.assistantText ~= ""
				or #v9.activityItems > 0
				or v9.toolCallCount > 0
				or #v9.pendingAgentMessageContent > 0
				or v9.status == "cancelled"
				or v9.stopReason == "cancelled"
				or v9.stopReason == "error"
			then
				table.insert(chatItems, {
					kind = "assistant_turn",
					startSequenceId = v6,
					endSequenceId = v7,
					sequenceIds = sequenceIds,
					turnState = v5
				})
			end
		end

		v5 = nil
		v6 = nil
		v7 = nil
		sequenceIds = {}
		v8 = false
	end

	local function appendUserMessage(messageId, sequenceId, p3, list, list2)
		if p3 == "" and #list == 0 and #list2 == 0 then
			return
		end

		local chatItem = chatItems[#chatItems]

		if chatItem == nil or chatItem.kind ~= "user_message" or chatItem.messageId ~= messageId then
			table.insert(chatItems, {
				kind = "user_message",
				messageId = messageId,
				sequenceId = sequenceId,
				text = p3,
				images = list,
				resourceAttachments = list2
			})
			return
		end

		chatItem.text ..= p3

		for k, item in list do
			table.insert(chatItem.images, item)
		end

		for k, item in list2 do
			table.insert(chatItem.resourceAttachments, item)
		end
	end

	for k, item in items do
		local sessionUpdate = item.sessionUpdate
		local sequenceId = item.sequenceId

		if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
			sequenceId = nil
		end

		if sessionUpdate == "user_message" or sessionUpdate == "user_message_chunk" then
			if v5 ~= nil then
				local v9 = v5

				if v9.assistantText ~= "" or #v9.activityItems > 0 or v9.toolCallCount > 0 then
					flushActiveTurn()
				end
			end

			local v9

			if sessionUpdate == "user_message" then
				v9 = contentBlocksToText(item.content)
			else
				local content = item.content
				v9 = (content == nil or content.type ~= "text" or typeof(content.text) ~= "string")
					and ""
					or content.text
			end

			local v10

			if sessionUpdate == "user_message" then
				v10 = contentBlocksToImages(item.content)
			else
				v10 = {}
				local content = item.content
				local v11 = FFlagBuildExperienceChatImageAttachments
					and content ~= nil
					and content.type == "image"
					and typeof(content.uri) == "string"
					and content.uri ~= ""
					and { uri = content.uri }
					or nil

				if v11 ~= nil then
					table.insert(v10, v11)
				end
			end

			local v11

			if fFlagBuildExperienceChatResourceAttachments then
				if sessionUpdate == "user_message" then
					v11 = contentBlocksToResourceAttachments(item.content)
				else
					v11 = {}
					local v12 = contentBlockToResourceAttachment(item.content)

					if v12 ~= nil then
						table.insert(v11, v12)
					end
				end
			else
				v11 = {}
			end

			local messageId = item.messageId

			if typeof(messageId) ~= "string" or messageId == "" then
				messageId = nil
			end

			appendUserMessage(messageId, sequenceId, v9, v10, v11)
		elseif
			sessionUpdate == "agent_message"
			or sessionUpdate == "agent_message_chunk"
			or sessionUpdate == "tool_call_update"
			or sessionUpdate == "tool_call_content_chunk"
			or sessionUpdate == "state_change"
		then
			if v5 == nil then
				v5 = turnStateReducer.createEmptyTurnState(p2)
			end

			if sessionUpdate == "state_change" and item.state == "running" then
				v8 = true
			end

			if sequenceId ~= nil then
				table.insert(sequenceIds, sequenceId)

				if v6 == nil or sequenceId < v6 then
					v6 = sequenceId
				end

				if v7 == nil or v7 < sequenceId then
					v7 = sequenceId
				end
			end

			v5 = turnStateReducer.applySessionUpdate(v5, item, {
				sequenceNumber = sequenceId
			})

			if v5.isDone then
				flushActiveTurn()
			end
		end
	end

	flushActiveTurn()
	return chatItems
end

local function buildUserMessageItem(data, sessionId)
	local userMessageItem = {
		kind = "user_message",
		id = if sessionId == nil or data.sequenceId == nil then data.messageId else `{sessionId}:{data.sequenceId}:user`,
		text = data.text,
		images = 0,
		resourceAttachments = 0
	}
	local v6 = if FFlagBuildExperienceChatImageAttachments then data.images else nil
	userMessageItem.images = v6

	local v7 = if fFlagBuildExperienceChatResourceAttachments and #data.resourceAttachments > 0 then data.resourceAttachments else nil
	userMessageItem.resourceAttachments = v7
	return userMessageItem
end

local function getEventMeta(p2, p3)
	if p3 == nil or p2.eventMetaBySequenceId == nil then
		return nil
	end

	return p2.eventMetaBySequenceId[p3]
end

local function resolveTurnId(turnState, p2)
	local endSequenceId = p2.endSequenceId
	local v5

	if not (endSequenceId == nil or turnState.eventMetaBySequenceId == nil) then
		v5 = turnState.eventMetaBySequenceId[endSequenceId]
	end

	if v5 ~= nil and v5.turnId ~= nil then
		return v5.turnId
	end

	for k, sequenceId in p2.sequenceIds do
		local v6

		if not (sequenceId == nil or turnState.eventMetaBySequenceId == nil) then
			v6 = turnState.eventMetaBySequenceId[sequenceId]
		end

		if v6 ~= nil and v6.turnId ~= nil then
			return v6.turnId
		end
	end

	return nil
end

local function buildTurnFeedbackIds(p2, data)
	local latestSuccessfulResult = publishToolUtils.getLatestSuccessfulResult(p2.turnState)
	local turnFeedbackIds = {
		universeId = data.universeId,
		placeId = data.placeId,
		sessionId = data.sessionId,
		sequenceId = p2.endSequenceId,
		turnId = resolveTurnId(p2.turnState, p2),
		publishedVersionNumber = 0,
		rollbackTargetVersionNumber = 0
	}
	local v5 = if latestSuccessfulResult ~= nil then latestSuccessfulResult.publishedVersionNumber else nil
	turnFeedbackIds.publishedVersionNumber = v5
	local v6 = if latestSuccessfulResult ~= nil then latestSuccessfulResult.rollbackTargetVersionNumber else nil
	turnFeedbackIds.rollbackTargetVersionNumber = v6
	return turnFeedbackIds
end

local function parseSessionStream(items, data)
	local sessionId = data.sessionId
	local clone = table.clone(items)
	table.sort(clone, function(a, b): boolean
		local sequenceId = a.sequenceId

		if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
			sequenceId = nil
		end

		local sequenceId2 = b.sequenceId

		if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then
			sequenceId2 = nil
		end

		return (sequenceId or -1) < (sequenceId2 or -1)
	end)

	local v6 = parseChatItems(clone, sessionId or "")
	local v7 = nil

	for k, item in items do
		local sequenceId = item.sequenceId

		if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
			sequenceId = nil
		end

		if sequenceId ~= nil and (v7 == nil or v7 < sequenceId) then
			v7 = sequenceId
		end
	end

	local v8 = {}
	local v9 = nil
	local v10 = false
	local v11 = nil
	local v12 = nil
	local startSequenceId = nil
	local sequenceIds = nil
	local v13 = nil

	for k, v14 in v6 do
		if v14.kind == "user_message" then
			table.insert(v8, buildUserMessageItem(v14, sessionId))
		else
			local turnState = v14.turnState
			local v15

			if
				data.optimisticCancelledStartSequenceId == nil
				or v14.startSequenceId ~= data.optimisticCancelledStartSequenceId
			then
				v15 = false
			else
				v15 = not turnState.isDone
			end

			if v15 then
				turnState = turnStateReducer.applySessionUpdate(
					turnState,
					{
						sessionUpdate = "state_change",
						state = "idle",
						stop_reason = "cancelled"
					},
					nil
				)
			end

			local includesPublishPlaceTool = publishToolUtils.includesPublishPlaceTool(turnState)
			v10 = includesPublishPlaceTool and true or v10
			local v16 = subagentTasks.fromTurnState(turnState)

			if v16 ~= nil then
				v13 = v16
			end

			local v17

			if not (sessionId == nil or v14.startSequenceId == nil) then
				v17 = `{sessionId}:{v14.startSequenceId}`
			end

			local v18 = not turnState.isDone
			local v19 = {
				kind = "assistant_turn",
				id = v17,
				isDone = turnState.isDone,
				turnState = turnState,
				turnKey = v17,
				startSequenceId = v14.startSequenceId,
				endSequenceId = v14.endSequenceId,
				isOptimisticallyCancelled = FFlagBuildAdUpsell and v15 and true or nil,
				optimisticLocalTools = 0,
				universeId = 0,
				sessionId = 0,
				turnFeedbackIds = 0
			}

			local v20 = if v18 then data.optimisticLocalTools else nil
			v19.optimisticLocalTools = v20
			v19.universeId = data.universeId
			v19.sessionId = sessionId
			v19.turnFeedbackIds = buildTurnFeedbackIds(v14, data)
			table.insert(v8, v19)

			v9 = includesPublishPlaceTool and turnState.isDone and #v8 or v9

			if v18 then
				v11 = #v8

				startSequenceId = v14.startSequenceId
				sequenceIds = v14.sequenceIds
				v12 = turnState
			end
		end
	end

	if v9 ~= nil then
		v8[v9].isLatestPublishTurn = true
	end

	local v14 = false
	local pendingUserMessage = data.pendingUserMessage
	local pendingUserImages = data.pendingUserImages or {}

	local pendingUserResourceAttachments = fFlagBuildExperienceChatResourceAttachments
		and data.pendingUserResourceAttachments
		or {}

	if
		pendingUserMessage ~= nil and pendingUserMessage ~= ""
		or #pendingUserImages > 0
		or #pendingUserResourceAttachments > 0
	then
		local pendingUserMessageAfterSequenceId = data.pendingUserMessageAfterSequenceId or -1
		local v15 = false

		for k, v17 in v6 do
			if v17.kind ~= "user_message" then
				continue
			end

			local sequenceId = v17.sequenceId

			if sequenceId ~= nil and pendingUserMessageAfterSequenceId < sequenceId then
				v15 = true
				break
			end
		end

		if not v15 then
			v14 = true

			local v18 = if sessionId ~= nil then `{sessionId}{module2.PENDING_USER_MESSAGE_ID_SUFFIX}` else nil
			local v17 = {
				kind = "user_message",
				id = v18,
				text = pendingUserMessage or "",
				images = nil,
				resourceAttachments = nil
			}

			if not FFlagBuildExperienceChatImageAttachments then
				pendingUserImages = nil
			end

			v17.images = pendingUserImages

			if not fFlagBuildExperienceChatResourceAttachments then
				pendingUserResourceAttachments = nil
			end

			v17.resourceAttachments = pendingUserResourceAttachments

			table.insert(v8, v17)
		end
	end

	local liveAssistantMessage = data.liveAssistantMessage
	local v15 = v8[#v8]
	local v16 = not (v15 == nil) and v15.kind == "assistant_turn"

	if v16 then
		local startSequenceId2 = v15.startSequenceId
		v16 = startSequenceId2 == nil or (data.pendingUserMessageAfterSequenceId or -1) < startSequenceId2
	end

	if liveAssistantMessage ~= nil and not v16 then
		local v17 = if sessionId ~= nil then `{sessionId}:live` else nil
		table.insert(v8, {
			kind = "assistant_turn",
			id = v17,
			isDone = false,
			turnKey = v17,
			loading = liveAssistantMessage.setupErrorText == nil or nil,
			setupErrorText = liveAssistantMessage.setupErrorText,
			universeId = data.universeId,
			turnFeedbackIds = {}
		})
	end

	return {
		messages = v8,
		includesPublishTool = v10,
		activeTurnItemIndex = v11,
		activeTurnState = v12,
		activeTurnStartSequenceId = startSequenceId,
		activeTurnSequenceIds = sequenceIds,
		subagentTaskState = v13,
		isAwaitingUserMessageEcho = v14,
		latestSequenceId = v7
	}
end

return parseSessionStream
