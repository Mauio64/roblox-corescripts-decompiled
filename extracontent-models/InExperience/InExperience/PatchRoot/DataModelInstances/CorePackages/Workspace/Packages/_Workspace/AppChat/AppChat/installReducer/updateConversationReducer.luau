local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Models.ConversationChannels)

local Conversation = require(AppChat.Models.Conversation)

local function set(t1: {[any]: any}, p1, p2) -- line: 10
	if p2 == t1[p1] then
		return t1
	end

	local v10 = table.clone(t1)

	v10[p1] = p2

	return v10
end
local function updateConversationMessages(p3, p4, s1: string) -- line: 22
	local t2 = {}

	for v15, v16 in p3[s1]:CreateIterator() do
		if not p4[s1]:Get(v15) then
			table.insert(t2, v16)
		end
	end

	if #t2 > 0 then
		p4[s1] = p4[s1]:Insert(table.unpack(t2))
	end
end
local function updateConversationField(p5, p6, s2: string) -- line: 40
	if p6[s2] == nil then
		p6[s2] = p5[s2]
	end
end
local function updateConversationToState(t3: {[any]: any}, p7) -- line: 50
	-- upvalues: Conversation (copy), updateConversationMessages (copy)
	if p7.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local v22 = Conversation.IdForFakeOneOnOne(p7.participants)

		if t3[v22] ~= nil and p7 ~= t3[v22] then
			if t3[v22] == nil then
			else
				t3 = table.clone(t3)
				t3[v22] = nil
			end
		end
	end

	local id = p7.id
	local v24

	if p7 == t3[id] then
		v24 = t3
	else
		v24 = table.clone(t3)
		v24[id] = p7
	end

	local v25 = t3[p7.id]
	local v26 = v24[p7.id]

	if v26 and v25 then
		updateConversationMessages(v25, v26, "messages")
		updateConversationMessages(v25, v26, "sendingMessages")

		if v26.previousCursor == nil then
			v26.previousCursor = v25.previousCursor
		end

		if v26.nextCursor == nil then
			v26.nextCursor = v25.nextCursor
		end

		if v26.fetchedOldestMessage == nil then
			v26.fetchedOldestMessage = v25.fetchedOldestMessage
		end
	end

	return v24
end

return updateConversationToState
