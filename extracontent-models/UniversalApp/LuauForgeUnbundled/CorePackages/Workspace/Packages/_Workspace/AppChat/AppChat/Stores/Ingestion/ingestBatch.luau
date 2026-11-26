require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local GetConversationMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore")
local GetConversationMessageListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore")
local IngestOperation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/IngestOperation")

local function ingestBatch(p2, items, p3, p4)
	local v5 = GetConversationMessageStore(false)
	local v6 = GetConversationMessageListStore(false)

	local v7 = {}
	local ids = {}

	for k, item in items do
		if not (item and item.id) then
			continue
		end

		v7[item.id] = item
		table.insert(ids, item.id)
	end

	if next(v7) ~= nil then
		v5.upsertMessages(v7)
	end

	if p3 == IngestOperation.AppendAndAdvanceCursor then
		v6.receivePage(p2, ids, p4)
		return ids
	end

	if p3 == IngestOperation.Append then
		if #ids > 0 then
			v6.appendMessages(p2, ids)
			return ids
		end
	elseif #ids > 0 then
		v6.prependMessages(p2, ids)
	end

	return ids
end

return ingestBatch
