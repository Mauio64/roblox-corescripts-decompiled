local AppChat = script:FindFirstAncestor("AppChat")
require(AppChat.Models.ConversationChannels)
local Conversation = require(AppChat.Models.Conversation)

local function set(p, id, data) -- 1 equivalent call inferred from this helper
	if p[id] == data then
		return p
	end

	local clone = table.clone(p)
	clone[id] = data
	return clone
end

local function updateConversationMessages(p, p2, p3: string)
	local v = {}

	for k, v2 in p[p3]:CreateIterator() do
		if not p2[p3]:Get(k) then
			table.insert(v, v2)
		end
	end

	if #v > 0 then
		p2[p3] = p2[p3]:Insert(table.unpack(v))
	end
end

local function updateConversationField(p, p2, p3: string) -- 3 equivalent calls inferred from this helper
	if p2[p3] == nil then
		p2[p3] = p[p3]
	end
end

local function updateConversationToState(p, data)
	if data.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local idForFakeOneOnOne = Conversation.IdForFakeOneOnOne(data.participants)

		if p[idForFakeOneOnOne] ~= nil and p[idForFakeOneOnOne] ~= data and p[idForFakeOneOnOne] ~= nil then
			p = table.clone(p)
			p[idForFakeOneOnOne] = nil
		end
	end

	local v = set(p, data.id, data) -- inferred equivalent call
	local v2 = p[data.id]
	local v3 = v[data.id]

	if v3 and v2 then
		updateConversationMessages(v2, v3, "messages")
		updateConversationMessages(v2, v3, "sendingMessages")
		updateConversationField(v2, v3, "previousCursor") -- inferred equivalent call
		updateConversationField(v2, v3, "nextCursor") -- inferred equivalent call
		updateConversationField(v2, v3, "fetchedOldestMessage") -- inferred equivalent call
	end

	return v
end

return updateConversationToState
