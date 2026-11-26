require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")

local function set(p2, p3, p4)
	if p2[p3] == p4 then
		return p2
	end

	local clone = table.clone(p2)
	clone[p3] = p4
	return clone
end

local function updateConversationMessages(p2, p3, p4)
	local v5 = {}

	for k, v6 in p2[p4]:CreateIterator() do
		if not p3[p4]:Get(k) then
			table.insert(v5, v6)
		end
	end

	if #v5 > 0 then
		p3[p4] = p3[p4]:Insert(table.unpack(v5))
	end
end

local function updateConversationField(p2, p3, p4)
	if p3[p4] == nil then
		p3[p4] = p2[p4]
	end
end

local function updateConversationToState(p2, data)
	if data.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
		local idForFakeOneOnOne = Conversation.IdForFakeOneOnOne(data.participants)

		if
			p2[idForFakeOneOnOne] ~= nil
			and p2[idForFakeOneOnOne] ~= data
			and p2[idForFakeOneOnOne] ~= nil
		then
			p2 = table.clone(p2)
			p2[idForFakeOneOnOne] = nil
		end
	end

	local id = data.id
	local dataById

	if p2[id] == data then
		dataById = p2
	else
		dataById = table.clone(p2)
		dataById[id] = data
	end

	local v5 = p2[data.id]
	local v6 = dataById[data.id]

	if not (v6 and v5) then
		return dataById
	end

	updateConversationMessages(v5, v6, "messages")
	updateConversationMessages(v5, v6, "sendingMessages")

	if v6.previousCursor == nil then
		v6.previousCursor = v5.previousCursor
	end

	if v6.nextCursor == nil then
		v6.nextCursor = v5.nextCursor
	end

	if v6.fetchedOldestMessage == nil then
		v6.fetchedOldestMessage = v5.fetchedOldestMessage
	end

	return dataById
end

return updateConversationToState
