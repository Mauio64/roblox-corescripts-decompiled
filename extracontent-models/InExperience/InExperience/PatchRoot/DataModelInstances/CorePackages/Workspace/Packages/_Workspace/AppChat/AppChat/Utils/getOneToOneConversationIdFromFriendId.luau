local AppChat = script:FindFirstAncestor("AppChat")
require(AppChat.Models.ConversationChannels)

return function(items, p: string)
	for k, item in items do
		if not (item and item.type == "one_to_one" and item.participants) then
			continue
		end

		for _, participant in item.participants do
			if participant == p then
				return k
			end
		end
	end

	return nil
end
