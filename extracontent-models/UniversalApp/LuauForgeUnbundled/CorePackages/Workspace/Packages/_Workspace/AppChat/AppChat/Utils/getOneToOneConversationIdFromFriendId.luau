require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

return function(items, p2)
	for k, item in items do
		if not (item and item.type == "one_to_one" and item.participants) then
			continue
		end

		for k2, participant in item.participants do
			if participant == p2 then
				return k
			end
		end
	end

	return nil
end
