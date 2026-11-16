local function getConversationIds(items)
	local ids = {}

	for k, item in items do
		ids[k] = tostring(item.id)
	end

	return ids
end

return getConversationIds
