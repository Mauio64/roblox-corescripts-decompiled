local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Models.ConversationChannels)

return function(t1: {[any]: any}, s1: string) -- line: 8
	for v4, v5 in t1 do
		if v5 and v5.type == "one_to_one" and v5.participants then
			for _, v7 in v5.participants do
				if v7 == s1 then
					return v4
				end
			end
		end
	end

	return nil
end
