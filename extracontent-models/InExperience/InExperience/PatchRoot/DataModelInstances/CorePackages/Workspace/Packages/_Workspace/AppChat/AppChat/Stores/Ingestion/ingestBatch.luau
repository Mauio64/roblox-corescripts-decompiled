local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.MessageData.Types)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestBatch(p: string, items, p2, p3: string?)
	local conversationMessageStore = GetConversationMessageStore(false)
	local conversationMessageListStore = GetConversationMessageListStore(false)

	local v = {}
	local ids = {}

	for _, item in items do
		if not (item and item.id) then
			continue
		end

		v[item.id] = item
		table.insert(ids, item.id)
	end

	if next(v) ~= nil then
		conversationMessageStore.upsertMessages(v)
	end

	if p2 == IngestOperation.AppendAndAdvanceCursor then
		conversationMessageListStore.receivePage(p, ids, p3)
		return ids
	end

	if p2 == IngestOperation.Append then
		if #ids > 0 then
			conversationMessageListStore.appendMessages(p, ids)
			return ids
		end
	elseif #ids > 0 then
		conversationMessageListStore.prependMessages(p, ids)
	end

	return ids
end

return ingestBatch
