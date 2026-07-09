local AppChat = script:FindFirstAncestor("AppChat")
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)

local function extractTimestamp(p1) -- line: 6
	if p1.sent and p1.sent.ToIsoDate then
		return p1.sent:ToIsoDate()
	end

	return DateTime.now():ToIsoDate()
end
local function buildConversationMessage(p2) -- line: 13
	local v10 = p2.id or p2.messageId

	if not v10 then
		return nil, nil
	end

	return v10, {
		id = v10,
		content = p2.content,
		sender_user_id = if not p2.senderTargetId then nil else tonumber(p2.senderTargetId),
		type = p2.messageType ~= "System" and "user" or "system",
		created_at = if not p2.sent or not p2.sent.ToIsoDate then DateTime.now():ToIsoDate() else p2.sent:ToIsoDate(),
		moderation_type = p2.moderationType,
		messageType = p2.messageType,
		gameLink = p2.gameLink
	}
end
local function collectFromOrderedMap(p3) -- line: 31
	-- upvalues: buildConversationMessage (copy)
	local t1 = {}
	local t2 = {}

	for _, v15 in p3.keys do
		local v16 = p3.values[v15]
		local v17, v18 = buildConversationMessage(v16)

		if v17 then
			t1[v17] = v18
			table.insert(t2, v17)
		end
	end

	return t1, t2
end
local function collectFromValuesTable(p4) -- line: 45
	-- upvalues: buildConversationMessage (copy)
	local t3 = {}
	local t4 = {}

	for _, v23 in p4 do
		local v24, v25 = buildConversationMessage(v23)

		if v24 then
			t3[v24] = v25
			table.insert(t4, v24)
		end
	end

	return t3, t4
end

return function(p5) -- line: 58
	-- upvalues: GetConversationMessageViewModelStore (copy), GetConversationStore (copy), collectFromOrderedMap (copy), collectFromValuesTable (copy)
	if not p5 then
		return
	end

	local v27 = GetConversationMessageViewModelStore(false)
	local conversationMessageStore = v27.conversationMessageStore
	local conversationMessageListStore = v27.conversationMessageListStore
	local v30 = GetConversationStore(false)

	conversationMessageStore.clear()
	conversationMessageListStore.clear()
	v30.clear()

	for v31, v32 in p5 do
		v30.upsertConversation(v32)

		local messages = v32.messages

		if messages then
			local v34 = nil
			local v35 = nil

			if messages.keys and #messages.keys > 0 then
				v34, v35 = collectFromOrderedMap(messages)
			elseif messages.values then
				v34, v35 = collectFromValuesTable(messages.values)
			end

			if v34 and next(v34) then
				conversationMessageStore.upsertMessages(v34)
				conversationMessageListStore.prependMessages(v31, v35)
			end
		end
	end
end
