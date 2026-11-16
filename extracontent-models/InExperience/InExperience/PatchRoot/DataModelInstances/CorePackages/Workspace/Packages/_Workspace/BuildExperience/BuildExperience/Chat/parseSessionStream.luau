local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local chatTypes = require(script.Parent.chatTypes)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceChatResourceAttachments

local PublishToolUtils = CreatorAgentChat.PublishToolUtils
local TurnStateReducer = CreatorAgentChat.TurnStateReducer
local SubagentTasks = CreatorAgentChat.SubagentTasks

local function contentBlockToText(p) -- 2 equivalent calls inferred from this helper
	if p == nil or p.type ~= "text" or typeof(p.text) ~= "string" then
		return ""
	end

	return p.text
end

local function contentBlockToImage(p) -- 2 equivalent calls inferred from this helper
	if
		FFlagBuildExperienceChatImageAttachments
		and p ~= nil
		and p.type == "image"
		and typeof(p.uri) == "string"
		and p.uri ~= ""
	then
		return { uri = p.uri }
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
		local v = { type = "resource_link", name = data.name, uri = data.uri, mimeType = 0 }
		local mimeType

		if typeof(data.mimeType) == "string" then
			mimeType = data.mimeType
		end

		v.mimeType = mimeType
		return v
	end
end

local function contentBlocksToText(content)
	if typeof(content) ~= "table" then
		return ""
	end

	local v = {}

	for _, item in content do
		local v2 = contentBlockToText(item) -- inferred equivalent call

		if v2 ~= "" then
			table.insert(v, v2)
		end
	end

	return table.concat(v)
end

local function contentBlocksToImages(content)
	local result = {}

	if typeof(content) ~= "table" then
		return result
	end

	for _, item in content do
		local v = contentBlockToImage(item) -- inferred equivalent call

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

local function contentBlocksToResourceAttachments(content)
	local result = {}

	if typeof(content) ~= "table" then
		return result
	end

	for _, item in content do
		local v = contentBlockToResourceAttachment(item)

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

local function getSequenceId(p) -- 6 equivalent calls inferred from this helper
	local sequenceId = p.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end

local function asOptimisticallyCancelled(turnState) -- 1 equivalent call inferred from this helper
	return TurnStateReducer.applySessionUpdate(
		turnState,
		{ sessionUpdate = "state_change", state = "idle", stop_reason = "cancelled" },
		nil
	)
end

local function getMessageId(item) -- 1 equivalent call inferred from this helper
	local messageId = item.messageId

	if typeof(messageId) == "string" and messageId ~= "" then
		return messageId
	end

	return nil
end

local function isAssistantTurnUpdate(sessionUpdate): boolean -- 1 equivalent call inferred from this helper
	return sessionUpdate == "agent_message"
		or sessionUpdate == "agent_message_chunk"
		or sessionUpdate == "tool_call_update"
		or sessionUpdate == "tool_call_content_chunk"
		or sessionUpdate == "state_change"
end

local function hasAssistantTurnContent(data): boolean -- 2 equivalent calls inferred from this helper
	return data.assistantText ~= "" or #data.activityItems > 0 or data.toolCallCount > 0
end

local function shouldEmitAssistantTurn(data) -- 1 equivalent call inferred from this helper
	return hasAssistantTurnContent(data) -- inferred equivalent call
		or #data.pendingAgentMessageContent > 0
		or data.status == "cancelled"
		or data.stopReason == "cancelled"
		or data.stopReason == "error"
end

local function orderedBySequenceId(p)
	local clone = table.clone(p)
	table.sort(clone, function(a, b): boolean
		return (getSequenceId(a) or -1) < (getSequenceId(b) or -1) -- inferred equivalent call
	end)

	return clone
end

local function parseChatItems(clone, p: string)
	local chatItems = {}
	local turnState = nil
	local startSequenceId = nil
	local endSequenceId = nil
	local sequenceIds = {}
	local v = false

	local function flushActiveTurn()
		if turnState ~= nil and v and shouldEmitAssistantTurn(turnState) then -- inferred equivalent call
			table.insert(chatItems, {
				kind = "assistant_turn",
				startSequenceId = startSequenceId,
				endSequenceId = endSequenceId,
				sequenceIds = sequenceIds,
				turnState = turnState
			})
		end

		turnState = nil
		startSequenceId = nil
		endSequenceId = nil
		sequenceIds = {}
		v = false
	end

	local function appendUserMessage(messageId: string?, sequenceId: number?, text: string, images, list)
		if text == "" and #images == 0 and #list == 0 then
			return
		end

		local chatItem = chatItems[#chatItems]

		if chatItem == nil or chatItem.kind ~= "user_message" or chatItem.messageId ~= messageId then
			table.insert(chatItems, {
				kind = "user_message",
				messageId = messageId,
				sequenceId = sequenceId,
				text = text,
				images = images,
				resourceAttachments = list
			})
			return
		end

		chatItem.text ..= text

		for _, item in images do
			table.insert(chatItem.images, item)
		end

		for _, item in list do
			table.insert(chatItem.resourceAttachments, item)
		end
	end

	for _, item in clone do
		local sessionUpdate = item.sessionUpdate
		local sequenceId = getSequenceId(item) -- inferred equivalent call

		if sessionUpdate == "user_message" or sessionUpdate == "user_message_chunk" then
			if turnState ~= nil and hasAssistantTurnContent(turnState) then -- inferred equivalent call
				flushActiveTurn()
			end

			local v2

			if sessionUpdate == "user_message" then
				v2 = contentBlocksToText(item.content)
			else
				v2 = contentBlockToText(item.content) -- inferred equivalent call
			end

			local v3

			if sessionUpdate == "user_message" then
				v3 = contentBlocksToImages(item.content)
			else
				v3 = {}
				local v4 = contentBlockToImage(item.content) -- inferred equivalent call

				if v4 ~= nil then
					table.insert(v3, v4)
				end
			end

			local v4

			if FFlagBuildExperienceChatResourceAttachments then
				if sessionUpdate == "user_message" then
					v4 = contentBlocksToResourceAttachments(item.content)
				else
					v4 = {}
					local v5 = contentBlockToResourceAttachment(item.content)

					if v5 ~= nil then
						table.insert(v4, v5)
					end
				end
			else
				v4 = {}
			end

			appendUserMessage(getMessageId(item), sequenceId, v2, v3, v4) -- inferred equivalent call
		elseif isAssistantTurnUpdate(sessionUpdate) then -- inferred equivalent call
			if turnState == nil then
				turnState = TurnStateReducer.createEmptyTurnState(p)
			end

			if sessionUpdate == "state_change" and item.state == "running" then
				v = true
			end

			if sequenceId ~= nil then
				table.insert(sequenceIds, sequenceId)

				if startSequenceId == nil or sequenceId < startSequenceId then
					startSequenceId = sequenceId
				end

				if endSequenceId == nil or endSequenceId < sequenceId then
					endSequenceId = sequenceId
				end
			end

			turnState = TurnStateReducer.applySessionUpdate(turnState, item, {
				sequenceNumber = sequenceId
			})

			if turnState.isDone then
				flushActiveTurn()
			end
		end
	end

	flushActiveTurn()
	return chatItems
end

local function buildUserMessageItem(data, sessionId: string?)
	local id

	if sessionId == nil or data.sequenceId == nil then
		id = data.messageId
	else
		id = `{sessionId}:{data.sequenceId}:user`
	end

	local userMessageItem = {
		kind = "user_message",
		id = id,
		text = data.text,
		images = 0,
		resourceAttachments = 0
	}
	local images

	if FFlagBuildExperienceChatImageAttachments then
		images = data.images
	end

	userMessageItem.images = images
	local resourceAttachments

	if FFlagBuildExperienceChatResourceAttachments and #data.resourceAttachments > 0 then
		resourceAttachments = data.resourceAttachments
	end

	userMessageItem.resourceAttachments = resourceAttachments
	return userMessageItem
end

local function getEventMeta(p, p2: number?) -- 2 equivalent calls inferred from this helper
	if p2 == nil or p.eventMetaBySequenceId == nil then
		return nil
	end

	return p.eventMetaBySequenceId[p2]
end

local function resolveTurnId(turnState, p)
	local eventMeta = getEventMeta(turnState, p.endSequenceId) -- inferred equivalent call

	if eventMeta ~= nil and eventMeta.turnId ~= nil then
		return eventMeta.turnId
	end

	for _, sequenceId in p.sequenceIds do
		local eventMeta2 = getEventMeta(turnState, sequenceId) -- inferred equivalent call

		if eventMeta2 ~= nil and eventMeta2.turnId ~= nil then
			return eventMeta2.turnId
		end
	end

	return nil
end

local function buildTurnFeedbackIds(p, data)
	local latestSuccessfulResult = PublishToolUtils.getLatestSuccessfulResult(p.turnState)
	local turnFeedbackIds = {
		universeId = data.universeId,
		placeId = data.placeId,
		sessionId = data.sessionId,
		sequenceId = p.endSequenceId,
		turnId = resolveTurnId(p.turnState, p),
		publishedVersionNumber = 0,
		rollbackTargetVersionNumber = 0
	}
	local publishedVersionNumber

	if latestSuccessfulResult ~= nil then
		publishedVersionNumber = latestSuccessfulResult.publishedVersionNumber
	end

	turnFeedbackIds.publishedVersionNumber = publishedVersionNumber
	local rollbackTargetVersionNumber

	if latestSuccessfulResult ~= nil then
		rollbackTargetVersionNumber = latestSuccessfulResult.rollbackTargetVersionNumber
	end

	turnFeedbackIds.rollbackTargetVersionNumber = rollbackTargetVersionNumber
	return turnFeedbackIds
end

local function parseSessionStream(items, data)
	local sessionId = data.sessionId
	local clone = table.clone(items)
	table.sort(clone, function(a, b): boolean
		return (getSequenceId(a) or -1) < (getSequenceId(b) or -1) -- inferred equivalent call
	end)

	local v = parseChatItems(clone, sessionId or "")
	local latestSequenceId = nil

	for _, item in items do
		local sequenceId = getSequenceId(item) -- inferred equivalent call

		if sequenceId ~= nil and (latestSequenceId == nil or latestSequenceId < sequenceId) then
			latestSequenceId = sequenceId
		end
	end

	local messages = {}
	local v2 = nil
	local includesPublishTool = false
	local activeTurnItemIndex = nil
	local activeTurnState = nil
	local startSequenceId = nil
	local sequenceIds = nil
	local subagentTaskState = nil

	for _, v3 in v do
		if v3.kind == "user_message" then
			table.insert(messages, buildUserMessageItem(v3, sessionId))
		else
			local turnState = v3.turnState
			local v4

			if
				data.optimisticCancelledStartSequenceId == nil
				or v3.startSequenceId ~= data.optimisticCancelledStartSequenceId
			then
				v4 = false
			else
				v4 = not turnState.isDone
			end

			if v4 then
				turnState = asOptimisticallyCancelled(turnState) -- inferred equivalent call
			end

			local includesPublishPlaceTool = PublishToolUtils.includesPublishPlaceTool(turnState)
			includesPublishTool = includesPublishPlaceTool and true or includesPublishTool
			local v5 = SubagentTasks.fromTurnState(turnState)

			if v5 ~= nil then
				subagentTaskState = v5
			end

			local v6

			if not (sessionId == nil or v3.startSequenceId == nil) then
				v6 = `{sessionId}:{v3.startSequenceId}`
			end

			local v7 = not turnState.isDone
			local v8 = {
				kind = "assistant_turn",
				id = v6,
				isDone = turnState.isDone,
				turnState = turnState,
				turnKey = v6,
				startSequenceId = v3.startSequenceId,
				endSequenceId = v3.endSequenceId,
				isOptimisticallyCancelled = FFlagBuildAdUpsell and v4 and true or nil,
				optimisticLocalTools = 0,
				universeId = 0,
				sessionId = 0,
				turnFeedbackIds = 0
			}
			local optimisticLocalTools

			if v7 then
				optimisticLocalTools = data.optimisticLocalTools
			end

			v8.optimisticLocalTools = optimisticLocalTools
			v8.universeId = data.universeId
			v8.sessionId = sessionId
			v8.turnFeedbackIds = buildTurnFeedbackIds(v3, data)
			table.insert(messages, v8)

			v2 = includesPublishPlaceTool and turnState.isDone and #messages or v2

			if v7 then
				activeTurnItemIndex = #messages

				startSequenceId = v3.startSequenceId
				sequenceIds = v3.sequenceIds
				activeTurnState = turnState
			end
		end
	end

	if v2 ~= nil then
		messages[v2].isLatestPublishTurn = true
	end

	local isAwaitingUserMessageEcho = false
	local pendingUserMessage = data.pendingUserMessage
	local pendingUserImages = data.pendingUserImages or {}

	local pendingUserResourceAttachments = FFlagBuildExperienceChatResourceAttachments
		and data.pendingUserResourceAttachments
		or {}

	if
		pendingUserMessage ~= nil and pendingUserMessage ~= ""
		or #pendingUserImages > 0
		or #pendingUserResourceAttachments > 0
	then
		local pendingUserMessageAfterSequenceId = data.pendingUserMessageAfterSequenceId or -1
		local v3 = false

		for _, v4 in v do
			if v4.kind ~= "user_message" then
				continue
			end

			local sequenceId = v4.sequenceId

			if sequenceId ~= nil and pendingUserMessageAfterSequenceId < sequenceId then
				v3 = true
				break
			end
		end

		if not v3 then
			isAwaitingUserMessageEcho = true
			local id

			if sessionId ~= nil then
				id = `{sessionId}{chatTypes.PENDING_USER_MESSAGE_ID_SUFFIX}`
			end

			local v4 = {
				kind = "user_message",
				id = id,
				text = pendingUserMessage or "",
				images = nil,
				resourceAttachments = nil
			}

			if not FFlagBuildExperienceChatImageAttachments then
				pendingUserImages = nil
			end

			v4.images = pendingUserImages

			if not FFlagBuildExperienceChatResourceAttachments then
				pendingUserResourceAttachments = nil
			end

			v4.resourceAttachments = pendingUserResourceAttachments

			table.insert(messages, v4)
		end
	end

	local liveAssistantMessage = data.liveAssistantMessage
	local v3 = messages[#messages]
	local v4

	if v3 == nil then
		v4 = false
	else
		v4 = v3.kind == "assistant_turn"
	end

	if v4 then
		local startSequenceId2 = v3.startSequenceId
		v4 = startSequenceId2 == nil or (data.pendingUserMessageAfterSequenceId or -1) < startSequenceId2
	end

	if liveAssistantMessage ~= nil and not v4 then
		local v5

		if sessionId ~= nil then
			v5 = `{sessionId}:live`
		end

		table.insert(messages, {
			kind = "assistant_turn",
			id = v5,
			isDone = false,
			turnKey = v5,
			loading = liveAssistantMessage.setupErrorText == nil or nil,
			setupErrorText = liveAssistantMessage.setupErrorText,
			universeId = data.universeId,
			turnFeedbackIds = {}
		})
	end

	return {
		messages = messages,
		includesPublishTool = includesPublishTool,
		activeTurnItemIndex = activeTurnItemIndex,
		activeTurnState = activeTurnState,
		activeTurnStartSequenceId = startSequenceId,
		activeTurnSequenceIds = sequenceIds,
		subagentTaskState = subagentTaskState,
		isAwaitingUserMessageEcho = isAwaitingUserMessageEcho,
		latestSequenceId = latestSequenceId
	}
end

return parseSessionStream
