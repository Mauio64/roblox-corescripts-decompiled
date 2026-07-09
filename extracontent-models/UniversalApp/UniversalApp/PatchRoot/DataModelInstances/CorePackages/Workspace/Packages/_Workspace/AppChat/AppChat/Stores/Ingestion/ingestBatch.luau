local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.MessageData.Types)

local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestBatch(s1: string, t1: {[any]: any}, p1, s2: string?) -- line: 31
	-- upvalues: GetConversationMessageStore (copy), GetConversationMessageListStore (copy), IngestOperation (copy)
	local v10 = GetConversationMessageStore(false)
	local v11 = GetConversationMessageListStore(false)
	local t2 = {}
	local t3 = {}

	for _, v15 in t1 do
		if v15 and v15.id then
			t2[v15.id] = v15
			table.insert(t3, v15.id)
		end
	end

	if next(t2) ~= nil then
		v10.upsertMessages(t2)
	end

	if p1 == IngestOperation.AppendAndAdvanceCursor then
		v11.receivePage(s1, t3, s2)

		return t3
	end

	if p1 == IngestOperation.Append then
		if #t3 > 0 then
			v11.appendMessages(s1, t3)

			return t3
		end
	elseif #t3 > 0 then
		v11.prependMessages(s1, t3)
	end

	return t3
end

return ingestBatch
