local function parsePymkItems(p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	local items = p2.items or p2

	if typeof(items) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		local item_id = item.item_id

		if item_id ~= nil and item_id ~= "" then
			table.insert(result, {
				id = tostring(item_id),
				rank = k,
				hasPendingFriendRequest = item.has_pending_friend_request == true
			})
		end
	end

	return result
end

return parsePymkItems
