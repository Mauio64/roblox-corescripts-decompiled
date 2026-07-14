local Message = require(script.Parent.Message)

return {
	mapTextChatMessage = function(p1, s1: string) -- line: 14
		-- upvalues: Message (copy)
		if p1.TextSource then
			return Message.createUserMessageFromTextChatMessage(p1, s1)
		end

		return Message.createSystemMessageFromTextChatMessage(p1)
	end,
	mapSendingMessage = function(p2, s2: string) -- line: 24
		-- upvalues: Message (copy)
		return Message.createUserMessageFromTextChatMessage(p2, s2)
	end,
	applyMessage = function(t1: {[any]: any}, p3) -- line: 33
		for v8, v9 in t1 do
			if v9.messageId == p3.messageId then
				local v10 = table.clone(t1)

				if p3.content == "" then
					table.remove(v10, v8)

					return v10
				end

				v10[v8] = p3

				return v10
			end
		end

		if p3.content == "" then
			return t1
		end

		local v11 = table.clone(t1)

		table.insert(v11, p3)

		return v11
	end
}
