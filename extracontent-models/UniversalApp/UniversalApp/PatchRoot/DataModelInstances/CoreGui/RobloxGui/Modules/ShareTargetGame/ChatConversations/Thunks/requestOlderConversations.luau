return function(p1, p2) -- line: 1
	return function(p3) -- line: 2
		-- upvalues: p2 (copy), p1 (copy)
		local v4 = p3:getState()

		if v4.ChatAppReducer.ConversationsAsync.oldestConversationIsFetched then
			return
		end

		local n1 = 0

		for _, _ in pairs(v4.ChatAppReducer.Conversations) do
			n1 += 1
		end

		local v8 = math.floor(n1 / p2)

		p1(v8 + 1)
	end
end
