return function(callback, p2)
	return function(object)
		local state = object:getState()

		if state.ChatAppReducer.ConversationsAsync.oldestConversationIsFetched then
			return
		end

		local count = 0

		for k, conversation in pairs(state.ChatAppReducer.Conversations) do
			count += 1
		end

		callback(math.floor(count / p2) + 1)
	end
end
