local function getConversationIds(t1: {[any]: any}) -- line: 2
	local t2 = {}

	for v4, v5 in t1 do
		t2[v4] = tostring(v5.id)
	end

	return t2
end

return getConversationIds
